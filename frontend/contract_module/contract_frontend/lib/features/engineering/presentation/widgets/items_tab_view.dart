import 'package:flutter/material.dart';

class ItemsTabView extends StatelessWidget {
  const ItemsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. Define Contract Items, Prices & Quantities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Item Name')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Unit Price')),
              DataColumn(label: Text('Total')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Steel Beams')),
                DataCell(Text('100')),
                DataCell(Text('\$150.00')),
                DataCell(Text('\$15,000.00')),
              ]),
              DataRow(cells: [
                DataCell(Text('Concrete')),
                DataCell(Text('500 m3')),
                DataCell(Text('\$120.00')),
                DataCell(Text('\$60,000.00')),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ],
      ),
    );
  }
}
