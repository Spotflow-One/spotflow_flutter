// import 'dart:convert';
//
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotflow/src/ui/views/card/card_payment_status_check_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotFlowInAppBrowser extends StatefulWidget {
  final String url;
  final String reference;

  const SpotFlowInAppBrowser(
      {super.key, required this.url, required this.reference});

  @override
  State<SpotFlowInAppBrowser> createState() => _SpotFlowInAppBrowserState();
}

class _SpotFlowInAppBrowserState extends State<SpotFlowInAppBrowser> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _processUrl(Uri.parse(url));
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }

  _processUrl(Uri uri) {
    if (_checkHasAppendedWithResponse(uri)) {
      _finish();
    } else {
      _checkHasCompletedProcessing(uri);
    }
  }

  _checkHasCompletedProcessing(final Uri uri) {
    final status = uri.queryParameters["status"];
    final txRef = uri.queryParameters["tx_ref"];
    if (status != null && txRef != null) {
      _finish();
    }
  }

  bool _checkHasAppendedWithResponse(final Uri uri) {
    final response = uri.queryParameters["response"];
    if (response != null) {
      final json = jsonDecode(response);
      final status = json["status"];
      final txRef = json["txRef"];
      return status != null && txRef != null;
    }
    return false;
  }

  _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CardPaymentStatusCheckPage(
          paymentReference: widget.reference,
        ),
      ),
    );
  }
}
