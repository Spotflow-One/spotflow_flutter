import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/mobile_money_provider.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/widgets/bottom_sheet_with_search.dart';
import 'package:spotflow/src/ui/views/card/widgets/card_input_field.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/mobile/mobile_money_otp_view.dart';
import 'package:spotflow/src/ui/views/success_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

import '../../../core/models/payment_response_body.dart';

class EnterMobileMoneyDetails extends StatefulWidget {
  final GestureTapCallback close;

  const EnterMobileMoneyDetails({super.key, required this.close});

  @override
  State<EnterMobileMoneyDetails> createState() =>
      _EnterMobileMoneyDetailsState();
}

class _EnterMobileMoneyDetailsState extends State<EnterMobileMoneyDetails>
    with SingleTickerProviderStateMixin {
  final mobileNumberController = TextEditingController();

  bool buttonEnabled = false;
  MobileMoneyProvider? mobileMoneyProvider;

  List<MobileMoneyProvider> providers = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.watch<AppStateProvider>().merchantConfig;
    final paymentManager = context.watch<AppStateProvider>().paymentManager!;

    num? amount = merchantConfig?.plan?.amount ?? paymentManager.amount;

    String? fromCurrency = merchantConfig?.rate.from.toUpperCase();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Text(
              'Please enter your Mobile Money details to begin payment',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone70,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              showProviderDropDown();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: mobileMoneyProvider == null
                      ? const Color(0xFFCFD3D4)
                      : SpotFlowColors.tone40,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Network',
                        style: SpotFlowTextStyle.body14Regular.copyWith(
                          color: SpotFlowColors.tone40,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (mobileMoneyProvider == null) ...[
                        Text(
                          'Select your Network',
                          style: SpotFlowTextStyle.body14Regular.copyWith(
                            color: const Color(0xFFABAFB1),
                          ),
                        ),
                      ] else ...[
                        Text(
                          mobileMoneyProvider!.name,
                          style: SpotFlowTextStyle.body14Regular.copyWith(
                            color: SpotFlowColors.tone100,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Assets.svg.chevronDown.svg(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SpotflowInputField(
            labelText: 'Mobile money',
            hintText: "Enter your mobile number",
            textInputType: TextInputType.number,
            textEditingController: mobileNumberController,
            onChanged: (_) => _checkButtonEnabled(),
          ),
          const SizedBox(
            height: 24,
          ),
          PrimaryButton(
            enabled: buttonEnabled,
            onTap: () {
              _createPayment();
            },
            text: 'Pay $fromCurrency ${amount?.toStringAsFixed(2) ?? ""}',
          ),
          const SizedBox(
            height: 18,
          ),
          const PciDssTag(),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'This payment may incur a 1% E-Levy, as mandated by the Ghana Revenue Authority (GRA).',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body12SemiBold.copyWith(
                color: const Color(0xFF816039),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const PoweredBySpotflowTag(),
          const SizedBox(
            height: 24,
          ),
        ]);
  }

  void _checkButtonEnabled() {
    setState(() {
      buttonEnabled =
          mobileMoneyProvider != null && mobileNumberController.text.length > 8;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMobileMoneyProviders();
  }

  Future<void> _getMobileMoneyProviders() async {
    setState(() {
      loading = true;
    });
    final paymentManager = context.read<AppStateProvider>().paymentManager!;

    try {
      final paymentService =
          PaymentService(paymentManager.key, paymentManager.debugMode);
      var response = await paymentService.getMobileMoneyProviders();

      final p = response.data
          .map<MobileMoneyProvider>((e) => MobileMoneyProvider.fromJson(e))
          .toList();
      providers = p;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _createPayment() async {
    if (mobileMoneyProvider == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    final paymentManager = context.read<AppStateProvider>().paymentManager!;

    try {
      final paymentService =
          PaymentService(paymentManager.key, paymentManager.debugMode);

      final mobileMoney = MobileMoney(
        code: mobileMoneyProvider!.code,
        phoneNumber: mobileNumberController.text,
      );
      final paymentRequestBody = PaymentRequestBody(
        customer: paymentManager.customer,
        currency: paymentManager.currency,
        amount: context.read<AppStateProvider>().amount!,
        channel: 'mobile_money',
        mobileMoney: mobileMoney,
      );

      var response = await paymentService.createPayment(paymentRequestBody);

      final paymentResponseBody = PaymentResponseBody.fromJson(response.data);
      if (paymentResponseBody.status == "failed") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                  message:
                      paymentResponseBody.providerMessage ?? "Payment failed",
                  paymentOptionsEnum: PaymentOptionsEnum.mobileMoney),
            ),
          );
        }
      } else if (paymentResponseBody.authorization?.mode == 'otp' || paymentResponseBody.authorization?.mode == 'pin') {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MobileMoneyOtpView(
                paymentResponseBody: paymentResponseBody,
              ),
            ),
          );
        }
      } else if (paymentResponseBody.status == "successful") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SuccessPage(
                paymentOptionsEnum: PaymentOptionsEnum.ussd,
                close: () {},
                onComplete: () {},
                successMessage: paymentResponseBody.providerMessage ?? "",
              ),
            ),
          );
        }
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  void showProviderDropDown() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BottomSheetWithSearch(
          items: providers,
          onSelect: (provider) {
            setState(() {
              mobileMoneyProvider = provider as MobileMoneyProvider;
            });
            _checkButtonEnabled();
          },
        );
      },
    );
  }
}
