import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class TransferErrorPage extends StatelessWidget {
  const TransferErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(children: [
      PaymentOptionsTile(
        icon: Assets.svg.payWithTransferIcon.svg(),
        text: 'Pay with transfer',
      ),
      // const PaymentCard(),
      const Spacer(),
      const Row(
        children: [
          Expanded(
            child: ChangePaymentButton(),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: CancelPaymentButton(),
          ),
        ],
      ),
      const Spacer(),
      const PciDssIcon(),
      const SizedBox(
        height: 32,
      )
    ]);
  }
}
