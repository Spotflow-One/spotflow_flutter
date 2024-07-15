import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class ViewBanksUssdPage extends StatelessWidget {
  const ViewBanksUssdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      children: [
        PaymentOptionsTile(
          icon: Assets.svg.payWithUsdIcon.svg(),
          text: 'Pay with USSD',
        ),
        // const PaymentCard(),
        const SizedBox(
          height: 70,
        ),
        Assets.svg.ussdIcon.svg(),
        const SizedBox(
          height: 9.0,
        ),
        Text(
          'Choose your bank to start the payment',
          style: SpotFlowTextStyle.body16SemiBold,
        ),
        const SizedBox(
          height: 70,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 15.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: const Color(0xFFC0B5CF),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Text(
                "First City Monument Bank",
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: SpotFlowColors.tone70,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCE8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '*329#',
                  style: SpotFlowTextStyle.body14SemiBold.copyWith(
                    color: SpotFlowColors.tone60,
                  ),
                ),
              )
            ],
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
