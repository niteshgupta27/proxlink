import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utill/AppConstants.dart';
import '../../../Utill/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controller/ShearQRController.dart';

class ShareQRView extends GetView<ShearQRController>  {

  const ShareQRView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'nrby',
              style: TextStyle(
                fontFamily: AppConstants.fontFamily_ADLaM_Display,
                fontSize: 23,
                fontWeight: FontWeight.normal,
                color: AppColors.whites,
                height: 1.6,
              ),
            ),
          ],
        ),
        actions: [const SizedBox(width: 48)], // To center title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "You can print this code and keep this at Reception desk",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontFamily_Acre,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: QrImageView(
                data: controller.networkId.value,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              controller.networkName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.fontFamily_Acre,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.share_outlined, "Share", () => _shareQR()),
                _buildActionButton(Icons.print_outlined, "Print", () => _printQR()),
                _buildActionButton(Icons.groups_outlined, "Members", () {
                  Get.toNamed(Routes.memebersList,arguments: {"network_id":controller.networkId,"view_as":"Host","network_name":controller.networkName.value});
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: AppConstants.fontFamily_Acre,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareQR() async {
    try {
      final qrPainter = QrPainter(
        data: controller.networkId.value,
        version: QrVersions.auto,
        gapless: false,
        color: const Color(0xFF000000), // Force black QR modules
        emptyColor: const Color(0xFFFFFFFF),
        // QrPainter requires ui.Image, so we omit for now or handle complexity
      );

      final qrImage = await qrPainter.toImageData(2048);

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code${controller.networkId.value}.png').create();
      await file.writeAsBytes(qrImage!.buffer.asUint8List());
      await Future.delayed(const Duration(seconds: 1));

      await Share.shareXFiles([XFile(file.path)], text: 'Join our network: ${controller.networkName.value}');
    } catch (e) {
      Get.snackbar("Error", "Failed to share QR code");
    }
  }

  Future<void> _printQR() async {
    try {
      final doc = pw.Document();
      final qrPainter = QrPainter(
        data: controller.networkId.value,
        version: QrVersions.auto,
        gapless: false,
      );

      final qrImage = await qrPainter.toImageData(2048);

      doc.addPage(pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(qrImage!.buffer.asUint8List())),
            );
          }));

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
    } catch (e) {
      Get.snackbar("Error", "Failed to print QR code");
    }
  }
}
