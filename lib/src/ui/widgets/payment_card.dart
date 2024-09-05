import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final merchantConfig = context.watch<AppStateProvider>().merchantConfig;
    final paymentManager = context.watch<AppStateProvider>().paymentManager!;

    num? conversionRate = merchantConfig?.rate.rate;
    String? fromCurrency = merchantConfig?.rate.from;
    String? toCurrency = merchantConfig?.rate.to;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          48,
          14,
          32,
        ),
        decoration: BoxDecoration(
          color: SpotFlowColors.primaryBase,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: SpotFlowColors.primary5,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  paymentManager.customerEmail,
                  style: SpotFlowTextStyle.body12Regular.copyWith(
                    color: SpotFlowColors.kcBaseWhite,
                  ),
                ),
                Text(
                  paymentManager.paymentDescription ?? "",
                  style: SpotFlowTextStyle.body14Regular.copyWith(
                    color: SpotFlowColors.kcBaseWhite,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Divider(
              color: SpotFlowColors.tone10,
              thickness: 1,
            ),
            Row(
              children: [
                if (merchantConfig != null) ...[
                  Text(
                    "$toCurrency 1 = $fromCurrency ${conversionRate?.toStringAsFixed(2) ?? ""}",
                    style: SpotFlowTextStyle.body14Regular.copyWith(
                      color: SpotFlowColors.kcBaseWhite,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Assets.svg.infoCircle.svg(),
                ],
                const Spacer(),
                Text(
                  'Pay',
                  style: SpotFlowTextStyle.body14Regular.copyWith(
                    color: SpotFlowColors.kcBaseWhite,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  '$toCurrency ${paymentManager.amount.toStringAsFixed(2)}',
                  style: SpotFlowTextStyle.body16SemiBold.copyWith(
                    color: SpotFlowColors.kcBaseWhite,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            if (conversionRate != null) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: SpotFlowColors.greenBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "$fromCurrency ${(conversionRate * paymentManager.amount).toStringAsFixed(2)}",
                    style: SpotFlowTextStyle.body12Regular.copyWith(
                      color: SpotFlowColors.kcBaseWhite,
                    ),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
