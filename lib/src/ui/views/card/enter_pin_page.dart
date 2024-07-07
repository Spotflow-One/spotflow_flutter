import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class EnterPinPage extends StatelessWidget {
  const EnterPinPage({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 34.0,
              vertical: 24,
            ),
            child: Text(
              "Please enter your 4-digit card pin to authorize this payment",
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          PinCodeTextField(
            appContext: context,
            length: 4,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(4),
              selectedBorderWidth: 0.5,
              inactiveBorderWidth: 0.5,
              activeBorderWidth: 0.5,
              borderWidth: 0.5,
              fieldHeight: 50,
              fieldWidth: 56,
              fieldOuterPadding: const EdgeInsets.all(9),
              activeColor: SpotFlowColors.tone40,
              inactiveColor: SpotFlowColors.tone10,
              selectedColor: SpotFlowColors.tone40,
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            keyboardType: TextInputType.number,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: Text(
              'Cancel',
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone80,
              ),
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          const PciDssIcon(),
        ]);
  }
}
