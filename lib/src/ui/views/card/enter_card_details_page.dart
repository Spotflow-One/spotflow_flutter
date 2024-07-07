import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class EnterCardDetailsPage extends StatelessWidget {
  const EnterCardDetailsPage({super.key});

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
        const _CardInputField(
          labelText: 'CARD NUMBER',
          hintText: '0000 0000 0000 0000',
        ),
        const SizedBox(
          height: 28,
        ),
        const Row(
          children: [
            Expanded(
              child: _CardInputField(
                labelText: 'CARD EXPIRY',
                hintText: 'MM/YY',
              ),
            ),
            SizedBox(
              width: 18.0,
            ),
            Expanded(
              child: _CardInputField(
                labelText: 'CVV',
                hintText: '123',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: SpotFlowColors.primary5,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Pay USD 14.99',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.primary20,
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
              width: 8.0,
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

class _CardInputField extends StatelessWidget {
  final String labelText;
  final String hintText;

  const _CardInputField({
    super.key,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: SpotFlowColors.tone10,
          width: 0.5,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: SpotFlowTextStyle.body12Regular.copyWith(
            color: SpotFlowColors.tone40,
          ),
          hintText: hintText,
          hintStyle: SpotFlowTextStyle.body14Regular.copyWith(
            color: SpotFlowColors.tone30,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
