import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

class CurrencyCardPill extends StatelessWidget {
  const CurrencyCardPill({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyName = context.watch<AppStateProvider>().currencyName;

    if (currencyName == null) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 11),
      decoration: BoxDecoration(
        color: SpotFlowColors.tone100,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text(
        "$currencyName card",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
