import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:spotflow/spotflow.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_response_body.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

class SuccessPage extends StatefulWidget {
  final PaymentOptionsEnum paymentOptionsEnum;
  final SpotFlowPaymentManager paymentManager;
  final Rate? rate;
  final String successMessage;

  const SuccessPage({
    super.key,
    required this.paymentOptionsEnum,
    required this.paymentManager,
    required this.successMessage,
    this.rate,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(children: [
      Expanded(
          child: Stack(
        alignment: Alignment(0.0, -0.1),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RippleAnimation(
                repeat: true,
                ripplesCount: 3,
                minRadius: 35,
                color: const Color(0xFF54C68E),
                child: Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Color(0xFF54C68E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Text(
                widget.successMessage,
                textAlign: TextAlign.center,
                style: SpotFlowTextStyle.body14Regular.copyWith(
                  color: SpotFlowColors.tone80,
                ),
              )
            ],
          ),
          Column(
            children: [
              PaymentOptionsTile(
                icon: widget.paymentOptionsEnum.icon,
                text: widget.paymentOptionsEnum.title,
              ),
              Material(
                elevation: 1,
                color: Colors.white,
                shadowColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: PaymentCard(
                  paymentManager: widget.paymentManager,
                  rate: widget.rate,
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              const Spacer(
                flex: 3,
              ),
              const PciDssIcon(),
              const Spacer(),
            ],
          ),
        ],
      )),
    ]);
  }

  Future<void> _close() async {
    await Future.delayed(const Duration(seconds: 10));
    if (mounted == false) return;
    Navigator.of(context)
        .popUntil((route) => route.settings.name == SpotFlowRouteName.homePage);
    Navigator.of(context).pop();
  }
}