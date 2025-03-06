import 'package:flutter/material.dart';
import 'package:spotflow/gen/assets.gen.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

class BaseScaffold extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets padding;
  final GestureTapCallback? onClose;

  const BaseScaffold({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.padding = const EdgeInsets.symmetric(horizontal: 17.0),
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 56,
        title: InkWell(
          onTap: () {
            if(onClose == null) {
              Navigator.of(context).pop();
            } else {
              onClose!.call();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.svg.arrowLeft.svg(),
              const SizedBox(
                width: 2,
              ),
              const Text(
                'Go back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: SpotFlowColors.tone100,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  mainAxisAlignment: mainAxisAlignment,
                  mainAxisSize: mainAxisSize,
                  children: children,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
