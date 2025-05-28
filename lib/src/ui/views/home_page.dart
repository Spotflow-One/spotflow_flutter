import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/merchant_config_response.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/enter_card_details_page.dart';
import 'package:spotflow/src/ui/views/card/widgets/currency_card_pill.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/mobile/enter_mobile_money_details.dart';
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/views/ussd/view_banks_ussd_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

class HomePage extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final GestureTapCallback closeSpotFlow;

  const HomePage({
    super.key,
    required this.paymentManager,
    required this.closeSpotFlow,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.start,
      onClose: widget.closeSpotFlow,
      children: [
        if (fetchingConfig) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ] else if (merchantConfig == null) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.svg.warning.svg(),
                const SizedBox(
                  height: 16,
                ),
                const Text("Unable to start payment")
              ],
            ),
          )
        ] else ...[
          Expanded(
            child: _HomePageUi(
              closeSpotFlow: widget.closeSpotFlow,
            ),
          ),
        ]
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AppStateProvider>().trackEvent('checkout_opens');
    _fetchRate();
  }

  MerchantConfig? merchantConfig;

  bool fetchingConfig = false;

  Future<void> _fetchRate() async {
    setState(() {
      fetchingConfig = true;
    });
    try {
      final paymentService = PaymentService(
        widget.paymentManager.key,
        widget.paymentManager.debugMode,
      );
      final futures = await Future.wait([
        paymentService.getMerchantConfig(
          planId: widget.paymentManager.planId,
          currency: widget.paymentManager.currency,
        ),
        paymentService.getRate(to: 'USD', from: widget.paymentManager.currency)
      ]);
      var response = futures.first;

      final rate = Rate.fromJson(futures[1].data);
      merchantConfig = MerchantConfig.fromJson(response.data);
      merchantConfig?.rate = rate;
      if (mounted) {
        context.read<AppStateProvider>().setMerchantConfig(merchantConfig!);
      }
    } on DioException catch (e) {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ErrorPage(
                  message: e.response?.data['message'] ?? "Unable to start payment",
                  paymentOptionsEnum: PaymentOptionsEnum.card,
                )));
      }
      debugPrint(e.toString());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      fetchingConfig = false;
    });
  }
}

class _HomePageUi extends StatelessWidget {
  final GestureTapCallback closeSpotFlow;

  const _HomePageUi({
    super.key,
    required this.closeSpotFlow,
  });

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.read<AppStateProvider>().merchantConfig;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Select your preferred payment method',
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        if (merchantConfig?.paymentMethods != null) ...[
          ...merchantConfig!.paymentMethods.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: HomePaymentOptionsTile(
                icon: e!.icon,
                text: e.title,
                trailing: e == PaymentOptionsEnum.card
                    ? const CurrencyCardPill()
                    : null,
                onTap: () {
                  switch (e) {
                    case PaymentOptionsEnum.card:
                      context.read<AppStateProvider>().trackEvent('card_opens');
                      break;
                    case PaymentOptionsEnum.transfer:
                      context
                          .read<AppStateProvider>()
                          .trackEvent('transfer_opens');
                      break;
                    case PaymentOptionsEnum.ussd:
                      context.read<AppStateProvider>().trackEvent('ussd_opens');
                      break;
                    case PaymentOptionsEnum.mobileMoney:
                      context
                          .read<AppStateProvider>()
                          .trackEvent('mobile_money_opens');
                      break;
                  }
                  onSelected(e, context);
                },
              ),
            );
          }),
        ],
        const SizedBox(
          height: 8,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
        )
      ],
    );
  }

  void onSelected(
    PaymentOptionsEnum e,
    BuildContext context,
  ) {
    switch (e) {
      case PaymentOptionsEnum.card:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnterCardDetailsPage(
              close: closeSpotFlow,
            ),
          ),
        );
      case PaymentOptionsEnum.transfer:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewBankDetailsPage(
              close: closeSpotFlow,
            ),
          ),
        );
      case PaymentOptionsEnum.ussd:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewBanksUssdPage(
              close: closeSpotFlow,
            ),
          ),
        );
      case PaymentOptionsEnum.mobileMoney:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnterMobileMoneyDetails(
              close: closeSpotFlow,
            ),
          ),
        );
    }
  }
}
