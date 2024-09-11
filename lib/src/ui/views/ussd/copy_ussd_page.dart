import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_status_check_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import '../../../core/models/payment_response_body.dart';

class CopyUssdPage extends StatefulWidget {
  final Bank bank;
  final GestureTapCallback close;

  const CopyUssdPage({
    super.key,
    required this.bank,
    required this.close,
  });

  @override
  State<CopyUssdPage> createState() => _CopyUssdPageState();
}

class _CopyUssdPageState extends State<CopyUssdPage> {
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
        if (initiatingPayment) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ] else ...[
          Assets.svg.ussdIcon.svg(),
          const SizedBox(
            height: 23,
          ),
          Text(
            "Dial the code below to complete this transaction with ${widget.bank.name}",
            textAlign: TextAlign.center,
            style: SpotFlowTextStyle.body14Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   style: TextButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8),
          //   )),
          //   child: Text(
          //     'How to pay with FCMB USSD',
          //     style: SpotFlowTextStyle.body14Regular.copyWith(
          //       color: SpotFlowColors.primary40,
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: paymentResponseBody?.ussd?.code ?? "",
                  ),
                );
              },
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
                    paymentResponseBody?.ussd?.code ?? "",
                    style: SpotFlowTextStyle.body16SemiBold.copyWith(
                      color: SpotFlowColors.primary5,
                    ),
                  ),
                  const SizedBox(
                    width: 13.0,
                  ),
                  if (paymentResponseBody?.ussd != null) ...[
                    Assets.svg.copyIcon.svg(),
                  ]
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
            onPressed: () {
              if (paymentResponseBody == null) {
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransferStatusCheckPage(
                    reference: paymentResponseBody?.reference ?? "",
                    paymentResponseBody: paymentResponseBody!,
                    close: widget.close,
                  ),
                ),
              );
            },
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
          Row(
            children: [
              const Expanded(
                child: ChangePaymentButton(),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CancelPaymentButton(
                  close: widget.close,
                ),
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
        ]
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _createPayment();
  }

  bool initiatingPayment = false;
  PaymentResponseBody? paymentResponseBody;

  Future<void> _createPayment() async {
    setState(() {
      initiatingPayment = true;
    });
    final paymentManager = context.read<AppStateProvider>().paymentManager!;
    final amount = context.read<AppStateProvider>().merchantConfig!.plan.amount;
    final paymentService = PaymentService(paymentManager.key);

    final paymentRequestBody = PaymentRequestBody(
      customer: paymentManager.customer,
      currency: context.read<AppStateProvider>().merchantConfig?.rate.to ?? "",
      amount: amount,
      channel: "ussd",
      bank: widget.bank,
    );
    try {
      final response = await paymentService.createPayment(paymentRequestBody);

      paymentResponseBody = PaymentResponseBody.fromJson(response.data);
      if (paymentResponseBody?.status == "failed") {
        if (context.mounted == false) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ErrorPage(
                message:
                    paymentResponseBody?.providerMessage ?? "Payment failed",
                paymentOptionsEnum: PaymentOptionsEnum.ussd),
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }

    setState(() {
      initiatingPayment = false;
    });
  }
}
