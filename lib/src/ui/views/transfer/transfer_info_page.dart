import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/transfer/transfer_status_check_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class TransferInfoPage extends StatefulWidget {
  final PaymentResponseBody paymentResponseBody;
  final GestureTapCallback close;

  const TransferInfoPage({
    super.key,
    required this.paymentResponseBody,
    required this.close,
  });

  @override
  State<TransferInfoPage> createState() => _TransferInfoPageState();
}

class _TransferInfoPageState extends State<TransferInfoPage> {
  int currentIndex = 0;

  final copyTexts = [
    'We’ll complete this transaction automatically once we confirm your transfer.',
    'If you have any issues with this transfer, please contact us via support@spotflow.com'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaymentOptionsTile(
            icon: Assets.svg.payWithTransferIcon.svg(),
            text: 'Pay with transfer',
          ),
          const PaymentCard(),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              copyTexts.elementAt(currentIndex),
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body16SemiBold.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(
                index: 0,
                currentIndex: currentIndex,
              ),
              const SizedBox(
                width: 8,
              ),
              Indicator(
                index: 1,
                currentIndex: currentIndex,
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          if (currentIndex == 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.5),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFC0B5CF), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                child: Text(
                  'Next',
                  style: SpotFlowTextStyle.body14SemiBold.copyWith(
                    color: SpotFlowColors.tone70,
                  ),
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: SpotFlowColors.greenBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  widget.close.call();
                },
                child: Text(
                  'Close Checkout',
                  style: SpotFlowTextStyle.body14SemiBold.copyWith(
                    color: SpotFlowColors.kcBaseWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TransferStatusCheckPage(
                        reference: widget.paymentResponseBody.reference,
                        paymentResponseBody: widget.paymentResponseBody,
                        close: widget.close,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Keep waiting',
                  style: SpotFlowTextStyle.body14Regular.copyWith(
                    color: SpotFlowColors.tone70,
                  ),
                ),
              ),
            )
          ],
          const Spacer(),
          Row(
            children: [
              const Expanded(
                child: ChangePaymentButton(),
              ),
              const SizedBox(
                width: 18.0,
              ),
              Expanded(
                child: CancelPaymentButton(
                  close: widget.close,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 64,
          ),
          const PciDssIcon(),
          const Spacer(),
        ]);
  }
}

class Indicator extends StatelessWidget {
  final int index;
  final int currentIndex;

  const Indicator({super.key, required this.index, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? SpotFlowColors.primaryBase
            : Colors.transparent,
        border: Border.all(
          width: 1,
          color: currentIndex == index
              ? Colors.transparent
              : const Color(0xFFC0B5CF),
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
