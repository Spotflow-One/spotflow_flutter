import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_info_page.dart';
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class TransferErrorPage extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final Rate? rate;
  final String message;
  final PaymentResponseBody paymentResponseBody;

  const TransferErrorPage({
    super.key,
    required this.paymentManager,
    this.rate,
    required this.message,
    required this.paymentResponseBody,
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
            icon: Assets.svg.payWithTransferIcon.svg(),
            text: 'Pay with transfer',
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ViewBankDetailsPage(paymentManager: paymentManager),
                ),
              );
            },
            style: buttonStyle,
            child: Text(
              'Try again',
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransferInfoPage(
                    paymentManager: paymentManager,
                    paymentResponseBody: paymentResponseBody,
                  ),
                ),
              );
            },
            style: buttonStyle,
            child: Text(
              'I already sent the money',
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone70,
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
          const Spacer(),
          const PciDssIcon(),
          const SizedBox(
            height: 32,
          )
        ]);
  }
}