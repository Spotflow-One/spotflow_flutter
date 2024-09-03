import 'dart:convert';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:pattern_formatter/pattern_formatter.dart' as pf;
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/models/spot_flow_card.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/spotflow.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/authorization_web_view.dart';
import 'package:spotflow/src/ui/views/card/card_payment_status_check_page.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import 'widgets/card_input_field.dart';

class EnterCardDetailsPage extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final double? rate;

  const EnterCardDetailsPage({
    super.key,
    required this.paymentManager,
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appLogo: paymentManager.appLogo,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          child: _CardInputUI(
            paymentManager: paymentManager,
            rate: rate,
          ),
        ),
      ],
    );
  }
}

class _CardInputUI extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final double? rate;

  const _CardInputUI({
    super.key,
    required this.paymentManager,
    this.rate,
  });

  @override
  State<_CardInputUI> createState() => _CardInputUIState();
}

class _CardInputUIState extends State<_CardInputUI>
    implements TransactionCallBack {
  TextEditingController cardNumberController = TextEditingController();

  TextEditingController expiryController = TextEditingController();

  TextEditingController cvvController = TextEditingController();

  bool creatingPayment = false;

  bool buttonEnabled = false;

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentManager = widget.paymentManager;
    String formattedAmount = "";
    if (widget.rate != null) {
      formattedAmount =
          "${paymentManager.toCurrency} ${(widget.rate! * paymentManager.amount).toStringAsFixed(2)}";
    } else {
      formattedAmount =
          'Pay ${paymentManager.fromCurrency} ${paymentManager.amount.toStringAsFixed(2)}';
    }

    if (creatingPayment) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 34.0,
          ),
          Center(
            child: Text(
              'Enter your card details to pay',
              style: SpotFlowTextStyle.body16SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 34,
          ),
          CardInputField(
            labelText: 'CARD NUMBER',
            hintText: '0000 0000 0000 0000',
            textEditingController: cardNumberController,
            onChanged: onCardNumberChanged,
            inputFormatters: [pf.CreditCardFormatter()],
          ),
          const SizedBox(
            height: 28,
          ),
          Row(
            children: [
              Expanded(
                child: CardInputField(
                  labelText: 'CARD EXPIRY',
                  hintText: 'MM/YY',
                  textEditingController: expiryController,
                  onChanged: onExpiryDateChanged,
                  inputFormatters: [
                    CreditCardExpirationDateFormatter(),
                  ],
                ),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CardInputField(
                  labelText: 'CVV',
                  hintText: '123',
                  textEditingController: cvvController,
                  onChanged: onCvvChanged,
                  inputFormatters: [
                    CreditCardCvcInputFormatter(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 28.0,
          ),
          InkWell(
            onTap: () {
              _createPayment(paymentManager, context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonEnabled
                    ? SpotFlowColors.primaryBase
                    : SpotFlowColors.primary5,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                formattedAmount,
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: buttonEnabled
                      ? SpotFlowColors.kcBaseWhite
                      : SpotFlowColors.primary20,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
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
          const Spacer(),
          const PciDssIcon(),
          const SizedBox(
            height: 32,
          )
        ],
      );
    }
  }

  Future<void> _createPayment(
      SpotFlowPaymentManager paymentManager, BuildContext context) async {
    setState(() {
      creatingPayment = true;
    });
    String? expiryMonth = extractExpiryMonth(expiryController.text);
    String? expiryYear = extractExpiryYear(expiryController.text);
    if (expiryMonth == null || expiryYear == null) {
      return;
    }
    final card = SpotFlowCard(
      cvv: cvvController.text,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      pan: cardNumberController.text.replaceAll(" ", ""),
    );
    final encryptedCard = await encryptCard(card, paymentManager.encryptionKey);
    final paymentRequestBody = PaymentRequestBody(
        customer: paymentManager.customer,
        currency: paymentManager.fromCurrency,
        amount: paymentManager.amount,
        channel: 'card',
        encryptedCard: encryptedCard);
    final paymentService = PaymentService(paymentManager.key);
    try {
      final response = await paymentService.createPayment(
        paymentRequestBody,
      );
      paymentResponseBody = PaymentResponseBody.fromJson(response.data);

      if (mounted == false) return;
      paymentService.handleCardSuccessResponse(
        response: response,
        paymentManager: paymentManager,
        context: context,
        transactionCallBack: this,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['message'];
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ErrorPage(
              paymentManager: paymentManager,
              message: message ?? "Couldn't process your payment",
              paymentOptionsEnum: PaymentOptionsEnum.card),
        ),
      );
    }
    setState(() {
      creatingPayment = false;
    });
  }

  PaymentResponseBody? paymentResponseBody;

  @override
  onTransactionComplete(ChargeResponse? chargeResponse) {
    if (paymentResponseBody == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CardPaymentStatusCheckPage(
          paymentManager: widget.paymentManager,
          rate: paymentResponseBody!.rate,
          paymentReference: paymentResponseBody!.reference,
        ),
      ),
    );
  }

  String? extractExpiryMonth(String expiryString) {
    if (expiryString.isEmpty || expiryString.length != 5) {
      return null;
    }

    final parts = expiryString.split('/');
    if (parts.length != 2) {
      return null;
    }

    final month = int.tryParse(parts[0]);
    if (month == null) {
      return null;
    }

    // Ensure leading zero for single-digit months (optional)
    return month.toString().padLeft(2, '0');
  }

  String? extractExpiryYear(String expiryString) {
    if (expiryString.isEmpty || expiryString.length != 5) {
      return null;
    }
    final parts = expiryString.split('/');
    if (parts.length != 2) {
      return null;
    }
    final year = int.tryParse(parts[1]);
    if (year == null) {
      return null;
    }
    return year.toString().padLeft(2, '0');
  }

  void onExpiryDateChanged(String? value) {
    _validateCreditCard();
  }

  void onCvvChanged(String? value) {
    _validateCreditCard();
  }

  void onCardNumberChanged(String? value) {
    _validateCreditCard();
  }

  final _ccValidator = CreditCardValidator();

  _validateCreditCard() {
    final ccNumResults = _ccValidator.validateCCNum(cardNumberController.text);
    final expDateResults = _ccValidator.validateExpDate(expiryController.text);
    final cvvResults =
        _ccValidator.validateCVV(cvvController.text, ccNumResults.ccType);
    setState(() {
      buttonEnabled = ccNumResults.isPotentiallyValid &&
          expDateResults.isPotentiallyValid &&
          cvvResults.isValid;
    });
  }

  Future<String> encryptCard(SpotFlowCard card, String encryptionKey) async {
    try {
      print(card.toString());
      return encryptAES256(encryptionKey, card.toString());
    } catch (e) {
      print(e);
      return "null";
    }
  }

  String encryptAES256(String key, String data) {
    final iv = IV.fromSecureRandom(12); // 12 bytes IV for GCM

    // Create encrypter
    final encrypter = Encrypter(AES(
      Key.fromBase64(key),
      mode: AESMode.gcm,
    ));

    // Encrypt data
    final encrypted = encrypter.encrypt(data, iv: iv);

    // return encrypted.base64;

    // Get auth tag
    final authTag = encrypted.bytes.sublist(encrypted.bytes.length - 16);

    // Base64 encode IV, ciphertext, and auth tag
    final ivBase64 = base64.encode(iv.bytes);
    final encryptedBase64 =
        base64.encode(encrypted.bytes.sublist(0, encrypted.bytes.length - 16));
    final authTagBase64 = base64.encode(authTag);

    return '$ivBase64$encryptedBase64$authTagBase64';
  }
}
