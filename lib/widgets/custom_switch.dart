import 'package:flutter/material.dart';

class SourceSwitch extends StatelessWidget {
  final String selectedSource;
  final Function(String) onSourceChanged;

  const SourceSwitch({
    super.key,
    required this.selectedSource,
    required this.onSourceChanged,
  });

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    if (selectedSource == 'fake') {
      alignment = Alignment.centerLeft;
    } else if (selectedSource == 'dummy') {
      alignment = Alignment.center;
    } else {
      alignment = Alignment.centerRight;
    }

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            alignment: alignment,
            child: FractionallySizedBox(
              widthFactor: 0.333,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildOption('fake', 'Fake Store'),
              _buildOption('dummy', 'DummyJSON'),
              _buildOption('want', 'WantAPI'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String key, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSourceChanged(key),
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selectedSource == key
                  ? Colors.black87
                  : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
