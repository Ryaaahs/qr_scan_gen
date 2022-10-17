import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  // Allows us to send data back to the parent
  final Function(String) callback;

  QrScanner({Key? key, required this.callback}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();

  MobileScannerController cameraController = MobileScannerController();

  // Allows access to camera controller to toggle it on and off
  MobileScannerController getCameraController() {
    return cameraController;
  }
}

class _QrScannerState extends State<QrScanner> with AutomaticKeepAliveClientMixin {

  // Allows are widget to persist through tab changes
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
        allowDuplicates: false,
        controller: widget.cameraController,
        onDetect: (barcode, args) {
          widget.callback('Barcode Found!' + (barcode.rawValue).toString());
        }
    );
  }


}