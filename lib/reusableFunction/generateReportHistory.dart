import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> generatePDFFromHistory({
  required String imageUrl,
  required List<String> labelList,
}) async {
  //Create a new PDF document
  PdfDocument document = PdfDocument();

  //Adds a page to the document
  PdfPage page = document.pages.add();

  //Draw the image
  await getImage(url: imageUrl).then((value) {
    print("Path is ${value.path}");
    page.graphics.drawImage(
      PdfBitmap(value.readAsBytesSync()),
      Rect.fromLTWH(
        0,
        0,
        page.getClientSize().width,
        page.getClientSize().height / 2,
      ),
    );
  });

  PdfOrderedList(
      items: PdfListItemCollection(
        labelList,
      ),
      font: PdfStandardFont(
        PdfFontFamily.helvetica,
        20,
        style: PdfFontStyle.regular,
      ),
      indent: 20,
      format: PdfStringFormat(
        lineSpacing: 10,
      )).draw(page: page, bounds: Rect.fromLTWH(0, 20, 0, 0));

  PdfDateTimeField dateAndTimeField = PdfDateTimeField(
      font: PdfStandardFont(PdfFontFamily.helvetica, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
  dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';

  //Create the footer with specific bounds
  PdfPageTemplateElement footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));

  //Create the page number field
  PdfPageNumberField pageNumber = PdfPageNumberField(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

  //Sets the number style for page number
  pageNumber.numberStyle = PdfNumberStyle.upperRoman;

  //Create the page count field
  PdfPageCountField count = PdfPageCountField(
      font: PdfStandardFont(PdfFontFamily.helvetica, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

  //set the number style for page count
  count.numberStyle = PdfNumberStyle.upperRoman;

  //Create the date and time field
  PdfDateTimeField dateTimeField = PdfDateTimeField(
      font: PdfStandardFont(PdfFontFamily.helvetica, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

  //Sets the date and time
  dateTimeField.date = DateTime.now();

  //Sets the date and time format
  dateTimeField.dateFormatString = 'hh\':\'mm\':\'ss';

  //Create the composite field with page number page count
  PdfCompositeField compositeField = PdfCompositeField(
      font: PdfStandardFont(PdfFontFamily.helvetica, 19),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      text: 'Page {0} of {1}, Time:{2}',
      fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
  compositeField.bounds = footer.bounds;

  //Add the composite field in footer
  compositeField.draw(footer.graphics,
      Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));

//Add the footer at the bottom of the document
  document.template.bottom = footer;

  //Save the document
  List<int> bytes = document.save();

  //Get external storage directory
  final directory = await getExternalStorageDirectory();

//Get directory path
  final path = directory!.path;

  //Create an empty file to write PDF data
  File file = File('$path/Output1.pdf');

//Write PDF data
  await file.writeAsBytes(bytes, flush: true);

  print("path is $path/output.pdf");

  //Open the PDF document in mobile
  OpenFile.open('$path/Output1.pdf');

  //Disposes the document
  document.dispose();
}

Future<File> getImage({required String url}) async {
  /// Get Image from server
  final Response res = await Dio().get<List<int>>(
    url,
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  /// Get App local storage
  final Directory appDir = await getApplicationDocumentsDirectory();

  /// Generate Image Name
  final String imageName = url.split('/').last;

  /// Create Empty File in app dir & fill with new image
  final File file = File(join(appDir.path, imageName));

  file.writeAsBytesSync(res.data as List<int>);

  return file;
}
