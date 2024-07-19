import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/authorize_payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class EnterPinPage extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final Rate? rate;
  final String reference;

  const EnterPinPage({
    super.key,
    required this.paymentManager,
    required this.reference,
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        appLogo: paymentManager.appLogo,
        children: [
          PaymentOptionsTile(
            text: 'Pay with Card',
            icon: Assets.svg.payWithCardIcon.svg(),
          ),
          PaymentCard(
            paymentManager: paymentManager,
            rate: rate,
          ),
          Expanded(
            child: _EnterPinPageUI(
              paymentManager: paymentManager,
              reference: reference,
            ),
          ),
        ]);
  }
}

class _EnterPinPageUI extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final String reference;

  const _EnterPinPageUI({
    super.key,
    required this.paymentManager,
    required this.reference,
  });

  @override
  State<_EnterPinPageUI> createState() => _EnterPinPageUIState();
}

class _EnterPinPageUIState extends State<_EnterPinPageUI> {
  @override
  Widget build(BuildContext context) {
    final paymentManager = widget.paymentManager;
    if (creatingPayment) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 34.0,
            vertical: 24,
          ),
          child: Text(
            "Please enter your 4-digit card pin to authorize this payment",
            textAlign: TextAlign.center,
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
        ),
        PinCodeTextField(
          appContext: context,
          length: 4,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(4),
            selectedBorderWidth: 0.5,
            inactiveBorderWidth: 0.5,
            activeBorderWidth: 0.5,
            borderWidth: 0.5,
            fieldHeight: 50,
            fieldWidth: 56,
            fieldOuterPadding: const EdgeInsets.all(9),
            activeColor: SpotFlowColors.tone40,
            inactiveColor: SpotFlowColors.tone10,
            selectedColor: SpotFlowColors.tone40,
          ),
          onCompleted: (value) {
            _authorizePayment(paymentManager, value);
          },
          mainAxisAlignment: MainAxisAlignment.center,
          keyboardType: TextInputType.number,
        ),
        const Spacer(),
        TextButton(
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
            'Cancel',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone80,
            ),
          ),
        ),
        const SizedBox(
          height: 64,
        ),
        const PciDssIcon(),
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
      merchantId: paymentManager.merchantId,
      reference: widget.reference,
      pin: pin,
    );
    setState(() {
      creatingPayment = true;
    });

    final paymentService = PaymentService(paymentManager.key);
    try {
      final response = await paymentService.authorizePayment(
        paymentRequestBody,
      );
      if (mounted == false) return;
      paymentService.handleCardSuccessResponse(
        response: response,
        paymentManager: paymentManager,
        context: context,
      );
    } on DioException catch (e) {
      //todo: handle errors
    }
    setState(() {
      creatingPayment = false;
    });
  }
}
