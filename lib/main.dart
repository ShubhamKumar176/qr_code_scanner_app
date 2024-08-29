import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(QRScannerApp());

class QRScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScannerHomePage(),
    );
  }
}

class QRScannerHomePage extends StatefulWidget {
  @override
  _QRScannerHomePageState createState() => _QRScannerHomePageState();
}

class _QRScannerHomePageState extends State<QRScannerHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Scanned QR Code: $qrText'),
                  SizedBox(height: 10),
                  qrText != null && qrText!.startsWith('http')
                      ? ElevatedButton(
                          onPressed: _launchURL,
                          child: Text('Open Link'),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  void _launchURL() async {
    if (qrText != null && await canLaunch(qrText!)) {
      await launch(qrText!);
    } else {
      throw 'Could not launch $qrText';
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
