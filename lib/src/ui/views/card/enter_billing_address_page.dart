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
import 'package:spotflow/src/ui/utils/cards_navigation.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/widgets/card_drop_down_widget.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';

import '../../../core/models/country.dart';
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
        Expanded(
          child: _AddressInputUI(
            paymentResponseBody: paymentResponseBody,
            close: close,
          ),
        ),
      ],
    );
  }
}

class _AddressInputUI extends StatefulWidget {
  final PaymentResponseBody paymentResponseBody;
  final GestureTapCallback close;

  const _AddressInputUI({
    super.key,
    required this.paymentResponseBody,
    required this.close,
  });

  @override
  State<_AddressInputUI> createState() => _AddressInputUIState();
}

class _AddressInputUIState extends State<_AddressInputUI> with CardsNavigation {
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
            height: 40,
          ),
          Text(
            'Billing address',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone70,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SpotflowInputField(
            labelText: 'Address',
            hintText: "Osapa London",
            textEditingController: addressController,
            textInputType: TextInputType.streetAddress,
            onChanged: (_) => onAddressChanged(),
          ),
          const SizedBox(
            height: 12,
          ),
          CardDropdownWidget(
            labelText: "Country",
            hintText: "Enter country",
            text: country?.name,
            enabled: countries.isNotEmpty,
            onTap: () {
              showCountryDropdown();
            },
          ),
          const SizedBox(
            height: 12,
          ),
          CardDropdownWidget(
            labelText: "State",
            hintText: "Enter state",
            text: countryState?.name,
            enabled: country != null,
            onTap: () {
              showStateDropDown();
            },
          ),
          const SizedBox(
            height: 12.0,
          ),
          CardDropdownWidget(
            labelText: "City",
            hintText: "Enter city",
            text: city?.name,
            enabled: countryState != null,
            onTap: () {
              showCityDropDown();
            },
          ),
          const SizedBox(
            height: 12.0,
          ),
          SpotflowInputField(
            labelText: 'Zipcode',
            hintText: "000 000",
            textInputType: TextInputType.number,
            textEditingController: zipCodeController,
            onChanged: (_) {
              onAddressChanged();
            },
          ),
          const SizedBox(
            height: 28.0,
          ),
          PrimaryButton(
            onTap: () {
              _createPayment(paymentManager);
            },
            text: 'Continue',
          ),
          const SizedBox(
            height: 16,
          ),
          const PciDssTag(),
          const Spacer(),
          const PoweredBySpotflowTag(),
          const SizedBox(
            height: 32,
          )
        ],
      );
    }
  }

  Future<void> _createPayment(SpotFlowPaymentManager paymentManager) async {
    setState(() {
      creatingPayment = true;
    });

    if (country == null || city == null || countryState == null) {
      return;
    }

    final paymentService =
        PaymentService(paymentManager.key, paymentManager.debugMode);

    final avsPaymentRequest = AvsPaymentRequestBody(
      city: city!.name,
      country: country!.name,
      address: addressController.text,
      state: countryState!.name,
      zip: zipCodeController.text,
      reference: widget.paymentResponseBody.reference,
    );
    try {
      final response = await paymentService.authorizePayment(
        avsPaymentRequest.toJson(),
      );

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
        Navigator.of(context).pushReplacement(
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
    final jsonString = await rootBundle.loadString(Assets.json.location);
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
}

class EnterBillingAddressPageArgs {
  final PaymentResponseBody paymentResponseBody;

  EnterBillingAddressPageArgs({
    required this.paymentResponseBody,
  });
}
