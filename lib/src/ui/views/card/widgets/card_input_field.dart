import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CardInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;

  const CardInputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.inputFormatters,
    this.textEditingController,
    this.onChanged,
    this.textInputType,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4.5,
          ),
          Text(
            labelText,
            style: SpotFlowTextStyle.body12Regular.copyWith(
              color: SpotFlowColors.tone40,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          TextField(
            inputFormatters: inputFormatters,
            controller: textEditingController,
            onChanged: onChanged,
            maxLines: 1,
            keyboardType: textInputType,
            decoration: InputDecoration(
              hintText: hintText,
              isCollapsed: true,
              hintStyle: SpotFlowTextStyle.body14Regular.copyWith(
                color: SpotFlowColors.tone30,
              ),
              fillColor: Colors.transparent,
              filled: true,
              contentPadding: EdgeInsets.zero,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
            ),
          ),
          const SizedBox(
            height: 4.5,
          ),
        ],
      ),
    );
  }
}
