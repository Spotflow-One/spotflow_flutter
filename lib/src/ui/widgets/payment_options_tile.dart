import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class PaymentOptionsTile extends StatelessWidget {
  final Widget icon;
  final String text;
  final GestureTapCallback? onTap;

  const PaymentOptionsTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: icon,
        title: Text(
          text,
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone80,
          ),
        ));
  }
}
