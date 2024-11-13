import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotflow/src/ui/app_state_provider.dart';
import 'package:spotflow/src/ui/utils/spotflow_colors.dart';

class BaseScaffold extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets padding;

  const BaseScaffold({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.padding = const EdgeInsets.symmetric(horizontal: 17.0),
  });

  @override
  Widget build(BuildContext context) {
    final appLogo = context.read<AppStateProvider>().paymentManager?.appLogo;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: SpotFlowColors.primary5,
        toolbarHeight: 56,
        title: appLogo,
        centerTitle: false,
        leading: const SizedBox(),
        leadingWidth: 0,
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
