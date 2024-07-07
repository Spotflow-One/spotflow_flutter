import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "Julesanums@gmail.com",
                style: SpotFlowTextStyle.body12Regular.copyWith(
                  color: SpotFlowColors.kcBaseWhite,
                ),
              ),
              Text(
                "League Pass",
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
              Text(
                "USD 1 = NGN 1,483.98",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: SpotFlowColors.kcBaseWhite,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Assets.svg.infoCircle.svg(),
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
                'USD 14.99',
                style: SpotFlowTextStyle.body16SemiBold.copyWith(
                  color: SpotFlowColors.kcBaseWhite,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 6.0,
          ),
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
                "NGN 22,244.86",
                style: SpotFlowTextStyle.body12Regular.copyWith(
                  color: SpotFlowColors.kcBaseWhite,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
