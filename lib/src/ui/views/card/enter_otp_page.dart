import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/cards_navigation.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';

class EnterOtpPage extends StatelessWidget {
  final String message;
  final String reference;

  const EnterOtpPage({
    super.key,
    required this.message,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _EnterOtpPageUi(
            message: message,
            reference: reference,
          ),
        ),
      ],
    );
  }
}

class _EnterOtpPageUi extends StatefulWidget {
  final String message;
  final String reference;

  const _EnterOtpPageUi({
    super.key,
    required this.message,
    required this.reference,
  });

  @override
  State<_EnterOtpPageUi> createState() => _EnterOtpPageUiState();
}

class _EnterOtpPageUiState extends State<_EnterOtpPageUi> with CardsNavigation {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (creatingPayment) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 28,
        ),
        const DismissibleAppLogo(),
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
          widget.message,
          textAlign: TextAlign.start,
          style: SpotFlowTextStyle.body16Regular.copyWith(
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: controller,
          obscureText: true,
          obscuringCharacter: "*",
          style: const TextStyle(
              fontSize: 28, color: Colors.black, letterSpacing: 8),
          showCursor: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: SpotFlowColors.tone90,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: SpotFlowColors.tone90,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: SpotFlowColors.tone90,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        RichText(
          text: const TextSpan(
            text: "Didn't get code? ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: SpotFlowColors.tone100,
            ),
            children: [
              TextSpan(
                text: "Try again",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: SpotFlowColors.tone100,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        PrimaryButton(
          onTap: () => _authorizePayment(),
          text: 'Authorize payment',
        ),
        const SizedBox(
          height: 16.0,
        ),
        Center(
          child: TextButton(
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
        ),
        const Spacer(),
        const PoweredBySpotflowTag(),
        const SizedBox(
          height: 42.0,
        )
      ],
    );
  }

  bool creatingPayment = false;

  Future<void> _authorizePayment() async {
    final paymentManager = context.read<AppStateProvider>().paymentManager!;
    final paymentRequestBody = ValidatePaymentRequestBody(
      reference: widget.reference,
      otp: controller.text,
    );
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
      if (mounted) {
        handleCardSuccessResponse(
          response: response,
          paymentManager: paymentManager,
          context: context,
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    }
    setState(() {
      creatingPayment = false;
    });
  }
}
