import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/mobile/mobile_money_otp_view.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

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

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.watch<AppStateProvider>().merchantConfig;
    final paymentManager = context.watch<AppStateProvider>().paymentManager!;

    num? amount = merchantConfig?.plan?.amount ?? paymentManager.amount;

    String? toCurrency = merchantConfig?.rate.to.toUpperCase();

    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.mobile.svg(),
            text: 'Pay with Mobile Money',
          ),
          const PaymentCard(),
          const SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Text(
              'Please enter your Mobile Money details to begin payment',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body20SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF7F8FB),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select your Network',
                    style: SpotFlowTextStyle.body14Regular.copyWith(
                      color: SpotFlowColors.tone50,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF7F8FB),
            ),
            child: TextField(
              // inputFormatters: inputFormatters,
              controller: mobileNumberController,
              onChanged: (value) {},
              maxLines: 1,
              keyboardType: TextInputType.number,
              style: SpotFlowTextStyle.body16Regular.copyWith(
                color: SpotFlowColors.tone70,
              ),
              decoration: InputDecoration(
                hintText: 'Mobile number',
                isCollapsed: true,
                hintStyle: SpotFlowTextStyle.body14Regular.copyWith(
                  color: SpotFlowColors.tone50,
                ),
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: EdgeInsets.zero,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MobileMoneyOtpView(
                      message:
                          'Enter the OTP sent to you via SMS (2348084****74) to complete the transaction.'),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
              ),
              decoration: BoxDecoration(
                color: SpotFlowColors.primary70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Pay $toCurrency ${amount?.toStringAsFixed(2) ?? ""}',
                  style: SpotFlowTextStyle.body14SemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          const PciDssIcon(),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
                color: SpotFlowColors.primary5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: SpotFlowColors.primary10,
                )),
            child: Text(
              'This payment may incur a 1% E-Levy, as mandated by the Ghana Revenue Authority (GRA).',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.primary70,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
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
        ]);
  }
}
