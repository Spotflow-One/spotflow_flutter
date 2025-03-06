import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

class PrimaryButton extends StatelessWidget {
  final bool enabled;
  final String text;
  final GestureTapCallback onTap;

  const PrimaryButton({
    super.key,
    this.enabled = true,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (enabled) {
          onTap.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: !enabled ? SpotFlowColors.tone40 : SpotFlowColors.tone100,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
