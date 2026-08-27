import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildContractItemsCard(context),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildTermsCard(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildPricingCard(),
            const SizedBox(height: 24),
            _buildDrawingsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contract Details',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Alpha Construction',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('EXPORT PDF', style: TextStyle(color: AppColors.textPrimary)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('SAVE CHANGES', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.exit_to_app, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildContractItemsCard(BuildContext context) {
    return _buildCard(
      title: 'Contract Items Definition',
      actions: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file, size: 18),
          label: const Text('Import Excel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: const Text('Add Item', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
          ),
        ),
      ],
      child: _buildTable(
        headers: ['Item ID', 'Description', 'Quantity', 'Price', 'Vendor'],
        rows: [],
        emptyMessage: 'No items defined.',
      ),
    );
  }

  Widget _buildTermsCard() {
    return _buildCard(
      title: 'Terms & Conditions',
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(64.0),
          child: Text('No terms available.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildPricingCard() {
    return _buildCard(
      title: 'Pricing & Quantities',
      trailing: const Text(
        'Total: \$0.00',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      child: _buildTable(
        headers: ['Item ID', 'Description', 'QTY', 'UNIT PRICE', 'TOTAL'],
        rows: [],
        emptyMessage: '',
      ),
    );
  }

  Widget _buildDrawingsCard() {
    return _buildCard(
      title: 'Project Drawings',
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: DashRectPainter(color: Colors.grey.shade400),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Drag and drop files here', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Browse Files', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, Widget? trailing, List<Widget>? actions, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary)),
                if (actions != null) Row(children: actions),
                if (trailing != null) trailing,
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          child,
        ],
      ),
    );
  }

  Widget _buildTable({required List<String> headers, required List<List<String>> rows, required String emptyMessage}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: headers.map((h) => Expanded(
              child: Text(h, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          if (rows.isEmpty && emptyMessage.isNotEmpty)
             Padding(
               padding: const EdgeInsets.all(32.0),
               child: Text(emptyMessage, style: const TextStyle(color: AppColors.textSecondary)),
             )
          else if (rows.isEmpty)
             const SizedBox(height: 48), 
        ],
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  final Color color;
  DashRectPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
      
    var path = Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)));
    
    Path dashedPath = Path();
    double dashWidth = 8.0;
    double dashSpace = 6.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashedPath, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
