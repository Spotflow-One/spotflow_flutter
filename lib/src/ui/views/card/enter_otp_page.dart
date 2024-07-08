import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class EnterOtpPage extends StatelessWidget {
  const EnterOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentOptionsTile(
          text: 'Pay with Card',
          icon: Assets.svg.payWithCardIcon.svg(),
        ),
        const PaymentCard(),
        const SizedBox(
          height: 47.0,
        ),
        Center(
          child: Text(
            "Kindly enter the OTP sent to 234249***3875",
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.5,
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 31,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
            ),
            decoration: BoxDecoration(
              color: SpotFlowColors.greenBase,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Authorize',
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 44.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Text(
              "A token should be sent to you within 6 minutes",
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone60,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 29.0,
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          child: Text(
            'Cancel',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone80,
            ),
          ),
        ),
        const Spacer(),
        const PciDssIcon(),
        const SizedBox(
          height: 42.0,
        )
      ],
    );
  }
}
