import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final PaymentOptionsEnum paymentOptionsEnum;

  const ErrorPage({
    super.key,
    required this.message,
    required this.paymentOptionsEnum,
  });

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.read<AppStateProvider>().merchantConfig;

    final buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Color(0xFFC0B5CF),
          width: 1.0,
        ),
      ),
    );
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentOptionsTile(
          text: paymentOptionsEnum.title,
          icon: paymentOptionsEnum.icon,
        ),
        const PaymentCard(),
        const SizedBox(
          height: 49,
        ),
        Assets.svg.warning.svg(),
        const SizedBox(
          height: 6,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        if (merchantConfig?.paymentMethods.contains(PaymentOptionsEnum.card) ==
            true) ...[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpotFlowRouteName.enterCardDetailsPage);
            },
            style: buttonStyle,
            child: Text(
              'Try again with your card',
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
        if (merchantConfig?.paymentMethods
                .contains(PaymentOptionsEnum.transfer) ==
            true) ...[
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                SpotFlowRouteName.viewBankDetailsPage,
              );
            },
            style: buttonStyle,
            child: Text(
              'Try again with transfer',
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
        if (merchantConfig?.paymentMethods.contains(PaymentOptionsEnum.ussd) ==
            true) ...[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SpotFlowRouteName.viewBanksUssdPage);
            },
            style: buttonStyle,
            child: Text(
              'Try again with USSD',
              style: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
        const Spacer(),
        const PciDssIcon(),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }
}
