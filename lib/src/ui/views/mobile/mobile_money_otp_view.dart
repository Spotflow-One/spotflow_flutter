import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spot_flow_route_name.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';
import 'package:spotflow/src/ui/widgets/base_scaffold.dart';
import 'package:spotflow/src/ui/widgets/payment_card.dart';
import 'package:spotflow/src/ui/widgets/payment_options_tile.dart';

class MobileMoneyOtpView extends StatefulWidget {
  final String message;

  const MobileMoneyOtpView({super.key, required this.message});

  @override
  State<MobileMoneyOtpView> createState() => _MobileMoneyOtpViewState();
}

class _MobileMoneyOtpViewState extends State<MobileMoneyOtpView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String _remainingTime = "10:00";

  @override
  void initState() {
    super.initState();
    _initCountDown(const Duration(minutes: 10));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentOptionsTile(
          icon: Assets.svg.mobile.svg(),
          text: 'Pay with Mobile Money',
        ),
        const PaymentCard(),
        const SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: Center(
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: SpotFlowTextStyle.body14SemiBold.copyWith(
                color: SpotFlowColors.tone70,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 34,
        ),
        PinCodeTextField(
          appContext: context,
          length: 4,
          obscureText: true,
          obscuringCharacter: '*',
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            selectedBorderWidth: 1,
            inactiveBorderWidth: 1,
            activeBorderWidth: 1,
            borderWidth: 1,
            fieldHeight: 56,
            fieldWidth: 76,
            fieldOuterPadding: const EdgeInsets.all(9),
            activeColor: SpotFlowColors.tone40,
            inactiveColor: SpotFlowColors.tone20,
            selectedColor: SpotFlowColors.tone40,
          ),
          onCompleted: (value) {
            // _authorizePayment(paymentManager, value);
          },
          mainAxisAlignment: MainAxisAlignment.center,
          keyboardType: TextInputType.number,
          textStyle: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 31,
        ),
        InkWell(
          // onTap: () => _authorizePayment(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
            ),
            decoration: BoxDecoration(
              color: SpotFlowColors.primary70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Complete transaction',
                style: SpotFlowTextStyle.body14SemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 44.0,
        ),
        Center(
          child: CircularProgressIndicator(
            value: _animation.value,
            backgroundColor: const Color(0xFFE1E0F1),
            valueColor:
                const AlwaysStoppedAnimation<Color>(SpotFlowColors.primaryBase),
            strokeCap: StrokeCap.round,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                text: 'Resend OTP in ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: SpotFlowColors.tone60,
                ),
                children: [
                  TextSpan(
                    text: _remainingTime,
                    style: const TextStyle(
                      color: SpotFlowColors.primaryBase,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil(
                (route) => route.settings.name == SpotFlowRouteName.homePage);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          child: Text(
            'Cancel',
            style: SpotFlowTextStyle.body14SemiBold.copyWith(
              color: SpotFlowColors.tone80,
            ),
          ),
        ),
        const Spacer(),
        const SizedBox(
          height: 42.0,
        )
      ],
    );
  }

  _initCountDown(Duration duration) {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.addListener(() {
      setState(() {
        double remainingSeconds =
            (_controller.duration!.inMilliseconds * _animation.value).round() /
                1000;
        _remainingTime = formatTime(remainingSeconds.toInt());
      });
    });
    _controller.forward();
  }

  String formatTime(int remainingSeconds) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
