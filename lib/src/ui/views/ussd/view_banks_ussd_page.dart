import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/widgets/bottom_sheet_with_search.dart';
import 'package:spotflow/src/ui/views/ussd/copy_ussd_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/cancel_payment_button.dart';
import 'package:spotflow/src/ui/widgets/change_payment_button.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';

import '../../widgets/payment_card.dart';

class ViewBanksUssdPage extends StatefulWidget {
  final GestureTapCallback close;

  const ViewBanksUssdPage({
    super.key,
    required this.close,
  });

  @override
  State<ViewBanksUssdPage> createState() => _ViewBanksUssdPageState();
}

class _ViewBanksUssdPageState extends State<ViewBanksUssdPage> {
  bool loading = false;

  Bank? bank;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      children: [
        PaymentOptionsTile(
          icon: Assets.svg.payWithUsdIcon.svg(),
          text: 'Pay with USSD',
        ),
        const PaymentCard(),
        const SizedBox(
          height: 70,
        ),
        Assets.svg.ussdIcon.svg(),
        const SizedBox(
          height: 9.0,
        ),
        if (loading) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ] else ...[
          Text(
            'Choose your bank to start the payment',
            style: SpotFlowTextStyle.body16SemiBold,
          ),
          const SizedBox(
            height: 70,
          ),
          InkWell(
            onTap: () {
              showBanksDropDown();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 15.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: const Color(0xFFC0B5CF),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    bank?.name ?? "Select bank",
                    style: SpotFlowTextStyle.body14SemiBold.copyWith(
                      color: bank == null
                          ? SpotFlowColors.tone40
                          : SpotFlowColors.tone70,
                    ),
                  ),
                  const Spacer(),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 7.0,
                  //     vertical: 2.0,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFCCCCE8),
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   child: Text(
                  //     '*329#',
                  //     style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  //       color: SpotFlowColors.tone60,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: ChangePaymentButton(),
              ),
              SizedBox(
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
            height: 32,
          ),
          const PciDssIcon(),
          const SizedBox(
            height: 38,
          )
        ]
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  List<Bank> banks = [];

  Future<void> _fetchBanks() async {
    setState(() {
      loading = true;
    });
    try {
      final paymentManager = context.read<AppStateProvider>().paymentManager!;
      final paymentService = PaymentService(paymentManager.key);
      final banksResponse = await paymentService.getBanks();
      banks = banksResponse.data.map<Bank>((e) => Bank.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint(e.message);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Timer? timer;

  void showBanksDropDown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetWithSearch(
          items: banks,
          onSelect: (bank) {
            setState(() {
              this.bank = bank as Bank;
            });
            timer?.cancel();
            timer = Timer(
              const Duration(seconds: 1),
              _toCopyPage,
            );
          },
        );
      },
    );
  }

  _toCopyPage() {
    if (mounted == false || bank == null) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CopyUssdPage(
          bank: bank!,
          close: widget.close,
        ),
      ),
    );
  }
}
