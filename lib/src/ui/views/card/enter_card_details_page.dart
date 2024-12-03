import 'dart:convert';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:pattern_formatter/pattern_formatter.dart' as pf;
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/models/spot_flow_card.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/spotflow.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/cards_navigation.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import 'widgets/card_input_field.dart';

class EnterCardDetailsPage extends StatelessWidget {
  final GestureTapCallback close;

  const EnterCardDetailsPage({
    super.key,
    required this.close,
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
          child: _CardInputUI(
            close: close,
          ),
        ),
      ],
    );
  }
}

class _CardInputUI extends StatefulWidget {
  final GestureTapCallback close;

  const _CardInputUI({
    super.key,
    required this.close,
  });

  @override
  State<_CardInputUI> createState() => _CardInputUIState();
}

class _CardInputUIState extends State<_CardInputUI> with CardsNavigation {
  TextEditingController cardNumberController = TextEditingController();

  TextEditingController expiryController = TextEditingController();

  TextEditingController cvvController = TextEditingController();

  bool creatingPayment = false;

  bool get validCard =>
      _validCvv == true &&
      _validExpiryDate == true &&
      _validCreditCardNumber == true;

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.watch<AppStateProvider>().merchantConfig;
    final paymentManager = context.watch<AppStateProvider>().paymentManager!;
    final amount = merchantConfig?.plan?.amount ?? paymentManager.amount;
    String formattedAmount = "";
    if (merchantConfig?.rate != null && amount != null) {
      formattedAmount =
          "${merchantConfig!.rate.to} ${(merchantConfig.rate.rate * amount).toStringAsFixed(2)}";
    } else {
      formattedAmount =
          'Pay ${merchantConfig!.rate.from} ${amount?.toStringAsFixed(2) ?? ""}';
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
            validCard: _validCreditCardNumber,
            textEditingController: cardNumberController,
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
                  validCard: _validExpiryDate,
                  textEditingController: expiryController,
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
                  validCard: _validCvv,
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
              if (amount != null) {
                if (validCard) {
                  _createPayment(
                      paymentManager, merchantConfig.rate.to, amount);
                } else {
                  _validateCreditCard();
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: SpotFlowColors.primaryBase,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                validCard != true ? "Validate Card" : 'Pay $formattedAmount',
                style: SpotFlowTextStyle.body14SemiBold
                    .copyWith(color: SpotFlowColors.kcBaseWhite),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              const Expanded(
                child: ChangePaymentButton(),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CancelPaymentButton(
                  close: widget.close,
                ),
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

  Future<void> _createPayment(SpotFlowPaymentManager paymentManager,
      String currency, num amount) async {
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
        currency: currency,
        amount: amount,
        channel: 'card',
        encryptedCard: encryptedCard);
    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);
    try {
      final response = await paymentService.createPayment(
        paymentRequestBody,
      );
      paymentResponseBody = PaymentResponseBody.fromJson(response.data);

      if (mounted) {
        handleCardSuccessResponse(
          response: response,
          paymentManager: paymentManager,
          context: context,
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String? message;
      if (data is Map) {
        message = data['message'];
      }
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ErrorPage(
                message: message ?? "Couldn't process your payment",
                paymentOptionsEnum: PaymentOptionsEnum.card),
          ),
        );
      }
    }
    setState(() {
      creatingPayment = false;
    });
  }

  PaymentResponseBody? paymentResponseBody;

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

  final _ccValidator = CreditCardValidator();

  bool? _validCvv;
  bool? _validExpiryDate;
  bool? _validCreditCardNumber;

  _validateCreditCard() {
    final ccNumResults = _ccValidator.validateCCNum(cardNumberController.text);
    final expDateResults = _ccValidator.validateExpDate(expiryController.text);
    final cvvResults =
        _ccValidator.validateCVV(cvvController.text, ccNumResults.ccType);
    setState(() {
      _validCvv = cvvResults.isValid;
      _validExpiryDate = expDateResults.isPotentiallyValid;
      _validCreditCardNumber = ccNumResults.isPotentiallyValid;
    });
  }

  Future<String> encryptCard(SpotFlowCard card, String encryptionKey) async {
    try {
      return encryptAES256(encryptionKey, card.toString());
    } catch (e) {
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
