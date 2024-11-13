import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/cards_navigation.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

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
        PaymentOptionsTile(
          text: 'Pay with Card',
          icon: Assets.svg.payWithCardIcon.svg(),
        ),
        const PaymentCard(),
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
      children: [
        const SizedBox(
          height: 47.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: Center(
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.5,
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: SpotFlowColors.tone20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 31,
        ),
        InkWell(
          onTap: () => _authorizePayment(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
              ),
              decoration: BoxDecoration(
                color: SpotFlowColors.greenBase,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Authorize',
                  style: SpotFlowTextStyle.body14SemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 44.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Text(
              "A token should be sent to you within 6 minutes",
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone60,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 29.0,
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
            'Cancel',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone80,
            ),
          ),
        ),
        const Spacer(),
        const PciDssIcon(),
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
      merchantId: paymentManager.merchantId,
      reference: widget.reference,
      otp: controller.text,
    );
    setState(() {
      creatingPayment = true;
    });

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
