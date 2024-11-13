import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';

import '../success_page.dart';

class CardPaymentStatusCheckPage extends StatefulWidget {
  final String paymentReference;

  const CardPaymentStatusCheckPage({
    super.key,
    required this.paymentReference,
  });

  @override
  State<CardPaymentStatusCheckPage> createState() =>
      _CardPaymentStatusCheckPageState();
}

class _CardPaymentStatusCheckPageState
    extends State<CardPaymentStatusCheckPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.payWithCardIcon.svg(),
            text: 'Pay with Card',
          ),
          const PaymentCard(),
          const Spacer(),
          const Center(
            child: CircularProgressIndicator(),
          ),
          const Spacer(),
        ]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    _verifyPayment().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> _verifyPayment() async {
    try {
      final paymentManager = context.read<AppStateProvider>().paymentManager!;
      final paymentService =
          PaymentService(paymentManager.key, paymentManager.debugMode);
      final response = await paymentService.verifyPayment(
        reference: widget.paymentReference,
        merchantId: paymentManager.merchantId,
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
              paymentOptionsEnum: PaymentOptionsEnum.card,
              successMessage: "Card payment successful",
              paymentResponseBody: body,
            ),
          );
        }
      } else if (body.status == "failed") {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              settings: const RouteSettings(
                name: SpotFlowRouteName.errorPage,
              ),
              builder: (context) => ErrorPage(
                paymentOptionsEnum: PaymentOptionsEnum.transfer,
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
            builder: (context) => const ErrorPage(
              paymentOptionsEnum: PaymentOptionsEnum.transfer,
              message: "Payment failed",
            ),
          ),
        );
      }
    }
  }
}
