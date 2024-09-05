import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class TransactionCallBack {
  onTransactionComplete(ChargeResponse? chargeResponse);
}

class SpotFlowInAppBrowser extends InAppBrowser {
  final TransactionCallBack callBack;

  SpotFlowInAppBrowser({required this.callBack});

  ChargeResponse? _chargeResponse;

  @override
  Future onLoadStart(url) async {
    if (url != null) _processUrl(url);
  }

  @override
  void onExit() {
    callBack.onTransactionComplete(_chargeResponse);
  }

  _processUrl(Uri uri) {
    if (_checkHasAppendedWithResponse(uri)) {
      _finishWithAppendedResponse(uri);
    } else {
      _checkHasCompletedProcessing(uri);
    }
  }

  _checkHasCompletedProcessing(final Uri uri) {
    final status = uri.queryParameters["status"];
    final txRef = uri.queryParameters["tx_ref"];
    final id = uri.queryParameters["transaction_id"];
    if (status != null && txRef != null) {
      _finish(uri);
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

  _finishWithAppendedResponse(Uri uri) {
    final response = uri.queryParameters["response"];
    final decoded = Uri.decodeFull(response!);
    final json = jsonDecode(decoded);
    final status = json["status"];
    final txRef = json["txRef"];
    final id = json["id"];

    final ChargeResponse chargeResponse = ChargeResponse(
        status: status,
        transactionId: "$id",
        txRef: txRef,
        success: status?.contains("success") == true);
    _closeTransactionScreen(chargeResponse);
    // callBack.onTransactionComplete(chargeResponse);
    // close();
  }

  _finish(final Uri uri) {
    final status = uri.queryParameters["status"];
    final txRef = uri.queryParameters["tx_ref"];
    final id = uri.queryParameters["transaction_id"];
    final ChargeResponse chargeResponse = ChargeResponse(
        status: status,
        transactionId: id,
        txRef: txRef,
        success: status?.contains("success") == true);
    _closeTransactionScreen(chargeResponse);
    callBack.onTransactionComplete(chargeResponse);
  }

  _closeTransactionScreen(final ChargeResponse chargeResponse) {
    _chargeResponse = chargeResponse;
    close();
  }
}

class ChargeResponse {
  String? status;
  bool? success;
  String? transactionId;
  String? txRef;

  ChargeResponse({this.status, this.success, this.transactionId, this.txRef});

  ChargeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? TransactionStatus.ERROR;
    success = json['success'] ?? false;
    transactionId = json['transaction_id'];
    txRef = json['tx_ref'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['transaction_id'] = transactionId;
    data['tx_ref'] = txRef;
    return data;
  }

  @override
  String toString() => toJson().toString();
}

class TransactionStatus {
  static const SUCCESSFUL = "successful";
  static const CANCELLED = "cancelled";
  static const ERROR = "error";
}
