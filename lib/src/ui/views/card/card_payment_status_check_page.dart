import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/views/error_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';

import '../success_page.dart';

class CardPaymentStatusCheckPage extends StatefulWidget {
  final SpotFlowPaymentManager paymentManager;
  final String paymentReference;
  final double? rate;

  const CardPaymentStatusCheckPage({
    super.key,
    required this.paymentManager,
    required this.paymentReference,
    required this.rate,
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
        appLogo: widget.paymentManager.appLogo,
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.payWithCardIcon.svg(),
            text: 'Pay with Card',
          ),
          PaymentCard(
            paymentManager: widget.paymentManager,
            rate: widget.rate,
          ),
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
      final paymentService = PaymentService(widget.paymentManager.key);
      final response = await paymentService.verifyPayment(
        reference: widget.paymentReference,
        merchantId: widget.paymentManager.merchantId,
      );
      final body = PaymentResponseBody.fromJson(response.data);
      if (body.status == 'successful') {
        if (context.mounted == false) {
          return;
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(
              name: SpotFlowRouteName.successPage,
            ),
            builder: (context) => SuccessPage(
              paymentOptionsEnum: PaymentOptionsEnum.card,
              paymentManager: widget.paymentManager,
              rate: widget.rate,
              successMessage:
                  "${widget.paymentManager.paymentDescription} payment successful",
            ),
          ),
        );
      } else if (body.status == "failed") {
        if (context.mounted == false) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: const RouteSettings(
              name: SpotFlowRouteName.errorPage,
            ),
            builder: (context) => ErrorPage(
              paymentOptionsEnum: PaymentOptionsEnum.transfer,
              paymentManager: widget.paymentManager,
              rate: widget.rate,
              message: body.providerMessage ?? "Payment failed",
            ),
          ),
        );
      }
    } on DioException catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(
            name: SpotFlowRouteName.errorPage,
          ),
          builder: (context) => ErrorPage(
            paymentOptionsEnum: PaymentOptionsEnum.transfer,
            paymentManager: widget.paymentManager,
            rate: widget.rate,
            message: "Payment failed",
          ),
        ),
      );
    }
  }
}
