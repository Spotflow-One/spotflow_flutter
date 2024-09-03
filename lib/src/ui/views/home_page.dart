import 'package:flutter/material.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/merchant_config_response.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
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
  final Widget? appLogo;
  final SpotFlowPaymentManager paymentManager;

  const HomePage({
    super.key,
    this.appLogo,
    required this.paymentManager,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appLogo: widget.paymentManager.appLogo,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fetchingConfig) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ] else ...[
          Expanded(
            child: _HomePageUi(
              paymentManager: widget.paymentManager,
              merchantConfig: merchantConfig,
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
    final paymentService = PaymentService(widget.paymentManager.key);
    var response = await paymentService.getMerchantConfig(
      planId: widget.paymentManager.planId,
    );
    setState(() {
      merchantConfig = MerchantConfig.fromJson(response.data);
      fetchingConfig = false;
    });
  }
}

class _HomePageUi extends StatelessWidget {
  final SpotFlowPaymentManager paymentManager;
  final MerchantConfig? merchantConfig;

  const _HomePageUi(
      {super.key, required this.paymentManager, required this.merchantConfig});

  @override
  Widget build(BuildContext context) {
    String toFormattedAmount = "";
    final rate = merchantConfig?.rate;
    if (rate != null) {
      toFormattedAmount =
          "${rate.from}${(rate.rate * paymentManager.amount).toStringAsFixed(2)}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 34,
        ),
        PaymentCard(
          paymentManager: paymentManager,
          rate: rate?.rate.toDouble(),
        ),
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
          ...PaymentOptionsEnum.values.map((e) {
            if (e == null) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: PaymentOptionsTile(
                icon: e.icon,
                text: e.title,
                onTap: () {
                  onSelected(e, context, paymentManager, rate?.rate.toDouble());
                },
              ),
            );
          }),
        ],
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: CancelPaymentButton(
            alignment: null,
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

  void onSelected(PaymentOptionsEnum e, BuildContext context,
      SpotFlowPaymentManager paymentManager, double? rate) {
    switch (e) {
      case PaymentOptionsEnum.card:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnterCardDetailsPage(
              paymentManager: paymentManager,
              rate: rate,
            ),
          ),
        );
      case PaymentOptionsEnum.transfer:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewBankDetailsPage(
              paymentManager: paymentManager,
            ),
          ),
        );
      case PaymentOptionsEnum.ussd:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewBanksUssdPage(
              paymentManager: paymentManager,
              rate: rate,
            ),
          ),
        );
    }
  }
}
