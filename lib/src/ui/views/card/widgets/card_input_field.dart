import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class SpotflowInputField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;

  const SpotflowInputField({
    super.key,
    required this.labelText,
    this.hintText,
    this.inputFormatters,
    this.textEditingController,
    this.onChanged,
    this.textInputType,
  });

  @override
  State<SpotflowInputField> createState() => _SpotflowInputFieldState();
}

class _SpotflowInputFieldState extends State<SpotflowInputField> {


  @override
  Widget build(BuildContext context) {

    bool isEmpty =widget.textEditingController?.text.isEmpty == true;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEmpty ? const Color(0xFFCFD3D4) : const Color(0xFF9E9BA1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelText,
            style: SpotFlowTextStyle.body12Regular.copyWith(
              color: SpotFlowColors.tone40,
            ),
          ),
          TextField(
            inputFormatters: widget.inputFormatters,
            controller: widget.textEditingController,
            onChanged: (val) {
              setState(() {

              });
              widget.onChanged?.call(val);
            },
            maxLines: 1,
            keyboardType: widget.textInputType,
            style: SpotFlowTextStyle.body16Regular.copyWith(
              color: SpotFlowColors.tone70,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
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
    );
  }
}
