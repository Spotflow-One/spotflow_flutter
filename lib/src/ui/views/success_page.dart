import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';

class SuccessPage extends StatefulWidget {
  final PaymentOptionsEnum paymentOptionsEnum;
  final Function()? onComplete;
  final GestureTapCallback close;
  final String successMessage;

  const SuccessPage({
    super.key,
    required this.paymentOptionsEnum,
    required this.successMessage,
    required this.onComplete,
    required this.close,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppStateProvider>().trackEvent('payment_success');
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount =
        context.read<AppStateProvider>().getFormattedAmount();
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
          const SizedBox(
            height: 24,
          ),
          Center(
            child: Assets.svg.checkIcon.svg(
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: Text(
              'Payment successful',
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body20SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'We’ve processed your ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: SpotFlowColors.tone100,
                ),
                children: [
                  TextSpan(
                    text: '$formattedAmount charge.',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SpotFlowColors.tone100,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: PrimaryButton(
              text: "Close",
              onTap: () {
                _close();
              },
            ),
          ),
          const Spacer(),
          const PoweredBySpotflowTag(),
          const SizedBox(
            height: 64,
          )
        ]);
  }

  Future<void> _close() async {
    if (mounted) {
      Navigator.of(context).popUntil(
          (route) => route.settings.name == SpotFlowRouteName.homePage);
    }

    widget.close.call();
    widget.onComplete?.call();
  }
}

class SuccessPageArguments {
  final PaymentOptionsEnum paymentOptionsEnum;
  final PaymentResponseBody paymentResponseBody;
  final String successMessage;
  final GestureTapCallback close;


  SuccessPageArguments({
    required this.paymentOptionsEnum,
    required this.successMessage,
    required this.paymentResponseBody,
    required this.close,
  });
}
