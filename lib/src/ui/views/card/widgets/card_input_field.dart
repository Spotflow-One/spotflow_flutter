import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CardInputField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final bool? validCard;

  const CardInputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.inputFormatters,
    this.textEditingController,
    this.onChanged,
    this.textInputType,
    this.validCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 4.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: SpotFlowColors.tone10,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          if (validCard == true) ...[
            SizedBox.square(
              dimension: 20,
              child: Assets.svg.greenCheckIcon.svg(),
            ),
            const SizedBox(
              width: 8,
            ),
          ] else if (validCard == false) ...[
            SizedBox.square(
              dimension: 20,
              child: Assets.svg.closeIcon.svg(),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelText,
                  style: SpotFlowTextStyle.body12Regular.copyWith(
                    color: SpotFlowColors.tone40,
                  ),
                ),
                TextField(
                  inputFormatters: inputFormatters,
                  controller: textEditingController,
                  onChanged: onChanged,
                  maxLines: 1,
                  keyboardType: textInputType,
                  style: SpotFlowTextStyle.body16Regular.copyWith(
                    color: SpotFlowColors.tone70,
                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
