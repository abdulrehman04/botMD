import 'dart:io';

import 'package:bot_md/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../globals_.dart';

class ReportDetails extends StatelessWidget {
  final DocumentSnapshot report;
  ReportDetails(this.report, {Key? key}) : super(key: key);

  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.download),
        backgroundColor: primaryColor,
        onPressed: () async {
          pdf.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Image.network(
                    //     currentUserData['image'],
                    //     height: 100,
                    //     width: 100,
                    //   ),
                    // ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Patient Name:"),
                        pw.Text(currentUserData['name'])
                        //   pw.montserratText(
                        //     text: "Patient Name:",
                        //     size: 16,
                        //     color: Colors.black,
                        //     weight: FontWeight.w400,
                        //   ),
                        //   montserratText(
                        //     text: currentUserData['name'],
                        //     size: 16,
                        //     color: Colors.black,
                        //     weight: FontWeight.w400,
                        //   ),
                      ],
                    ),
                    // Image.asset(
                    //   'Assets/logo.png',
                    //   height: 100,
                    // ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Patient Email:"),
                        pw.Text(currentUserData['email'])
                        // montserratText(
                        //   text: "Patient Email:",
                        //   size: 16,
                        //   color: Colors.black,
                        //   weight: FontWeight.w400,
                        // ),
                        // montserratText(
                        //   text: currentUserData['email'],
                        //   size: 16,
                        //   color: Colors.black,
                        //   weight: FontWeight.w400,
                        // ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 25,
                    ),
                    pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          const pw.TextSpan(
                            text:
                                "It is stated that on the Covid test you took on ",
                            style: pw.TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          pw.TextSpan(
                            text:
                                "${DateFormat('dd MMM, yyyy').format(report['date'].toDate())}, ",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: report['result'] == "None"
                                ? "our system predicts that you do not have Covid "
                                : "our system predicts that you're in state of ",
                            style: const pw.TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          pw.TextSpan(
                            text: "${report['result']}. ",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.TextSpan(
                            text: report['result'] == "Covid"
                                ? "We suggest you to take a covid test in the nearest lab."
                                : "We suggest you to take a better care of your diet.",
                            style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.RichText(
                        text: const pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "Bot",
                              style: pw.TextStyle(
                                fontSize: 18,
                                // color: Colors.blueGrey[900],
                              ),
                            ),
                            pw.TextSpan(
                              text: "MD",
                              style: pw.TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ); // Center
              }));
          final path = (await getExternalStorageDirectory())!.path;
          final file = File("$path/BotMD_Report_${DateTime.now()}.pdf");
          await file.writeAsBytes(await pdf.save()).then((value) {
            successSnack("Report Saved Successfully");
          });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              gradientAppBar(context: context, title: "Report Details"),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reportWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  reportWidget() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Image.network(
        //     currentUserData['image'],
        //     height: 100,
        //     width: 100,
        //   ),
        // ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            montserratText(
              text: "Patient Name:",
              size: 16,
              color: Colors.black,
              weight: FontWeight.w400,
            ),
            montserratText(
              text: currentUserData['name'],
              size: 16,
              color: Colors.black,
              weight: FontWeight.w400,
            ),
          ],
        ),
        // Image.asset(
        //   'Assets/logo.png',
        //   height: 100,
        // ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            montserratText(
              text: "Patient Email:",
              size: 16,
              color: Colors.black,
              weight: FontWeight.w400,
            ),
            montserratText(
              text: currentUserData['email'],
              size: 16,
              color: Colors.black,
              weight: FontWeight.w400,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "It is stated that on the Covid test you took on ",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text:
                    "${DateFormat('dd MMM, yyyy').format(report['date'].toDate())}, ",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: report['result'] == "None"
                    ? "our system predicts that you do not have Covid "
                    : "our system predicts that you're in state of ",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: "${report['result']}. ",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: report['result'] == "Covid"
                    ? "We suggest you to take a covid test in the nearesty lab"
                    : "We suggest you to take a better care of your diet",
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Bot",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.blueGrey[900],
                  ),
                ),
                TextSpan(
                  text: "MD",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.purple,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
