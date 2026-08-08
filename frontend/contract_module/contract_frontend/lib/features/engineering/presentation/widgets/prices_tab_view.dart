import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';

class PricesTabView extends StatelessWidget {
  const PricesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pricing Analysis & Unit Rates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.3))),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 100),
                      FlSpot(1, 120),
                      FlSpot(2, 110),
                      FlSpot(3, 150),
                      FlSpot(4, 140),
                      FlSpot(5, 160),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 80),
                      FlSpot(1, 90),
                      FlSpot(2, 85),
                      FlSpot(3, 110),
                      FlSpot(4, 105),
                      FlSpot(5, 120),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 16, height: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Structural Steel'),
              const SizedBox(width: 24),
              Container(width: 16, height: 16, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Concrete'),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Granular Price Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Resource Item')),
                DataColumn(label: Text('Unit Rate')),
                DataColumn(label: Text('Volume Discount')),
                DataColumn(label: Text('Contract Total')),
                DataColumn(label: Text('Rate Trend')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Structural Steel')),
                  DataCell(Text('\$1,200/ton')),
                  DataCell(Text('5% (>100t)')),
                  DataCell(Text('\$114,000')),
                  DataCell(Icon(Icons.arrow_upward, color: Colors.red)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Ready-Mix Concrete')),
                  DataCell(Text('\$150/m3')),
                  DataCell(Text('2% (>500m3)')),
                  DataCell(Text('\$73,500')),
                  DataCell(Icon(Icons.arrow_downward, color: Colors.green)),
                ]),
                DataRow(cells: [
                  DataCell(Text('Rebar')),
                  DataCell(Text('\$800/ton')),
                  DataCell(Text('None')),
                  DataCell(Text('\$40,000')),
                  DataCell(Icon(Icons.remove, color: Colors.grey)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
