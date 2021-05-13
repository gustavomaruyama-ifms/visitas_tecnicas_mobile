import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:visitas_tecnicas_mobile/models/company.dart';
import 'package:visitas_tecnicas_mobile/models/subscription.dart';
import 'package:visitas_tecnicas_mobile/globals.dart' as globals;
import 'package:visitas_tecnicas_mobile/models/user.dart';
import 'package:visitas_tecnicas_mobile/models/visit.dart';

class CertificateScreen extends StatefulWidget{
  final Subscription subscription;
  CertificateScreen({this.subscription});
  @override
  State<StatefulWidget> createState() {
    return _CertificateScreenState(subscription: subscription);
  }
}

class _CertificateScreenState extends State<CertificateScreen>{
  final APP_BAR_TITLE = "Certificado";
  final Subscription subscription;
  final pdf = pw.Document();

  _CertificateScreenState({this.subscription});

  @override
  void initState() {
    final User user = globals.user;
    final Visit visit = subscription.visit;
    final Company company = visit.company;

    StringBuffer body = StringBuffer();
    body.write("${user.name.toUpperCase().trim()} participou da visita técnica ");
    body.write("na empresa ${company.name.toUpperCase().trim()}, ");
    body.write("localizada na cidade de ${company.city.trim()} - ${company.state.trim()}, ");
    body.write("na data de ${visit.formattedDate}, ");
    body.write("totalizando uma carga horária de ${visit.cargaHoraria} horas.");

    StringBuffer verificationCode = StringBuffer();
    verificationCode.write("Código de verificação: ${subscription.id}");

    StringBuffer certificationDate = StringBuffer();
    certificationDate.write("Coxim - MS, ${DateFormat("dd 'de' MM 'de' yyyy").format(DateTime.now()).toString()} ");

    print(jsonEncode(visit.user));
    StringBuffer signature = StringBuffer();
    signature.write("Prof. ${visit.user.name}\n");
    signature.write("Responsável pela visita.");

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView(
            children: [
              pw.Center(child:pw.Text("Certificado", style: pw.TextStyle(fontSize: 20.0))),
              pw.Center(child:pw.Text("Participação em Visita Técnica", style: pw.TextStyle(fontSize: 15.0))),
              pw.Padding(
                padding: pw.EdgeInsets.only(top: 20.0),
                child:
                  pw.Text(body.toString(),
                  textAlign: pw.TextAlign.justify,
                  overflow: pw.TextOverflow.visible,
                  softWrap: true)
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 20.0),
                    child:
                      pw.Text(verificationCode.toString())
                  )
                ]
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(top: 40.0),
                        child:
                        pw.Text(certificationDate.toString(),
                            textAlign: pw.TextAlign.justify)
                    )
                  ]
              ),
              pw.Center(
                child: pw.Padding(
                    padding: pw.EdgeInsets.only(top: 20.0),
                    child:
                    pw.Text(signature.toString(),
                        textAlign: pw.TextAlign.center)
                )
              )
            ]
          );// Center
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(APP_BAR_TITLE),),
        body: PdfPreview(
          canChangeOrientation: false,
          canChangePageFormat: false,
          shouldRepaint: false,
          pdfFileName: "certificado.pdf",
          build: (format) => pdf.save(),
        )
    );
  }
}