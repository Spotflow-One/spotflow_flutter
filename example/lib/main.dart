import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotflow/spotflow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startPayment() {
    Spotflow().start(
      context: context,
      paymentManager: SpotFlowPaymentManager(
        customerEmail: emailController.text,
        key: merchantKeyController.text,
        encryptionKey: encryptionKeyController.text,
        paymentDescription: paymentDescriptionController.text,
        planId: planIdController.text,
        amount: num.tryParse(amountController.text) ?? 5,
        currency: currencyController.text,
        debugMode: true,
        appLogo: Image.asset(
          'assets/images/audiomack-logo.png',
        ),
      ),
    );
  }

  TextEditingController emailController =
      TextEditingController(text: "jonsnow@yopmail.com"); //

  TextEditingController encryptionKeyController =
      TextEditingController(text: "");
  TextEditingController currencyController =
      TextEditingController(text: "NGN");

  TextEditingController planIdController = TextEditingController(text: ""); //
  TextEditingController merchantKeyController =
      TextEditingController(text: ""); //
  TextEditingController paymentDescriptionController =
      TextEditingController(text: "Audiomack Premium Subscription");
  TextEditingController amountController = TextEditingController(text: "1000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Click the button below to start your payment",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "email@sample.com",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: planIdController,
                  decoration: const InputDecoration(
                    hintText: 'plan id ',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: merchantKeyController,
                  decoration: const InputDecoration(
                    hintText: 'merchant key',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: currencyController,
                  decoration: const InputDecoration(
                    hintText: 'currency',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: encryptionKeyController,
                  decoration: const InputDecoration(
                    hintText: 'encryption key',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'amount',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: paymentDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'payment description (optional)',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isEmpty ||
                        merchantKeyController.text.isEmpty ||
                        encryptionKeyController.text.isEmpty) {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please enter all required fields',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    if (amountController.text.isEmpty &&
                        planIdController.text.isEmpty) {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'please add either an amount or a plan id',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    _startPayment();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Start payment',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 64,
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
