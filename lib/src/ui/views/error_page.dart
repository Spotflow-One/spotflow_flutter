import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/enter_card_details_page.dart';
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/views/ussd/view_banks_ussd_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class ErrorPage extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final String message;
  final PaymentOptionsEnum paymentOptionsEnum;
  final double? rate;

  const ErrorPage({
    super.key,
    required this.paymentManager,
    required this.message,
    required this.paymentOptionsEnum,
    this.rate,
  });

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
          text: paymentOptionsEnum.title,
          icon: paymentOptionsEnum.icon,
        ),
        PaymentCard(
          paymentManager: paymentManager,
          rate: rate,
        ),
        const SizedBox(
          height: 49,
        ),
        Assets.svg.warning.svg(),
        const SizedBox(
          height: 6,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    EnterCardDetailsPage(paymentManager: paymentManager),
              ),
            );
          },
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
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ViewBankDetailsPage(paymentManager: paymentManager),
              ),
            );
          },
          style: buttonStyle,
          child: Text(
            'Try again with transfer',
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ViewBanksUssdPage(paymentManager: paymentManager),
              ),
            );
          },
          style: buttonStyle,
          child: Text(
            'Try again with USSD',
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
