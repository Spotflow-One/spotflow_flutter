import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';

class DismissibleAppLogo extends StatelessWidget {
  const DismissibleAppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appLogo = context.read<AppStateProvider>().paymentManager?.appLogo;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appLogo ?? const SizedBox(),
            Assets.svg.xClose.svg(),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
