import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class PciDssTag extends StatelessWidget {
  const PciDssTag({super.key});

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

class PoweredBySpotflowTag extends StatelessWidget {
  const PoweredBySpotflowTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
              text: 'Powered by ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: SpotFlowColors.tone60,
              ),
              children: [
                TextSpan(
                    text: 'Spotflow',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: SpotFlowColors.tone60,
                    ))
              ])),
    );
  }
}
