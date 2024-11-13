import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class PciDssIcon extends StatelessWidget {
  const PciDssIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.svg.shield.svg(),
        const SizedBox(
          width: 2,
        ),
        Text(
          "PCI DSS Certified",
          style: SpotFlowTextStyle.body10Regular.copyWith(
            color: SpotFlowColors.tone40,
          ),
        )
      ],
    );
  }
}
