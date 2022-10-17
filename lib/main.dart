import 'package:flutter/material.dart';
import 'package:qr_scan_gen/qrScanner.dart';
import 'package:qr_scan_gen/qrScannerOverlay.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'flutter',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late QrScanner qrScanner;
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    // Create a local copy of the QRScanner to be used within the main dart file
    qrScanner = QrScanner(
        // When we get a callback from the child, change the AppBar title
        callback: (value) => setState(() {
          barcode = value;
        }));

    return DefaultTabController(
      length: 2,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        // Add a listener to the tabController to see if we're switching tabs
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            if(tabController.index != 0) {
              // When we change tab pages, we should stop the scanner to save
              // resources
              qrScanner.getCameraController().stop();
            }
          }
        });
        return Scaffold(
          appBar: AppBar(
            // Show that we loaded data from the QR Code
            title: Text(barcode == "" ? "QRScanner" : barcode),
            actions: [
              IconButton(
                  onPressed: () {
                    // Allow the user to change the camera facing position
                    qrScanner.getCameraController().switchCamera();
                  },
                  icon: const Icon(Icons.camera_rear_outlined))
            ],
            bottom: TabBar(
              tabs: const [
                Tab(icon: Icon(Icons.qr_code_scanner)),
                Tab(icon: Icon(Icons.qr_code)),
              ],
              controller: tabController,
            ),
          ),
          body: TabBarView(children: [
            Stack(children: [
              // Display the scanner with a overlay
              qrScanner,
              QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
            ]),
            // Generate the QR code with dummy data
            QrImage(
              data: "1234567890",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ]),
        );
      }),
    );
  }
}
