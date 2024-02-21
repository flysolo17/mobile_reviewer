import 'package:flutter/material.dart';
import 'package:mobile_reviewer/styles/pallete.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final String path;
  const PdfViewer({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$path"),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SfPdfViewer.asset("assets/files/$path",
            scrollDirection: PdfScrollDirection.horizontal),
      ),
    );
  }
}
