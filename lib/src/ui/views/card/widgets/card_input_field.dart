import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CardInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;

  const CardInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.inputFormatters,
    this.textEditingController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: SpotFlowColors.tone10,
          width: 0.5,
        ),
      ),
      child: TextField(
        inputFormatters: inputFormatters,
        controller: textEditingController,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: SpotFlowTextStyle.body12Regular.copyWith(
            color: SpotFlowColors.tone40,
          ),
          hintText: hintText,
          hintStyle: SpotFlowTextStyle.body14Regular.copyWith(
            color: SpotFlowColors.tone30,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
