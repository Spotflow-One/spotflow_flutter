import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/core/models/payment_options_enum.dart';
import 'package:spotflow/src/core/models/payment_request_body.dart';
import 'package:spotflow/src/core/services/payment_service.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/views/card/widgets/bottom_sheet_with_search.dart';
import 'package:spotflow/src/ui/views/ussd/copy_ussd_page.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/dismissible_app_logo.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';
import 'package:spotflow/src/ui/widgets/pci_dss_icon.dart';
import 'package:spotflow/src/ui/widgets/primary_button.dart';
import 'package:spotflow/src/ui/widgets/user_and_rate_information_card.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 28,
        ),
        const DismissibleAppLogo(),
        const SizedBox(
          height: 24,
        ),
        const UserAndRateInformationCard(),
        const SizedBox(
          height: 32,
        ),
        const PaymentCard(),
        const SizedBox(
          height: 24,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Selected payment method',
          style: SpotFlowTextStyle.body14SemiBold.copyWith(
            color: SpotFlowColors.tone70,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        PaymentOptionsTile(
          icon: PaymentOptionsEnum.ussd.icon,
          text: PaymentOptionsEnum.ussd.title,
          onTap: () {},
        ),
        const SizedBox(
          height: 16.0,
        ),
        const Divider(
          color: Color(0xFFF7F7F8),
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 32.0,
        ),
        if (loading) ...[
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ] else ...[
          Text(
            'Please choose your bank to begin payment',
            style: SpotFlowTextStyle.body16SemiBold.copyWith(
              fontWeight: FontWeight.w700,
              color: SpotFlowColors.tone70,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              showBanksDropDown();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bank",
                          style: SpotFlowTextStyle.body12Regular
                              .copyWith(color: SpotFlowColors.tone40),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          bank?.name ?? "Select your bank",
                          style: SpotFlowTextStyle.body14Regular.copyWith(
                            color: bank == null
                                ? SpotFlowColors.tone40
                                : SpotFlowColors.tone70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Assets.svg.chevronDown.svg(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          PrimaryButton(
              text: 'Pay',
              onTap: () {
                _toCopyPage();
              }),
          const Spacer(),
          const PoweredBySpotflowTag(),
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
      final paymentService =
          PaymentService(paymentManager.key, paymentManager.debugMode);
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
            context.read<AppStateProvider>().trackEvent('select_bank');
            setState(() {
              this.bank = bank as Bank;
            });
          },
        );
      },
    );
  }

  _toCopyPage() {
    if (mounted == false || bank == null) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CopyUssdPage(
          bank: bank!,
          close: widget.close,
        ),
      ),
    );
  }
}
