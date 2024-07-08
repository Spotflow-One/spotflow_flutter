import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Color(0xFFC0B5CF),
          width: 1.0,
        ),
      ),
    );
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentOptionsTile(
          text: 'Pay with Card',
          icon: Assets.svg.payWithCardIcon.svg(),
        ),
        const PaymentCard(),
        const SizedBox(
          height: 49,
        ),
        Assets.svg.warning.svg(),
        const SizedBox(
          height: 6,
        ),
        Text(
          'Incorrect otp.\nPlease retry with the correct otp',
          textAlign: TextAlign.center,
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        TextButton(
          onPressed: () {},
          style: buttonStyle,
          child: Text(
            'Try again with your card',
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () {},
          style: buttonStyle,
          child: Text(
            'Try again with your card',
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () {},
          style: buttonStyle,
          child: Text(
            'Try again with your card',
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const Spacer(),
        const PciDssIcon(),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }
}
