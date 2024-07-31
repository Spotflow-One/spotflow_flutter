import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CancelPaymentButton extends StatelessWidget {
  final Alignment? alignment;
  const CancelPaymentButton({
    super.key,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).popUntil(
          (route) =>
              route.settings.name?.toLowerCase() ==
              SpotFlowRouteName.homePage.toLowerCase(),
        );
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        alignment: alignment,
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
      ),
    );
  }
}
