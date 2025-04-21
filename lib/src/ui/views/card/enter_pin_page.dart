import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/authorize_payment_request_body.dart';
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

class EnterPinPage extends StatelessWidget {
  final String reference;
  final GestureTapCallback onClose;

  const EnterPinPage({
    super.key,
    required this.reference,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _EnterPinPageUI(
              reference: reference,
              onClose: onClose,
            ),
          ),
        ]);
  }
}

class _EnterPinPageUI extends StatefulWidget {
  final String reference;
  final GestureTapCallback onClose;

  const _EnterPinPageUI({
    required this.reference,
    required this.onClose,
  });

  @override
  State<_EnterPinPageUI> createState() => _EnterPinPageUIState();
}

class _EnterPinPageUIState extends State<_EnterPinPageUI> with CardsNavigation {
  @override
  Widget build(BuildContext context) {
    final paymentManager = context.read<AppStateProvider>().paymentManager;
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
          "Please enter your 4-digit card pin to authorize this payment",
          textAlign: TextAlign.start,
          style: SpotFlowTextStyle.body16Regular.copyWith(
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: true,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            activeBorderWidth: 1,
            borderWidth: 1,
            fieldHeight: 50,
            fieldWidth: 56,
            fieldOuterPadding: const EdgeInsets.all(9),
            activeColor: SpotFlowColors.tone90,
            inactiveColor: SpotFlowColors.tone90,
            selectedColor: SpotFlowColors.tone90,
          ),
          onCompleted: (value) {
            _authorizePayment(paymentManager, value);
          },
          mainAxisAlignment: MainAxisAlignment.center,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(
          height: 36.5,
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).popUntil(
                (route) =>
                    route.settings.name?.toLowerCase() ==
                    SpotFlowRouteName.homePage,
              );
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
          height: 64,
        ),
      ],
    );
  }

  bool creatingPayment = false;

  Future<void> _authorizePayment(
      SpotFlowPaymentManager paymentManager, String pin) async {
    final paymentRequestBody = AuthorizePaymentRequestBody(
      reference: widget.reference,
      pin: pin,
    );
    setState(() {
      creatingPayment = true;
    });

    context.read<AppStateProvider>().trackEvent('input_cardPin');

    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);
    try {
      final response = await paymentService.authorizePayment(
        paymentRequestBody.toJson(),
      );
      final paymentResponseBody = PaymentResponseBody.fromJson(response.data);
      if (mounted) {
        handleCardSuccessResponse(
          paymentResponseBody: paymentResponseBody,
          paymentManager: paymentManager,
          context: context,
          onCancelPayment: widget.onClose,
        );
      }
    } on DioException catch (e) {
      debugPrint(e.message);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      creatingPayment = false;
    });
  }
}
