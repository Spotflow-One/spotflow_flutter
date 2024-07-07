import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/views/error_page.dart';

class Spotflow {
  start({
    required BuildContext context,
    Widget? appLogo,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ErrorPage(),
      ),
    );
  }
}
