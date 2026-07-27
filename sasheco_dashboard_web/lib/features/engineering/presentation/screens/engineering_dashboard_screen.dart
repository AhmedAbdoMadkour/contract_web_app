import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_cubit.dart';
import 'package:sasheco_dashboard_web/features/engineering/presentation/cubit/engineering_state.dart';

class EngineeringDashboardScreen extends StatefulWidget {
  const EngineeringDashboardScreen({super.key});

  @override
  State<EngineeringDashboardScreen> createState() => _EngineeringDashboardScreenState();
}

class _EngineeringDashboardScreenState extends State<EngineeringDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EngineeringCubit>().fetchProjects();
    });
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
          
          String projectName = AppLocalizations.of(context)?.projectAlphaTerminalExpansion ?? 'Project: Alpha Terminal Expansion';
          String projectId = '';
          
          if (state is EngineeringProjectsLoaded && state.projects.isNotEmpty) {
            projectName = state.projects.first.name;
            projectId = state.projects.first.id;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, projectName, projectId),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _ContractItemsCard(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _TermsAndConditionsCard(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _PricingAndQuantitiesCard(),
            const SizedBox(height: 24),
            _ProjectDrawingsCard(),
            const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String projectName, String projectId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)?.contractDetails ?? 'Contract Details',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting PDF...')),
                );
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
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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
  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)?.contractItemsDefinition ?? 'Contract Items Definition',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                onPressed: () {
                  context.push('/engineering/create');
                },
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: Text(AppLocalizations.of(context)?.addItem ?? 'Add Item',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: const WidgetStatePropertyAll(AppColors.background),
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context)?.itemId ?? 'Item ID')),
                DataColumn(label: Text(AppLocalizations.of(context)?.description ?? 'Description')),
                DataColumn(label: Text(AppLocalizations.of(context)?.category ?? 'Category')),
                DataColumn(label: Text(AppLocalizations.of(context)?.status ?? 'Status')),
                DataColumn(label: Text(AppLocalizations.of(context)?.actions ?? 'Actions')),
              ],
              rows: [
                _buildItemRow('ITM-001', 'Foundation Concrete', 'Materials', 'Approved', AppColors.success),
                _buildItemRow('ITM-002', 'Steel Reinforcement', 'Materials', 'In Review', AppColors.warning),
                _buildItemRow('ITM-003', 'Site Excavation', 'Labor', 'Draft', AppColors.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildItemRow(String id, String desc, String category, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(desc)),
        DataCell(Text(category)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
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
  final List<String> clauses = [
    'Clause 4.2 Liability',
    'Clause 5.1 Payment Terms',
    'Clause 6.3 Delivery Schedule',
    'Clause 7.0 Warranties',
  ];

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)?.termsConditions ?? 'Terms & Conditions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clauses.length,
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
                    Text(
                      clauses[index],
                      style: const TextStyle(fontWeight: FontWeight.w500),
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

class _PricingAndQuantitiesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)?.pricingQuantities ?? 'Pricing & Quantities',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Total: \$1,450,000.00',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: const WidgetStatePropertyAll(AppColors.background),
              columns: [
                DataColumn(label: Text(AppLocalizations.of(context)?.itemId ?? 'Item ID')),
                DataColumn(label: Text(AppLocalizations.of(context)?.description ?? 'Description')),
                DataColumn(label: Text(AppLocalizations.of(context)?.qty ?? 'QTY')),
                DataColumn(label: Text(AppLocalizations.of(context)?.unitPrice ?? 'UNIT PRICE')),
                DataColumn(label: Text(AppLocalizations.of(context)?.total ?? 'TOTAL')),
              ],
              rows: [
                _buildPricingRow('ITM-001', 'Foundation Concrete', '500', '1200.00', '\$600,000.00'),
                _buildPricingRow('ITM-002', 'Steel Reinforcement', '250', '3400.00', '\$850,000.00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildPricingRow(String id, String desc, String qty, String price, String total) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(desc)),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 100,
              child: TextFormField(
                initialValue: qty,
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
                initialValue: price,
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

class _ProjectDrawingsCard extends StatefulWidget {
  @override
  State<_ProjectDrawingsCard> createState() => _ProjectDrawingsCardState();
}

class _ProjectDrawingsCardState extends State<_ProjectDrawingsCard> {
  bool _isDragging = false;
  final List<String> _uploadedFiles = ['S-101 Foundation Plan', 'A-202 Elevations'];

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)?.projectDrawings ?? 'Project Drawings',
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
                  children: _uploadedFiles.map((filename) => _buildFileItem(filename)).toList(),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: DropTarget(
                  onDragDone: (detail) {
                    setState(() {
                      _isDragging = false;
                      _uploadedFiles.addAll(detail.files.map((e) => e.name));
                    });
                  },
                  onDragEntered: (detail) {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onDragExited: (detail) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: _isDragging ? AppColors.primary : AppColors.textDisabled,
                    ),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: _isDragging ? AppColors.primary.withOpacity(0.05) : AppColors.background.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: _isDragging ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(AppLocalizations.of(context)?.dragAndDropFilesHere ?? 'Drag and drop files here',
                              style: TextStyle(
                                color: _isDragging ? AppColors.primary : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  _uploadedFiles.add('mock_file.pdf');
                                });
                              },
                              child: Text(AppLocalizations.of(context)?.browseFiles ?? 'Browse Files'),
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
