import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';

class ErrorPage extends StatefulWidget {
  final String message;
  final PaymentOptionsEnum paymentOptionsEnum;

  const ErrorPage({
    super.key,
    required this.message,
    required this.paymentOptionsEnum,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          height: 24,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        Assets.svg.closeIcon.svg(
          height: 34,
          width: 34,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 32.0,
        ),
        if (widget.paymentOptionsEnum == PaymentOptionsEnum.card) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: PrimaryButton(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                    SpotFlowRouteName.enterCardDetailsPage);
                context.read<AppStateProvider>().trackEvent('payment_retry');
              },
              text: 'Try another card',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ] else if (widget.paymentOptionsEnum ==
            PaymentOptionsEnum.transfer) ...[


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: PrimaryButton(
              onTap: () {
                Navigator.of(context).pop();
                context.read<AppStateProvider>().trackEvent('payment_retry');
              },
              text: 'Try again',
            ),
          ),
        ] else if (widget.paymentOptionsEnum == PaymentOptionsEnum.ussd) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: PrimaryButton(
              onTap: () {
                context.read<AppStateProvider>().trackEvent('payment_retry');

                Navigator.of(context)
                    .pushReplacementNamed(SpotFlowRouteName.viewBanksUssdPage);
              },
              text: 'Try again',
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: PrimaryButton(
              onTap: () {
                context.read<AppStateProvider>().trackEvent('payment_retry');

                Navigator.of(context).pop();
              },
              text: 'Try again',
            ),
          ),
        ],
        const Spacer(),
        const PoweredBySpotflowTag(),
        const SizedBox(
          height: 32,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<AppStateProvider>().trackEvent('payment_failed');
  }
}
