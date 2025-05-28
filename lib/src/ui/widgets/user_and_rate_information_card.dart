import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

class UserAndRateInformationCard extends StatelessWidget {
  const UserAndRateInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final email =
        context.read<AppStateProvider>().paymentManager.customerEmail;

    final merchantConfig = context.read<AppStateProvider>().merchantConfig;

    String toCurrency = merchantConfig?.rate.to.toUpperCase() ?? "";
    String fromCurrency = merchantConfig?.rate.from.toUpperCase() ?? "";

    final rate = merchantConfig?.rate.rate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          email,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: SpotFlowColors.tone100),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Text(
              '$toCurrency 1 = $fromCurrency ${rate?.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: SpotFlowColors.tone100,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Assets.svg.infoCircleBlack.svg(),
          ],
        )
      ],
    );
  }
}
