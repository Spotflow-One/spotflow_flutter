import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

import '../utils/spotflow_colors.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.watch<AppStateProvider>().merchantConfig;
    final paymentManager = context.watch<AppStateProvider>().paymentManager!;

    String toCurrency = merchantConfig?.rate.to.toUpperCase() ?? "";
    String fromCurrency = merchantConfig?.rate.from.toUpperCase() ?? "";

    num? amount = merchantConfig?.plan?.amount ?? paymentManager.amount;

    num? convertedAmount;
    if (amount != null && merchantConfig?.rate.rate != null && merchantConfig!.rate.rate > 0 ) {
      convertedAmount = amount / merchantConfig.rate.rate;
    }

    String paymentDescription = paymentManager.paymentDescription ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paymentDescription,
          style: SpotFlowTextStyle.body16SemiBold.copyWith(
            color: SpotFlowColors.tone100,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          '$toCurrency ${convertedAmount?.toStringAsFixed(2) ?? ""}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: SpotFlowColors.tone100,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        RichText(
            text: TextSpan(
                text: 'To pay: ',
                style: const TextStyle(
                  color: SpotFlowColors.tone100,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                children: [
              TextSpan(
                  text: "$fromCurrency $amount",
                  style: const TextStyle(
                    color: SpotFlowColors.tone100,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
            ]))
      ],
    );
  }
}
