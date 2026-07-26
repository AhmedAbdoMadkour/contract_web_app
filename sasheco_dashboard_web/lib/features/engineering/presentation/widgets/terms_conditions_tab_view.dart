import 'package:flutter/material.dart';

class TermsConditionsTabView extends StatelessWidget {
  const TermsConditionsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('2. Terms and Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Enter engineering specific terms...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
