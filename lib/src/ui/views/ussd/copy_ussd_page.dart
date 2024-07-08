import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class CopyUssdPage extends StatelessWidget {
  const CopyUssdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentOptionsTile(
          icon: Assets.svg.payWithUsdIcon.svg(),
          text: 'Pay with USSD',
        ),
        const PaymentCard(),
        const SizedBox(
          height: 23,
        ),
        Assets.svg.ussdIcon.svg(),
        const SizedBox(
          height: 23,
        ),
        Text(
          "Dial the code below to complete this transaction with FCMB’s 329",
          textAlign: TextAlign.center,
          style: SpotFlowTextStyle.body14Regular.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
          child: Text(
            'How to pay with FCMB USSD',
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.primary40,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: SpotFlowColors.primaryBase,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '*329*33*4*343788#',
                  style: SpotFlowTextStyle.body16SemiBold.copyWith(
                    color: SpotFlowColors.primary5,
                  ),
                ),
                const SizedBox(
                  width: 13.0,
                ),
                Assets.svg.copyIcon.svg(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 19,
        ),
        Center(
          child: Text(
            "Click to copy",
            style: SpotFlowTextStyle.body12SemiBold.copyWith(
              color: SpotFlowColors.tone50,
            ),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFC0B5CF), width: 1),
            ),
          ),
          child: Text(
            'I have completed the payment',
            style: SpotFlowTextStyle.body16SemiBold.copyWith(
              color: SpotFlowColors.tone60,
            ),
          ),
        ),
        const Spacer(),
        const Row(
          children: [
            Expanded(
              child: ChangePaymentButton(),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: CancelPaymentButton(),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        const PciDssIcon(),
        const SizedBox(
          height: 38,
        )
      ],
    );
  }
}
