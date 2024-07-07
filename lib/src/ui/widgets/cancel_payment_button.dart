import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CancelPaymentButton extends StatelessWidget {
  const CancelPaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: SpotFlowColors.tone10,
          )),
      child: Text(
        'x Cancel Payment',
        style: SpotFlowTextStyle.body12SemiBold.copyWith(
          color: SpotFlowColors.tone70,
        ),
      ),
    );
  }
}
