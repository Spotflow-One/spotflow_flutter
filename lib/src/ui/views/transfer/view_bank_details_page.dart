import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_error_page.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_info_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import '../../widgets/payment_card.dart';

class ViewBankDetailsPage extends StatelessWidget {
  final PaymentResponseBody? paymentResponseBody;
  final GestureTapCallback close;

  const ViewBankDetailsPage({
    super.key,
    this.paymentResponseBody,
    required this.close,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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
              paymentResponseBody: paymentResponseBody,
              close: close,
            ),
          ),
        ]);
  }
}

class _ViewBankDetailsUi extends StatefulWidget {
  final PaymentResponseBody? paymentResponseBody;
  final GestureTapCallback close;

  const _ViewBankDetailsUi({
    super.key,
    this.paymentResponseBody,
    required this.close,
  });

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
    final merchantConfig = context.read<AppStateProvider>().merchantConfig;
    if (initiatingPayment) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (paymentResponseBody == null || merchantConfig == null) {
      return Column(
        children: [
          const PaymentCard(),
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
    final amount = paymentResponseBody?.amount;
    String? formattedAmount;
    String? totalAmount;
    if (amount != null) {
      totalAmount = (rate! * amount).toStringAsFixed(2);
      formattedAmount = "${merchantConfig.rate.from} $totalAmount";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PaymentCard(),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Transfer ${formattedAmount ?? ""} to the details below',
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
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              paymentResponseBody?.bankDetails?.accountNumber ??
                                  "",
                        ),
                      );

                      context
                          .read<AppStateProvider>()
                          .trackEvent('copy_transferBank');
                    },
                    child: Assets.svg.copyIcon.svg(
                      colorFilter: const ColorFilter.mode(
                        SpotFlowColors.primary50,
                        BlendMode.srcIn,
                      ),
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
                        formattedAmount ?? "",
                        style: SpotFlowTextStyle.body14Regular.copyWith(
                          color: SpotFlowColors.tone80,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      context
                          .read<AppStateProvider>()
                          .trackEvent('copy_transferAmount');
                      Clipboard.setData(
                        ClipboardData(
                          text: totalAmount ?? "",
                        ),
                      );
                    },
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
                  backgroundColor: const Color(0xFFE1E0F1),
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
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransferInfoPage(
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
                side: const BorderSide(
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
        Row(
          children: [
            const Expanded(
              flex: 3,
              child: ChangePaymentButton(),
            ),
            const SizedBox(
              width: 18.0,
            ),
            Expanded(
              flex: 2,
              child: CancelPaymentButton(
                close: widget.close,
              ),
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

    final paymentManager = context.read<AppStateProvider>().paymentManager!;
    final amount =
        context.read<AppStateProvider>().merchantConfig?.plan?.amount ??
            paymentManager.amount;
    if (amount == null) return;
    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);

    final paymentRequestBody = PaymentRequestBody(
      customer: paymentManager.customer,
      currency:
          context.read<AppStateProvider>().merchantConfig?.rate.from ?? "",
      amount: amount,
      channel: "bank_transfer",
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
                  paymentOptionsEnum: PaymentOptionsEnum.transfer),
            ),
          );
        }
      } else {
        final expiresAt = paymentResponseBody?.bankDetails?.expiresAt ??
            DateTime.now().add(const Duration(minutes: 30));
        _initCountDown(expiresAt);
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }

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
              message: "Account Expired",
              paymentResponseBody: paymentResponseBody!,
              close: widget.close,
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
