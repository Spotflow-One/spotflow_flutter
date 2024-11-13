import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CancelPaymentButton extends StatelessWidget {
  final Alignment? alignment;
  final GestureTapCallback close;

  const CancelPaymentButton({
    super.key,
    this.alignment = Alignment.center,
    required this.close,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          Navigator.of(context).popUntil(
            (route) =>
                route.settings.name?.toLowerCase() ==
                SpotFlowRouteName.homePage.toLowerCase(),
          );
          close.call();
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
    });
  }
}
