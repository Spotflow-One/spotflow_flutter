import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_status_check_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

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

class _CopyUssdPageState extends State<CopyUssdPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _remainingTime = "30:00";

  String formatTime(int remainingSeconds) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 28,
        ),
        const DismissibleAppLogo(),
        const SizedBox(
          height: 24,
        ),
        const UserAndRateInformationCard(),
        const SizedBox(
          height: 32,
        ),
        const PaymentCard(),
        const SizedBox(
          height: 24,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Selected payment method',
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        PaymentOptionsTile(
          icon: PaymentOptionsEnum.ussd.icon,
          text: PaymentOptionsEnum.ussd.title,
          onTap: () {},
        ),
        const SizedBox(
          height: 16.0,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 32.0,
        ),
        if (initiatingPayment) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        ] else ...[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Dial the ',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: SpotFlowColors.tone70,
              ),
              children: [
                TextSpan(
                    text: widget.bank.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: SpotFlowColors.tone70,
                      fontWeight: FontWeight.w600,
                    )),
                const TextSpan(
                    text:
                        ' USSD code below on your mobile phone to complete the payment',
                    style: TextStyle(
                      fontSize: 14,
                      color: SpotFlowColors.tone70,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            paymentResponseBody?.ussd?.code ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: SpotFlowColors.tone100,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: (){
              Clipboard.setData(
                ClipboardData(
                  text:   paymentResponseBody?.ussd?.code ?? "",
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "COPY USSD CODE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SpotFlowColors.tone100,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Assets.svg.copyIcon.svg(
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "This code will expire after ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4F3B23),
                  ),
                  children: [
                    TextSpan(
                      text: _remainingTime,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F3B23)),
                    ),
                    const TextSpan(
                      text: ' and can only be used for this transaction.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4F3B23)),
                    )
                  ]),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          PrimaryButton(
            onTap: () {
              if (paymentResponseBody == null) {
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TransferStatusCheckPage(
                    reference: paymentResponseBody?.reference ?? "",
                    paymentResponseBody: paymentResponseBody!,
                    close: widget.close,
                    paymentOptionsEnum: PaymentOptionsEnum.ussd,
                  ),
                ),
              );
            },
            text: 'I have made this payment',
          ),
          const Spacer(),
          const PoweredBySpotflowTag(),
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


  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  bool initiatingPayment = false;
  PaymentResponseBody? paymentResponseBody;

  Future<void> _createPayment() async {
    setState(() {
      initiatingPayment = true;
    });
    final paymentManager = context.read<AppStateProvider>().paymentManager!;
    final amount =
        context.read<AppStateProvider>().merchantConfig!.plan?.amount ??
            paymentManager.amount;
    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);

    if (amount == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ErrorPage(
              message: "Please provide an amount",
              paymentOptionsEnum: PaymentOptionsEnum.ussd),
        ),
      );
      return;
    }
    final paymentRequestBody = PaymentRequestBody(
      customer: paymentManager.customer,
      currency:
          context.read<AppStateProvider>().merchantConfig?.rate.from ?? "",
      amount: amount,
      channel: "ussd",
      bank: widget.bank,
    );
    try {
      final response = await paymentService.createPayment(paymentRequestBody);

      paymentResponseBody = PaymentResponseBody.fromJson(response.data);
      if (paymentResponseBody?.status == "failed") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                  message:
                      paymentResponseBody?.providerMessage ?? "Payment failed",
                  paymentOptionsEnum: PaymentOptionsEnum.ussd),
            ),
          );
        }
      } else {
        _initCountDown();
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }

    setState(() {
      initiatingPayment = false;
    });
  }

  _initCountDown() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.addListener(() {
      if (_animation.value == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ErrorPage(
              message: "Account Expired",
              paymentOptionsEnum: PaymentOptionsEnum.ussd,
            ),
          ),
        );
      } else {
        setState(() {
          double remainingSeconds =
              (_controller.duration!.inMilliseconds * _animation.value)
                      .round() /
                  1000;
          _remainingTime = formatTime(remainingSeconds.toInt());
        });
      }
    });
    _controller.forward();
  }
}
