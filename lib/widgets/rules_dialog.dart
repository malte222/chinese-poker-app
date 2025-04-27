import 'package:flutter/material.dart';

class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Royalties',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildRoyaltyTable(),
            const SizedBox(height: 24),
            const Text(
              'Weitere Regeln folgen bald...',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Schließen'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoyaltyTable() {
    const style = TextStyle(color: Colors.white, fontSize: 14);
    final rows = [
      ['Front', 'Units', 'Middle', 'Units', 'Back', 'Units'],
      ['66', '1', 'Three of a kind', '2', 'Straight', '2'],
      ['77', '2', 'Straight', '4', 'Flush', '4'],
      ['88', '3', 'Flush', '8', 'Full house', '6'],
      ['99', '4', 'Full house', '12', 'Four of a kind', '10'],
      ['TT', '5', 'Four of a kind', '20', 'Straight flush', '15'],
      ['JJ', '6', 'Straight flush', '30', 'Royal flush', '25'],
      ['QQ', '7', 'Royal flush', '50', '', ''],
      ['KK', '8', '', '', '', ''],
      ['AA', '9', '', '', '', ''],
      ['222', '10', '', '', '', ''],
      ['333', '11', '', '', '', ''],
      ['444', '12', '', '', '', ''],
      ['555', '13', '', '', '', ''],
      ['666', '14', '', '', '', ''],
      ['777', '15', '', '', '', ''],
      ['888', '16', '', '', '', ''],
      ['999', '17', '', '', '', ''],
      ['TTT', '18', '', '', '', ''],
      ['JJJ', '19', '', '', '', ''],
      ['QQQ', '20', '', '', '', ''],
      ['KKK', '21', '', '', '', ''],
      ['AAA', '22', '', '', '', ''],
    ];

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
      children:
          rows.map((row) {
            return TableRow(
              children:
                  row.map((cell) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(cell, style: style),
                    );
                  }).toList(),
            );
          }).toList(),
    );
  }
}
