import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/core/widgets/module_exit_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_state.dart';
import 'package:sasheco_dashboard_web/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/data/model/contract_model.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/screens/create_contract_item_dialog.dart';

class EngineeringDashboardScreen extends StatefulWidget {
  const EngineeringDashboardScreen({super.key});

  @override
  State<EngineeringDashboardScreen> createState() => _EngineeringDashboardScreenState();
}

class _EngineeringDashboardScreenState extends State<EngineeringDashboardScreen> {
  final TextEditingController _paymentTermsController = TextEditingController();

  @override
  void dispose() {
    _paymentTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<EngineeringCubit, EngineeringState>(
        listener: (context, state) {
          if (state is EngineeringStatusUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Project status updated successfully!')),
            );
          } else if (state is EngineeringError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is EngineeringLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          String projectName = 'projectAlphaTerminalExpansion'.tr();
          String projectId = '';
          
          if (state is EngineeringProjectsLoaded && state.projects.isNotEmpty) {
            projectName = state.projects.first.name;
            projectId = state.projects.first.id;
          } else if (state is EngineeringContractsLoaded && state.projects.isNotEmpty) {
            projectName = state.projects.first.name;
            projectId = state.projects.first.id;
          }

          List<ContractModel> contracts = [];
          bool isDragging = false;
          if (state is EngineeringContractsLoaded) {
            contracts = state.contracts;
            isDragging = state.isDragging;
          }

          final authState = context.read<AuthCubit>().state;
          bool canEdit = false;
          if (authState is AuthSuccess && authState.user.position == 'ProjectManager') {
            canEdit = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, projectName, projectId, contracts),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _ContractItemsCard(contracts: contracts, canEdit: canEdit),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _TermsAndConditionsCard(contracts: contracts),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _PricingAndQuantitiesCard(contracts: contracts),
            const SizedBox(height: 24),
            _ProjectDrawingsCard(contracts: contracts, isDragging: isDragging),
            const SizedBox(height: 24),
            _BaseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Terms',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _paymentTermsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter payment terms here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Just a save stub, backend handles items upload individually
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Progress saved locally.')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (contracts.isNotEmpty) {
                      context.read<EngineeringCubit>().submitContract(
                        contracts.first.id,
                        _paymentTermsController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No contract found to submit.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Submit Contract', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String projectName, String projectId, List<ContractModel> contracts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('contractDetails'.tr(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(projectName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {
                // PDF Export using the backend API
                if (contracts.isNotEmpty) {
                  final contractId = contracts.first.id;
                  // In Web, we can just open the URL in a new tab. 
                  // Assuming the API is running on localhost:5001 or through reverse proxy
                  final url = 'http://localhost:5001/api/Contracts/$contractId/export-pdf';
                  launchUrl(Uri.parse(url));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No contract found to export.')),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('EXPORT PDF', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                if (projectId.isNotEmpty) {
                  context.read<EngineeringCubit>().updateProjectStatus(projectId, 'Approved');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No project selected to save changes.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            const ModuleExitButton(),
          ],
        ),
      ],
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;

  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ContractItemsCard extends StatelessWidget {
  final List<ContractModel> contracts;
  final bool canEdit;

  const _ContractItemsCard({required this.contracts, required this.canEdit});

  @override
  Widget build(BuildContext context) {
    // Determine if we should show edit controls (temporarily allowing for admin/testing)
    final bool showEditControls = true; 
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('contractItemsDefinition'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (showEditControls)
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            if (contracts.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please create a contract first before uploading BOQ.')),
                              );
                              return;
                            }
                            FilePickerResult? result = await FilePicker.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xls', 'xlsx', 'csv'],
                            );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Uploading Excel BOQ: ${result.files.first.name} ...')),
                              );
                              context.read<EngineeringCubit>().uploadBulkItems(
                                contracts.first.id,
                                result.files.first.bytes,
                                result.files.first.name,
                              );
                            }
                          },
                          icon: const Icon(Icons.upload_file, color: AppColors.primary),
                          label: const Text('Upload BOQ',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () {
                            if (contracts.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => CreateContractItemDialog(contractId: contracts.first.id),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please create a contract first before adding items.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          label: Text('addItem'.tr(),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (contracts.isEmpty || contracts.expand((c) => c.items).isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text('No items defined.', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor: WidgetStatePropertyAll(AppColors.background.withOpacity(0.5)),
                    columns: [
                      DataColumn(label: Text('Item Code')),
                      DataColumn(label: Text('Item Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Item Price')),
                      DataColumn(label: Text('Total')),
                      if (canEdit) DataColumn(label: Text('actions'.tr())),
                    ],
                    rows: contracts.expand((contract) {
                      return contract.items.map((item) {
                        return _buildItemRow(item, contract, canEdit);
                      });
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildItemRow(ContractItemModel item, ContractModel contract, bool canEdit) {
    return DataRow(
      cells: [
        DataCell(Text(item.itemCode, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(item.itemName)),
        DataCell(Text(item.quantity.toString())),
        DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
        DataCell(Text('\$${item.total.toStringAsFixed(2)}')),
        if (canEdit)
          DataCell(
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              onPressed: () {},
            ),
          ),
      ],
    );
  }
}

class _TermsAndConditionsCard extends StatelessWidget {
  final List<ContractModel> contracts;
  
  const _TermsAndConditionsCard({required this.contracts});

  @override
  Widget build(BuildContext context) {
    List<ContractTermModel> terms = [];
    if (contracts.isNotEmpty) {
      terms = contracts.first.terms;
    }

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('termsConditions'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (terms.isEmpty)
             const Padding(
               padding: EdgeInsets.all(16.0),
               child: Center(child: Text("No terms available.")),
             )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: terms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          terms[index].title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.edit, size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PricingAndQuantitiesCard extends StatefulWidget {
  final List<ContractModel> contracts;

  const _PricingAndQuantitiesCard({required this.contracts});

  @override
  State<_PricingAndQuantitiesCard> createState() => _PricingAndQuantitiesCardState();
}

class _PricingAndQuantitiesCardState extends State<_PricingAndQuantitiesCard> {
  final Map<String, TextEditingController> _qtyControllers = {};
  final Map<String, TextEditingController> _priceControllers = {};
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void didUpdateWidget(covariant _PricingAndQuantitiesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contracts != oldWidget.contracts) {
      _initializeData();
    }
  }

  void _initializeData() {
    _totalAmount = 0.0;
    for (var contract in widget.contracts) {
      for (var item in contract.items) {
        final qtyCtrl = TextEditingController(text: item.quantity.toString());
        final priceCtrl = TextEditingController(text: item.price.toStringAsFixed(2));
        
        qtyCtrl.addListener(_calculateTotal);
        priceCtrl.addListener(_calculateTotal);

        _qtyControllers[item.id] = qtyCtrl;
        _priceControllers[item.id] = priceCtrl;
        
        _totalAmount += (item.price * item.quantity);
      }
    }
  }

  void _calculateTotal() {
    double newTotal = 0.0;
    for (var contract in widget.contracts) {
      for (var item in contract.items) {
        final qtyText = _qtyControllers[item.id]?.text ?? '0';
        final priceText = _priceControllers[item.id]?.text ?? '0';
        final qty = double.tryParse(qtyText) ?? 0.0;
        final price = double.tryParse(priceText) ?? 0.0;
        newTotal += (qty * price);
      }
    }
    setState(() {
      _totalAmount = newTotal;
    });
  }

  @override
  void dispose() {
    for (var ctrl in _qtyControllers.values) {
      ctrl.dispose();
    }
    for (var ctrl in _priceControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('pricingQuantities'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Total: \$${_totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.contracts.isEmpty)
             const Padding(
               padding: EdgeInsets.all(16.0),
               child: Center(child: Text("No pricing data available.")),
             )
          else
            SizedBox(
              width: double.infinity,
              child: DataTable(
                headingRowColor: const WidgetStatePropertyAll(AppColors.background),
                columns: [
                  DataColumn(label: Text('Item Code')),
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('qty'.tr())),
                  DataColumn(label: Text('unitPrice'.tr())),
                  DataColumn(label: Text('total'.tr())),
                ],
                rows: widget.contracts.expand((contract) {
                  return contract.items.map((item) {
                    final qtyCtrl = _qtyControllers[item.id];
                    final priceCtrl = _priceControllers[item.id];
                    final qty = double.tryParse(qtyCtrl?.text ?? '0') ?? 0.0;
                    final price = double.tryParse(priceCtrl?.text ?? '0') ?? 0.0;
                    final total = qty * price;
                    
                    return _buildPricingRow(
                      item.itemCode,
                      item.itemName,
                      qtyCtrl,
                      priceCtrl,
                      '\$${total.toStringAsFixed(2)}',
                    );
                  });
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  DataRow _buildPricingRow(String itemCode, String itemName, TextEditingController? qtyCtrl, TextEditingController? priceCtrl, String total) {
    return DataRow(
      cells: [
        DataCell(Text(itemCode, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(itemName)),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 100,
              child: TextFormField(
                controller: qtyCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 140,
              child: TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ),
        DataCell(Text(total, style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class _ProjectDrawingsCard extends StatelessWidget {
  final List<ContractModel> contracts;
  final bool isDragging;

  const _ProjectDrawingsCard({required this.contracts, required this.isDragging});

  @override
  Widget build(BuildContext context) {
    List<DrawingAttachmentModel> drawings = [];
    if (contracts.isNotEmpty) {
      drawings = contracts.first.drawings;
    }

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('projectDrawings'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: drawings.map((d) => _buildFileItem(d.fileName)).toList(),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: DropTarget(
                  onDragDone: (detail) {
                    context.read<EngineeringCubit>().setDragging(false);
                    if (contracts.isNotEmpty) {
                      context.read<EngineeringCubit>().uploadDrawing(
                        contracts.first.id,
                        detail.files,
                        detail.files.first.name,
                      );
                    }
                  },
                  onDragEntered: (detail) {
                    context.read<EngineeringCubit>().setDragging(true);
                  },
                  onDragExited: (detail) {
                    context.read<EngineeringCubit>().setDragging(false);
                  },
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: isDragging ? AppColors.primary : AppColors.textDisabled,
                    ),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDragging ? AppColors.primary.withOpacity(0.05) : AppColors.background.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: isDragging ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text('dragAndDropFilesHere'.tr(),
                              style: TextStyle(
                                color: isDragging ? AppColors.primary : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.pickFiles();
                                if (result != null && contracts.isNotEmpty) {
                                  context.read<EngineeringCubit>().uploadDrawing(
                                    contracts.first.id,
                                    result.files.first.bytes,
                                    result.files.first.name,
                                  );
                                }
                              },
                              child: Text('browseFiles'.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(String filename) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            filename,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.gap = 6.0,
    this.dashLength = 8.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final Path path = Path()..addRRect(rrect);

    final Path dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashLength : gap;
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
