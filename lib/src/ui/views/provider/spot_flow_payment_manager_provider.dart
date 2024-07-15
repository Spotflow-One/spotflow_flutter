// import 'package:flutter/cupertino.dart';
// import 'package:spotflow/spotflow.dart';
//
// class SpotFlowPaymentManagerProvider extends InheritedWidget {
//   final SpotFlowPaymentManager paymentManager;
//
//   const SpotFlowPaymentManagerProvider({
//     super.key,
//     required this.paymentManager,
//     required super.child,
//   });
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return false;
//   }
//
//   static SpotFlowPaymentManagerProvider of(BuildContext context) {
//     final paymentManagerProvider = context
//         .dependOnInheritedWidgetOfExactType<SpotFlowPaymentManagerProvider>();
//     assert(paymentManagerProvider != null,
//         "No SpotFlowPaymentManagerProvider found in context");
//     return paymentManagerProvider!;
//   }
// }
