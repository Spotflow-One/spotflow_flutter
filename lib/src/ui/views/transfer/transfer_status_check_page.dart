import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/views/success_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

class TransferStatusCheckPage extends StatefulWidget {
  final String reference;
  final GestureTapCallback close;
  final PaymentOptionsEnum paymentOptionsEnum;
  final PaymentResponseBody paymentResponseBody;

  const TransferStatusCheckPage({
    super.key,
    required this.reference,
    required this.close,
    required this.paymentResponseBody,
    required this.paymentOptionsEnum,
  });

  @override
  State<TransferStatusCheckPage> createState() =>
      _TransferStatusCheckPageState();
}

class _TransferStatusCheckPageState extends State<TransferStatusCheckPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _verifyPayment();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
            icon: widget.paymentOptionsEnum.icon,
            text: widget.paymentOptionsEnum.title,
            onTap: () {},
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Divider(
            color: Color(0xFFF7F7F8),
            height: 1,
            thickness: 1,
          ),
          const SizedBox(
            height: 32,
          ),
          const Center(
            child: SizedBox(
              height: 64,
              width: 64,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
                text:
                    'We are confirming transaction status. This might take a few seconds. ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: SpotFlowColors.tone40,
                ),
                children: [
                  TextSpan(
                    text: 'Please do not refresh this page',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SpotFlowColors.tone40,
                    ),
                  )
                ]),
          ),
          const Spacer(),
          const PoweredBySpotflowTag(),
          const SizedBox(
            height: 32,
          )
        ]);
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _verifyPayment();
    });
  }

  _verifyPayment() async {
    try {
      final paymentManager = context.read<AppStateProvider>().paymentManager!;

      final paymentService =
          PaymentService(paymentManager.key, paymentManager.debugMode);
      final response = await paymentService.verifyPayment(
        reference: widget.paymentResponseBody.reference,
      );
      final body = PaymentResponseBody.fromJson(response.data);
      if (body.status == 'successful') {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            SpotFlowRouteName.successPage,
            (route) {
              return route.isFirst;
            },
            arguments: SuccessPageArguments(
              paymentOptionsEnum: widget.paymentOptionsEnum,
              paymentResponseBody: widget.paymentResponseBody,
              successMessage:
                  "${paymentManager.paymentDescription} payment successful",
            ),
          );
        }
      } else if (body.status == "failed") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                paymentOptionsEnum: widget.paymentOptionsEnum,
                message: body.providerMessage ?? "Payment failed",
              ),
            ),
          );
        }
      }
    } on DioException catch (_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(
              name: SpotFlowRouteName.errorPage,
            ),
            builder: (context) => ErrorPage(
              paymentOptionsEnum: widget.paymentOptionsEnum,
              message: "Payment failed",
            ),
          ),
        );
      }
    }
  }
}
