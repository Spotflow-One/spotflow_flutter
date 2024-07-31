# Spotflow Flutter Package Documentation

## Introduction

The `Spotflow` package allows developers to integrate seamless payment functionalities into their Flutter applications using various providers such as Flutterwave. It supports both Android and iOS platforms, making it versatile for mobile app development.

## Installation

To use the `Spotflow` package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  spotflow: ^1.0.0
 ```

Then run `flutter pub get` to install the package.

## Usage

### Making payments

To start the `Spotflow` package, use the `Spotflow().start()` method. This method requires a `BuildContext` and a `SpotFlowPaymentManager` with various parameters.

Here is an example of how to make a payment using the `Spotflow` package:

```dart
Spotflow().start( context: context,
 paymentManager: SpotFlowPaymentManager( merchantId: "",
  customerEmail: "" , 
  paymentId: "", 
  fromCurrency: "", 
  toCurrency: "",
  amount: 0,
  key: "",
  provider: "",
  paymentDescription: "",
  appLogo: SizedBox() 
 );
 ```

### Parameters

-   **context**: The `BuildContext` of the application.
-   **paymentManager**: An instance of `SpotFlowPaymentManager` containing the payment details.

### SpotFlowPaymentManager

The `SpotFlowPaymentManager` class requires the following parameters:

-   **merchantId**: The unique identifier for the merchant.
-   **customerEmail**: The email address of the customer.
-   **paymentId**: A unique identifier for the payment.
-   **fromCurrency**: The currency from which the amount is being converted.
-   **toCurrency**: The currency to which the amount is being converted.
-   **amount**: The amount to be paid.
-   **key**: The API key for the payment provider.
-   **provider**: The payment provider (e.g., "flutterwave").
-   **paymentDescription**: A description of the payment.
-   **appLogo**: An image widget for the application logo.

## Testing Your Implementation

Use test cards provided by your payment provider to test your implementation.

## Running the Example Project

An example project has been provided in this plugin. Clone the repository and navigate to the example folder. Open it with a supported IDE or run `flutter run` from the terminal in that folder.

## Contributing, Issues, and Bug Reports

The project is open to public contributions. Feel free to contribute. If you experience any issues or want to report a bug, please open an issue on the repository. Be as descriptive as possible.
