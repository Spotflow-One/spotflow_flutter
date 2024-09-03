import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class TransferStatusCheckPage extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final double? rate;
  final String reference;
  final PaymentResponseBody paymentResponseBody;

  const TransferStatusCheckPage({
    super.key,
    required this.paymentManager,
    this.rate,
    required this.reference,
    required this.paymentResponseBody,
  });

  @override
  State<TransferStatusCheckPage> createState() =>
      _TransferStatusCheckPageState();
}

class _TransferStatusCheckPageState extends State<TransferStatusCheckPage>
    with SingleTickerProviderStateMixin {
  String _remainingTime = "10:00";
  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initCountDown();
    _verifyPayment();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  _initCountDown() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 10),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.addListener(() {
      setState(() {
        double remainingSeconds =
            (_controller.duration!.inMilliseconds * _animation.value).round() /
                1000;
        _remainingTime = formatTime(remainingSeconds.toInt());
      });
    });
    _controller.forward();
  }

  String formatTime(int remainingSeconds) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        appLogo: widget.paymentManager.appLogo,
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.payWithTransferIcon.svg(),
            text: 'Pay with transfer',
          ),
          PaymentCard(
            paymentManager: widget.paymentManager,
            rate: widget.rate,
          ),
          const SizedBox(
            height: 70,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'We’re waiting to confirm your transfer. This can take a few minutes',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Assets.svg.checkIcon.svg(
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        SpotFlowColors.greenBase,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Sent',
                      style: SpotFlowTextStyle.body12Regular.copyWith(
                        color: SpotFlowColors.tone40,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      backgroundColor: SpotFlowColors.tone10,
                      borderRadius: BorderRadius.circular(10),
                      color: SpotFlowColors.greenBase,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Assets.svg.dottedCircle.svg(
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Received',
                      style: SpotFlowTextStyle.body12Regular.copyWith(
                        color: SpotFlowColors.tone40,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Color(0xFFC0B5CF),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                "Please wait for $_remainingTime minutes",
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: SpotFlowColors.tone70,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewBankDetailsPage(
                      paymentManager: widget.paymentManager,
                      paymentResponseBody: widget.paymentResponseBody,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Show account number",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: SpotFlowColors.tone70,
                ),
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
                width: 18.0,
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
            height: 64,
          )
        ]);
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _verifyPayment();
    });
  }

  _verifyPayment() async {
    try {
      final paymentService = PaymentService(widget.paymentManager.key);
      final response = await paymentService.verifyPayment(
        reference: widget.paymentResponseBody.reference,
        merchantId: widget.paymentManager.merchantId,
      );
      final body = PaymentResponseBody.fromJson(response.data);
      if (body.status == 'successful') {
        if (context.mounted == false) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(
              name: SpotFlowRouteName.successPage,
            ),
            builder: (context) => SuccessPage(
              paymentOptionsEnum: PaymentOptionsEnum.transfer,
              paymentManager: widget.paymentManager,
              rate: widget.rate,
              successMessage:
                  "${widget.paymentManager.paymentDescription} payment successful",
            ),
          ),
        );
      } else if (body.status == "failed") {
        if (context.mounted == false) {
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(
              name: SpotFlowRouteName.errorPage,
            ),
            builder: (context) => ErrorPage(
              paymentOptionsEnum: PaymentOptionsEnum.transfer,
              paymentManager: widget.paymentManager,
              rate: widget.rate,
              message: body.providerMessage ?? "Payment failed",
            ),
          ),
        );
      }
    } on DioException catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(
            name: SpotFlowRouteName.errorPage,
          ),
          builder: (context) => ErrorPage(
            paymentOptionsEnum: PaymentOptionsEnum.transfer,
            paymentManager: widget.paymentManager,
            rate: widget.rate,
            message: "Payment failed",
          ),
        ),
      );
    }
  }
}
