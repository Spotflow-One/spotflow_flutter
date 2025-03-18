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
import 'package:spotflow/src/ui/views/transfer/bank_account_card.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

import '../../widgets/payment_card.dart';
import 'transfer_status_check_page.dart';

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

    final amount = paymentResponseBody?.amount;
    String? formattedAmount;
    String? totalAmount;
    if (amount != null) {
      totalAmount = (amount).toStringAsFixed(2);
      formattedAmount = "${merchantConfig.rate.from} $totalAmount";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
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
            icon: PaymentOptionsEnum.transfer.icon,
            text: PaymentOptionsEnum.transfer.title,
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
          Center(
            child: Text(
              'Make a single bank transfer from your bank to this account before it expires.',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone100,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          BankAccountCard(
            formattedAmount: formattedAmount ?? "",
            paymentResponseBody: paymentResponseBody,
            totalAmount: totalAmount,
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF7ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        "This account is for this transaction only and expires in ",
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
                    ]),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: PrimaryButton(
              onTap: () {
                if (paymentResponseBody == null) {
                  return;
                }
                context
                    .read<AppStateProvider>()
                    .trackEvent('verify_transferPayment');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TransferStatusCheckPage(
                      reference: paymentResponseBody!.reference,
                      paymentResponseBody: paymentResponseBody!,
                      close: widget.close,
                      paymentOptionsEnum: PaymentOptionsEnum.transfer,
                    ),
                  ),
                );
              },
              text: "I've sent the money",
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          const Spacer(),
          const SizedBox(
            height: 16,
          ),
          const PoweredBySpotflowTag(),
          const SizedBox(
            height: 32,
          )
        ],
      ),
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
      } else if (paymentResponseBody?.bankDetails == null) {
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
            builder: (context) => const ErrorPage(
              message: "Account Expired",
              paymentOptionsEnum: PaymentOptionsEnum.transfer,
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
