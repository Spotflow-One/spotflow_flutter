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
import 'package:spotflow/src/ui/views/transfer/view_bank_details_page.dart';
import 'package:spotflow/src/ui/views/ussd/view_banks_ussd_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

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
          widget.paymentManager.key, widget.paymentManager.debugMode);
      var response = await paymentService.getMerchantConfig(
        planId: widget.paymentManager.planId,
      );
      merchantConfig = MerchantConfig.fromJson(response.data);
      if (mounted) {
        context.read<AppStateProvider>().setMerchantConfig(merchantConfig!);
      }
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
    final paymentManager = context.read<AppStateProvider>().paymentManager;
    final amount = merchantConfig?.plan?.amount ?? paymentManager?.amount;
    String toFormattedAmount = "";
    final rate = merchantConfig?.rate;

    if (rate != null && amount != null) {
      toFormattedAmount =
          "${rate.from}${(rate.rate * amount).toStringAsFixed(2)}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 34,
        ),
        const PaymentCard(),
        const SizedBox(
          height: 27,
        ),
        if (rate != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              'Use one of the payment methods below to pay $toFormattedAmount to Spotflow',
              style: SpotFlowTextStyle.body12Regular.copyWith(
                color: SpotFlowColors.tone40,
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 22.0, top: 60.0),
          child: Text(
            'PAYMENT OPTIONS',
            style: SpotFlowTextStyle.body16SemiBold.copyWith(
              color: SpotFlowColors.tone60,
            ),
          ),
        ),
        const SizedBox(
          height: 10.5,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Divider(
            thickness: 0.5,
            color: SpotFlowColors.tone10,
          ),
        ),
        if (merchantConfig?.paymentMethods != null) ...[
          ...merchantConfig!.paymentMethods.map((e) {
            if (e == null) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: PaymentOptionsTile(
                icon: e.icon,
                text: e.title,
                onTap: () {
                  onSelected(e, context);
                },
              ),
            );
          }),
        ],
        const SizedBox(
          height: 40,
        ),
        Center(
          child: CancelPaymentButton(
            alignment: null,
            close: closeSpotFlow,
          ),
        ),
        const Spacer(),
        const PciDssIcon(),
        const SizedBox(
          height: 32,
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
    }
  }
}
