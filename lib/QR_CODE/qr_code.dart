import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final String upiId;
  final String userName;
  final int totalCost;

  const QRCodePage({
    Key? key,
    required this.upiId,
    required this.userName,
    required this.totalCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Properly encode the UPI URI
    String upiUri =
        'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(userName)}&am=$totalCost&cu=INR&tt=Payment%20for%20Seats';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'One last step for happiness \n Scan & Pay!!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: upiUri,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
            const SizedBox(height: 20),
            Text(
              'Total: ₹${totalCost}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Enjoy the Day!!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
