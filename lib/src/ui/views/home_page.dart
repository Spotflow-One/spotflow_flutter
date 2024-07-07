import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class HomePage extends StatelessWidget {
  final Widget? appLogo;

  const HomePage({super.key, this.appLogo});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appLogo: appLogo,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 34,
        ),
        const PaymentCard(),
        const SizedBox(
          height: 27,
        ),
        Text(
          'Use one of the payment methods below to pay NGN500,000,000 to Spotflow',
          style: SpotFlowTextStyle.body12Regular.copyWith(
            color: SpotFlowColors.tone40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0, top: 66.0),
          child: Text(
            'PAYMENT OPTIONS',
            style: SpotFlowTextStyle.body16SemiBold.copyWith(
              color: SpotFlowColors.tone60,
            ),
          ),
        ),
        const SizedBox(
          height: 10.5,
        ),
        const Divider(
          thickness: 0.5,
          color: SpotFlowColors.tone10,
        ),
        PaymentOptionsTile(
          icon: Assets.svg.payWithCardIcon.svg(),
          text: "Pay with Card",
          onTap: () {},
        ),
        const SizedBox(
          height: 6,
        ),
        PaymentOptionsTile(
          icon: Assets.svg.payWithTransferIcon.svg(),
          text: "Pay with Transfer",
          onTap: () {},
        ),
        const SizedBox(
          height: 6,
        ),
        PaymentOptionsTile(
          icon: Assets.svg.payWithUsdIcon.svg(),
          text: "Pay with USSD",
          onTap: () {},
        ),
        const SizedBox(
          height: 60,
        ),
        const Center(
          child: CancelPaymentButton(),
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
