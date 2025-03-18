import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:provider/provider.dart';
import 'package:spotflow/spotflow.dart';

import '../../../../gen/assets.gen.dart' show Assets;
import '../../app_state_provider.dart' show AppStateProvider;
import '../../utils/spotflow_colors.dart' show SpotFlowColors;
import '../../utils/text_theme.dart' show SpotFlowTextStyle;

class BankAccountCard extends StatelessWidget {
  final String formattedAmount;
  final PaymentResponseBody? paymentResponseBody;
  final String? totalAmount;

  const BankAccountCard({
    super.key,
    required this.formattedAmount,
    this.paymentResponseBody,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SpotFlowColors.tone40,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Amount",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                formattedAmount,
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  context
                      .read<AppStateProvider>()
                      .trackEvent('copy_transferAmount');
                  Clipboard.setData(
                    ClipboardData(
                      text: totalAmount ?? "",
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 8),
                  child: Assets.svg.copyIcon.svg(),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Account number",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                paymentResponseBody?.bankDetails?.accountNumber ?? "",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          paymentResponseBody?.bankDetails?.accountNumber ?? "",
                    ),
                  );

                  context
                      .read<AppStateProvider>()
                      .trackEvent('copy_transferBank');
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0, left: 8),
                  child: Assets.svg.copyIcon.svg(),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                "Bank name",
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                paymentResponseBody!.bankDetails?.name ?? "",
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
