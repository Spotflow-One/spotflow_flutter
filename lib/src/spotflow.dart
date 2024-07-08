import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/views/ussd/copy_ussd_page.dart';

class Spotflow {
  start({
    required BuildContext context,
    Widget? appLogo,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CopyUssdPage(),
      ),
    );
  }
}
