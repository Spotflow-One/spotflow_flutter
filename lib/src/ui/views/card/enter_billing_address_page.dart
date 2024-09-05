import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/models/validate_payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/spotflow.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/authorization_web_view.dart';
import 'package:spotflow/src/ui/views/card/widgets/card_drop_down_widget.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import '../../../core/models/country.dart';
import 'card_payment_status_check_page.dart';
import 'widgets/bottom_sheet_with_search.dart';
import 'widgets/card_input_field.dart';

class EnterBillingAddressPage extends StatelessWidget {
  final PaymentResponseBody paymentResponseBody;
  final GestureTapCallback close;

  const EnterBillingAddressPage({
    super.key,
    required this.paymentResponseBody,
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
            paymentResponseBody: paymentResponseBody,
            close: close,
          ),
        ),
      ],
    );
  }
}

class _CardInputUI extends StatefulWidget {
  final PaymentResponseBody paymentResponseBody;
  final GestureTapCallback close;

  const _CardInputUI({
    super.key,
    required this.paymentResponseBody,
    required this.close,
  });

  @override
  State<_CardInputUI> createState() => _CardInputUIState();
}

class _CardInputUIState extends State<_CardInputUI>
    implements TransactionCallBack {
  TextEditingController addressController = TextEditingController();

  TextEditingController zipCodeController = TextEditingController();

  bool creatingPayment = false;

  bool buttonEnabled = false;

  List<Country> countries = [];

  Country? country;

  CountryState? countryState;

  City? city;

  @override
  void dispose() {
    addressController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initJson();
  }

  @override
  Widget build(BuildContext context) {
    final paymentManager = context.read<AppStateProvider>().paymentManager!;
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
              'Fill in Your Billing Address',
              style: SpotFlowTextStyle.body16SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 34,
          ),
          CardInputField(
            labelText: 'Address',
            hintText: "Osapa London",
            textEditingController: addressController,
            textInputType: TextInputType.streetAddress,
            onChanged: (_) => onAddressChanged(),
          ),
          const SizedBox(
            height: 28,
          ),
          Row(
            children: [
              Expanded(
                child: CardDropdownWidget(
                  labelText: "Country",
                  hintText: "Enter country",
                  text: country?.name,
                  enabled: countries.isNotEmpty,
                  onTap: () {
                    showCountryDropdown();
                  },
                ),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CardDropdownWidget(
                  labelText: "State",
                  hintText: "Enter state",
                  text: countryState?.name,
                  enabled: country != null,
                  onTap: () {
                    showStateDropDown();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 28.0,
          ),
          Row(
            children: [
              Expanded(
                child: CardDropdownWidget(
                  labelText: "City",
                  hintText: "Enter city",
                  text: city?.name,
                  enabled: countryState != null,
                  onTap: () {
                    showCityDropDown();
                  },
                ),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CardInputField(
                  labelText: 'Zipcode',
                  hintText: "000 000",
                  textInputType: TextInputType.number,
                  textEditingController: zipCodeController,
                  onChanged: (_) {
                    onAddressChanged();
                  },
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
                'Submit',
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

  Future<void> _createPayment(
      SpotFlowPaymentManager paymentManager, BuildContext context) async {
    setState(() {
      creatingPayment = true;
    });

    if (country == null || city == null || countryState == null) {
      return;
    }

    final paymentService = PaymentService(paymentManager.key);

    final avsPaymentRequest = AvsPaymentRequestBody(
      city: city!.name,
      country: country!.name,
      address: addressController.text,
      state: countryState!.name,
      zip: zipCodeController.text,
      reference: widget.paymentResponseBody.reference,
      merchantId: paymentManager.merchantId,
    );
    try {
      final response = await paymentService.authorizePayment(
        avsPaymentRequest.toJson(),
      );

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
              message: message ?? "Couldn't process your payment",
              paymentOptionsEnum: PaymentOptionsEnum.card),
        ),
      );
    }
    setState(() {
      creatingPayment = false;
    });
  }

  void onAddressChanged() {
    _validateAddress();
  }

  _validateAddress() {
    setState(() {
      buttonEnabled = addressController.text.isNotEmpty &&
          country != null &&
          countryState != null &&
          city != null &&
          zipCodeController.text.isNotEmpty;
    });
  }

  void showCountryDropdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetWithSearch(
          items: countries,
          onSelect: (country) {
            setState(() {
              this.country = country as Country;
            });
            _validateAddress();
          },
        );
      },
    );
  }

  Future<void> _initJson() async {
    final jsonString =
        await rootBundle.loadString(Assets.json.countriesStatesCities);
    final jsonBody = jsonDecode(jsonString) as List<dynamic>;

    countries = jsonBody
        .map<Country>((countryData) => Country.fromJson(countryData))
        .toList();
  }

  void showStateDropDown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BottomSheetWithSearch(
          items: country?.states ?? [],
          onSelect: (state) {
            setState(() {
              countryState = state as CountryState;
            });
            _validateAddress();
          },
        );
      },
    );
  }

  void showCityDropDown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BottomSheetWithSearch(
          items: countryState?.cities ?? [],
          onSelect: (city) {
            setState(() {
              this.city = city as City;
            });
            _validateAddress();
          },
        );
      },
    );
  }

  @override
  onTransactionComplete(ChargeResponse? chargeResponse) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CardPaymentStatusCheckPage(
          paymentReference: widget.paymentResponseBody.reference,
        ),
      ),
    );
  }
}

class EnterBillingAddressPageArgs {
  final PaymentResponseBody paymentResponseBody;

  EnterBillingAddressPageArgs({
    required this.paymentResponseBody,
  });
}
