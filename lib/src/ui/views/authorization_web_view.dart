import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class TransactionCallBack {
  onTransactionComplete();
}

class SpotFlowInAppBrowser extends InAppBrowser {
  final TransactionCallBack callBack;

  SpotFlowInAppBrowser({required this.callBack});

  @override
  Future onLoadStart(url) async {
    if (url != null) _processUrl(url);
  }

  @override
  void onExit() {
    callBack.onTransactionComplete();
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
    _closeTransactionScreen();
    callBack.onTransactionComplete();
  }

  _closeTransactionScreen() {
    close();
  }
}
