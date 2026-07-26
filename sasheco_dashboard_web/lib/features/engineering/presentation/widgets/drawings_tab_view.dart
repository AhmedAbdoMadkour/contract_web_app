import 'package:flutter/material.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class DrawingsTabView extends StatelessWidget {
  const DrawingsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Drawings & Technical Specs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Blueprint_v2.pdf', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 2), // Should be dashed, but using solid as standard border
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, size: 48, color: AppColors.primary),
                SizedBox(height: 16),
                Text('Drag & Drop drawings here or click to upload'),
                SizedBox(height: 8),
                Text('Supported: DWG, IFC, RVT, PDF', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Itemized Engineering Quantities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Component')),
                DataColumn(label: Text('Specification')),
                DataColumn(label: Text('Quantity Unit')),
                DataColumn(label: Text('Unit Price')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Foundation Walls')),
                  DataCell(Text('4000 PSI, Rebar #5')),
                  DataCell(Text('120 m3')),
                  DataCell(Text('\$155.00')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Steel Columns')),
                  DataCell(Text('W12x40, A992')),
                  DataCell(Text('45 tons')),
                  DataCell(Text('\$1,250.00')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Roof Decking')),
                  DataCell(Text('1.5" 20-Gauge')),
                  DataCell(Text('5,000 sqft')),
                  DataCell(Text('\$2.50')),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
