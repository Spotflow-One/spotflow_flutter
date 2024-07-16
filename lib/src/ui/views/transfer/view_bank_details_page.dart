import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_error_page.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_info_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import '../../widgets/payment_card.dart';

class ViewBankDetailsPage extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final PaymentResponseBody? paymentResponseBody;

  const ViewBankDetailsPage({
    super.key,
    required this.paymentManager,
    this.paymentResponseBody,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appLogo: paymentManager.appLogo,
        padding: const EdgeInsets.only(
          left: 11,
          right: 23,
        ),
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.payWithTransferIcon.svg(),
            text: 'Pay with transfer',
          ),
          Expanded(
            child: _ViewBankDetailsUi(
              paymentManager: paymentManager,
              paymentResponseBody: paymentResponseBody,
            ),
          ),
        ]);
  }
}

class _ViewBankDetailsUi extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final PaymentResponseBody? paymentResponseBody;

  const _ViewBankDetailsUi(
      {super.key, required this.paymentManager, this.paymentResponseBody});

  @override
  State<_ViewBankDetailsUi> createState() => _ViewBankDetailsUiState();
}

class _ViewBankDetailsUiState extends State<_ViewBankDetailsUi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _remainingTime = "30:00";

  @override
  void initState() {
    super.initState();

    if (widget.paymentResponseBody == null) {
      _initiatePayment();
    } else {
      paymentResponseBody = widget.paymentResponseBody;
      final expiresAt = widget.paymentResponseBody?.bankDetails?.expiresAt ??
          DateTime.now().add(const Duration(minutes: 30));
      _initCountDown(expiresAt);
    }
  }

  String formatTime(int remainingSeconds) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool initiatingPayment = false;

  @override
  Widget build(BuildContext context) {
    if (initiatingPayment) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (paymentResponseBody == null) {
      return Column(
        children: [
          PaymentCard(
            paymentManager: widget.paymentManager,
          ),
          const SizedBox(
            height: 20,
          ),
          Assets.svg.warning.svg(),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We encountered an error, please try again.',
            style: SpotFlowTextStyle.body14Regular,
          ),
        ],
      );
    }

    final rate = paymentResponseBody!.rate;
    final formattedAmount =
        "${rate?.to} ${(rate!.rate * widget.paymentManager.amount).toStringAsFixed(2)}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentCard(
          paymentManager: widget.paymentManager,
          rate: rate,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Transfer $formattedAmount to the details below',
            style: SpotFlowTextStyle.body16SemiBold.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 27),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BANK NAME",
                        style: SpotFlowTextStyle.body10Regular.copyWith(
                          color: SpotFlowColors.tone60,
                        ),
                      ),
                      Text(
                        paymentResponseBody!.bankDetails?.name ?? "",
                        style: SpotFlowTextStyle.body14Regular.copyWith(
                          color: SpotFlowColors.tone80,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    'CHANGE BANK',
                    style: SpotFlowTextStyle.body10Regular.copyWith(
                      color: SpotFlowColors.tone60,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ACCOUNT NUMBER",
                        style: SpotFlowTextStyle.body10Regular.copyWith(
                          color: SpotFlowColors.tone60,
                        ),
                      ),
                      Text(
                        paymentResponseBody?.bankDetails?.accountNumber ?? "",
                        style: SpotFlowTextStyle.body14Regular.copyWith(
                          color: SpotFlowColors.tone80,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Assets.svg.copyIcon.svg(
                    colorFilter: const ColorFilter.mode(
                      SpotFlowColors.primary50,
                      BlendMode.srcIn,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AMOUNT",
                        style: SpotFlowTextStyle.body10Regular.copyWith(
                          color: SpotFlowColors.tone60,
                        ),
                      ),
                      Text(
                        formattedAmount,
                        style: SpotFlowTextStyle.body14Regular.copyWith(
                          color: SpotFlowColors.tone80,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Assets.svg.copyIcon.svg(
                      colorFilter: const ColorFilter.mode(
                        SpotFlowColors.primary50,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 19,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Text(
              'Search for Spotflow Direct  or Direct Spotflow on your bank app. '
              'Use this account for this transaction only',
              style: SpotFlowTextStyle.body12Regular.copyWith(
                color: SpotFlowColors.tone60,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Center(
          child: SizedBox.square(
            dimension: 50,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Color(0xFFE1E0F1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      SpotFlowColors.primaryBase),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Assets.svg.payWithTransferIcon.svg(
                    height: 22,
                    width: 22,
                    colorFilter: const ColorFilter.mode(
                      SpotFlowColors.greenBase,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Center(
          child: RichText(
            text: TextSpan(
              text: 'Expires in ',
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone30,
              ),
              children: [
                TextSpan(
                  text: _remainingTime,
                  style: SpotFlowTextStyle.body14Regular.copyWith(
                    color: SpotFlowColors.greenBase,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransferInfoPage(
                    paymentManager: widget.paymentManager,
                    paymentResponseBody: paymentResponseBody!,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Color(0xFFC0B5CF),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              "I've sent the money",
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        const Row(
          children: [
            Expanded(
              flex: 3,
              child: ChangePaymentButton(),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              flex: 2,
              child: CancelPaymentButton(),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(
          height: 16,
        ),
        const PciDssIcon(),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }

  PaymentResponseBody? paymentResponseBody;

  Future<void> _initiatePayment() async {
    setState(() {
      initiatingPayment = true;
    });
    final paymentManager = widget.paymentManager;
    final paymentService = PaymentService(paymentManager.key);

    final paymentRequestBody = PaymentRequestBody(
      customer: paymentManager.customer,
      currency: paymentManager.fromCurrency,
      amount: paymentManager.amount,
      channel: "bank_transfer",
      provider: paymentManager.provider,
    );
    try {
      final response = await paymentService.createPayment(paymentRequestBody);

      paymentResponseBody = PaymentResponseBody.fromJson(response.data);

      final expiresAt = paymentResponseBody?.bankDetails?.expiresAt ??
          DateTime.now().add(const Duration(minutes: 30));
      _initCountDown(expiresAt);
    } on DioException catch (e) {}

    setState(() {
      initiatingPayment = false;
    });
  }

  _initCountDown(DateTime expiresAt) {
    final time = expiresAt.difference(DateTime.now());
    _controller = AnimationController(
      vsync: this,
      duration: time,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.addListener(() {
      if (_animation.value == 0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TransferErrorPage(
                paymentManager: widget.paymentManager,
                message: "Account Expired",
                paymentResponseBody: paymentResponseBody!),
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
