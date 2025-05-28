import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
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
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: SpotFlowColors.tone100,
          ),
        ),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 16,
              child: icon,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: SpotFlowTextStyle.body16SemiBold.copyWith(
                color: SpotFlowColors.tone100,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HomePaymentOptionsTile extends StatelessWidget {
  final Widget icon;
  final Widget? trailing;
  final String text;
  final GestureTapCallback? onTap;

  const HomePaymentOptionsTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: SpotFlowColors.tone40,
          ),
        ),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 16,
              child: icon,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                text,
                style: SpotFlowTextStyle.body16Regular.copyWith(
                  color: SpotFlowColors.tone100,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            if (trailing != null) ...[trailing!]
          ],
        ),
      ),
    );
  }
}
