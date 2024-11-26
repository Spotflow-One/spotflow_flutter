## **Flutter SDK**

Our Flutter SDK provides a rich set of pre-built UI components and APIs to seamlessly integrate payment functionalities within your Flutter application.

### **Introduction**

The `Spotflow Flutter SDK` package allows developers to effortlessly integrate seamless payment functionalities into their Flutter applications. It supports both Android and iOS platforms, making it versatile for mobile app development.

### **Installation**

To use the `Spotflow Flutter SDK` package, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  spotflow: ^1.0.0
```

Then run `flutter pub get` to fetch the package.

<aside>
⚠️ **Beta Release**

The Flutter SDK is currently a beta release. If you encounter any issues, kindly reach out to our support team at support@spotflow.one. 

</aside>

### **Usage**

### **Making payments**

To start the `Spotflow` package, use the `Spotflow().start()` method. This method requires a `BuildContext` and a `SpotFlowPaymentManager` with various parameters.

Here is an example of how to make a payment using the `Spotflow` package:

```dart
Spotflow().start( context: context,
 paymentManager: SpotFlowPaymentManager( merchantId: "",
  customerEmail: "customer@example.com" ,
  customerName: "John Snow", //optional
  customerPhoneNumber: "000-000-000", //optional
  customerId: "unique_id" //optional
  planId: "plan_id",
  amount: 10,
  key: "your_api_key",
  encryptionKey: "encryption_key",
  paymentDescription: "Product purchase",
  appLogo: SizedBox() // Optional
 ),
 onComplete: (paymentResponseBody) {
 }
 );
```

### **Parameters**

- **context**: The `BuildContext` of the application.
- **paymentManager**: An instance of `SpotFlowPaymentManager` containing the payment details.
- onComplete: An optional function to be called when the payment is completed successfully.

### **SpotFlowPaymentManager**

The `SpotFlowPaymentManager` class requires the following parameters:

- **customerEmail**: The email address of the customer.
- **amount**: The amount to be paid.
- **key**: The API key for the payment provider.
- **planId**: The unique identifier for the payment plan.
- **encryptionKey**: The encryption key for securing the transaction.
- **customerId** *(optional)*: The unique identifier for the customer.
- **customerName** *(optional)*: The name of the customer.
- **customerPhoneNumber** *(optional)*: The phone number of the customer.
- **paymentDescription** *(optional)*: A description of the payment.
- **appLogo** *(optional)*: An image widget for the application logo.
- **appName** *(optional)*: The name of the application.

### **Testing Your Implementation**

Use test cards provided by your payment provider to test your implementation.

### **Running the Example Project**

An example project has been provided on our [Github repository.](https://github.com/Spotflow-One/spotflow_flutter) Clone the repository and navigate to the example folder. Open it with a supported IDE or run `flutter run` from the terminal in that folder.
