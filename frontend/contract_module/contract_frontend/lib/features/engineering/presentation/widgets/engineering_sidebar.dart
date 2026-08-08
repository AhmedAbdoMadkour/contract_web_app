import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/widgets/glass_container.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class EngineeringSidebar extends StatelessWidget {
  const EngineeringSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.only(left: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComplianceSection(),
          const SizedBox(height: 24),
          _buildContractEfficiencySection(),
          const SizedBox(height: 24),
          _buildEngineeringActionsSection(),
        ],
      ),
    );
  }

  Widget _buildComplianceSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Compliance & Standards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildComplianceItem('ISO 9001:2015', 1.0, Colors.green, 'Verified'),
          const SizedBox(height: 12),
          _buildComplianceItem('Local Building Code', 0.8, Colors.orange, 'Pending Review'),
          const SizedBox(height: 12),
          _buildComplianceItem('Environmental Impact', 0.4, Colors.red, 'Incomplete'),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String title, double progress, Color color, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(status, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildContractEfficiencySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black, // Solid black background for high contrast
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Contract Efficiency', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          const Text('92%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Design specifications align perfectly with standard material sizes, reducing waste.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('View Optimization Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildEngineeringActionsSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(Icons.request_page, 'RFI Request'),
              _buildActionCard(Icons.history, 'Version History'),
              _buildActionCard(Icons.chat, 'Team Chat'),
              _buildActionCard(Icons.flag, 'Milestones'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
