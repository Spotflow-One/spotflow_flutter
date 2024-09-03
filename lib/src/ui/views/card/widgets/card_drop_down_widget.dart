import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/utils/spotflow-colors.dart';
import 'package:spotflow/src/ui/utils/text_theme.dart';

class CardDropdownWidget extends StatelessWidget {
  final String labelText;
  final String? text;
  final String hintText;
  final bool enabled;
  final GestureTapCallback onTap;

  const CardDropdownWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.text,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
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
        child: Row(
          children: [
            Expanded(
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
                  if (text != null) ...[
                    Text(
                      text!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF55515B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ] else ...[
                    Text(
                      hintText,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: SpotFlowColors.tone40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 4.5,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled ? Colors.black : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
