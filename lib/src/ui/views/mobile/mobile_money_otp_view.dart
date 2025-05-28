
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';


class MobileMoneyOtpView extends StatefulWidget {
  final PaymentResponseBody paymentResponseBody;
  final GestureTapCallback close;


  const MobileMoneyOtpView({super.key, required this.paymentResponseBody, required this.close});

  @override
  State<MobileMoneyOtpView> createState() => _MobileMoneyOtpViewState();
}

class _MobileMoneyOtpViewState extends State<MobileMoneyOtpView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _remainingTime = "10:00";

  @override
  void initState() {
    super.initState();
    _initCountDown(const Duration(minutes: 10));
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
          icon: PaymentOptionsEnum.mobileMoney.icon,
          text: PaymentOptionsEnum.mobileMoney.title,
          onTap: () {},
        ),
        const SizedBox(
          height: 16,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 32,
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
          widget.paymentResponseBody.providerMessage ?? "",
        ),
        PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: true,
          obscuringCharacter: '*',
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            activeBorderWidth: 1,
            borderWidth: 1,
            fieldHeight: 56,
            fieldWidth: 68,
            fieldOuterPadding: const EdgeInsets.all(8),
            activeColor: SpotFlowColors.tone90,
            inactiveColor: SpotFlowColors.tone90,
            selectedColor: SpotFlowColors.tone90,
          ),
          onCompleted: (value) {
            _authorizePayment(value);
          },
          mainAxisAlignment: MainAxisAlignment.start,
          keyboardType: TextInputType.number,
          textStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        RichText(
          text: TextSpan(
            text: 'Didn\'t get code? ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: SpotFlowColors.tone100,
            ),
            children: [
              TextSpan(
                text: _remainingTime,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: SpotFlowColors.tone100,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 44.0,
        ),
        const SizedBox(
          height: 10.0,
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil(
                (route) => route.settings.name == SpotFlowRouteName.homePage);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          child: Text(
            'Cancel payment',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone80,
            ),
          ),
        ),
        const SizedBox(
          height: 80.0,
        ),
        const Spacer(),
        const PoweredBySpotflowTag(),
        const SizedBox(
          height: 42.0,
        )
      ],
    );
  }

  _initCountDown(Duration duration) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
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

  bool creatingPayment = false;

  Future<void> _authorizePayment(String value) async {
    final paymentManager = context.read<AppStateProvider>().paymentManager!;
    final paymentRequestBody = ValidatePaymentRequestBody(
        reference: widget.paymentResponseBody.reference, otp: value);

    setState(() {
      creatingPayment = true;
    });

    context.read<AppStateProvider>().trackEvent('input_cardOtp');

    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);
    try {
      final response = await paymentService.authorizePayment(
        paymentRequestBody.toJson(),
      );
      final paymentResponse = PaymentResponseBody.fromJson(response.data);
      if (mounted) {
        if (paymentResponse.status == "successful") {
          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SpotFlowRouteName.successPage,
              (route) {
                return route.isFirst;
              },
              arguments: SuccessPageArguments(
                paymentOptionsEnum: PaymentOptionsEnum.mobileMoney,
                successMessage: "Payment successful",
                paymentResponseBody: paymentResponse,
                close: widget.close,
              ),
            );
          }
        } else {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ErrorPage(
                  message: paymentResponse.providerMessage ?? "Payment failed",
                  paymentOptionsEnum: PaymentOptionsEnum.mobileMoney,
                ),
              ),
            );
          }
        }
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    setState(() {
      creatingPayment = false;
    });
  }
}
