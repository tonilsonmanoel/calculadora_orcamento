import 'dart:io';
import 'dart:typed_data';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ExportarOrcamentoCliente {
  Future<File?> orcamentoParaImagem(
      {required double aVistaValor,
      required double cartaoDebito,
      required double desconto,
      required List<DataRow> listaDataRowParc,
      required BuildContext context}) async {
    ScreenshotController screenshotController = ScreenshotController();
    int quantidadeList = listaDataRowParc.length;
    File? ImageFile;

    await screenshotController
        .captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          child: Column(
            children: [
              Container(
                width: 400,
                height: 225,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Orçamento Da Tela",
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Em dinheiro: ",
                            style: GoogleFonts.roboto(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 20)),
                        Text(
                            UtilBrasilFields.obterReal(aVistaValor,
                                decimal: 2, moeda: true),
                            style: GoogleFonts.roboto(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 20)),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Cartão Débito: ",
                            style: GoogleFonts.roboto(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                        Text(
                            UtilBrasilFields.obterReal(cartaoDebito,
                                decimal: 2, moeda: true),
                            style: GoogleFonts.roboto(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 20)),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Desconto: ",
                            style: GoogleFonts.roboto(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 18)),
                        Text(
                            UtilBrasilFields.obterReal(desconto,
                                decimal: 2, moeda: true),
                            style: GoogleFonts.roboto(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 20)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Parcelamento",
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
              //Inicio Datatable

              SizedBox(
                width: 380,
                height: quantidadeList * 68,
                child: DataTable(
                  columnSpacing: 12,
                  horizontalMargin: 10,
                  dataRowMaxHeight: 60,
                  dataRowMinHeight: 30,
                  columns: const [
                    DataColumn2(
                        label: Text('Quant.\nParcela'), size: ColumnSize.S),
                    DataColumn2(
                        label: Text('Valor\nParcela'), size: ColumnSize.M),
                    DataColumn2(
                        label: Text('Valor\nFinal'), size: ColumnSize.M),
                  ],
                  rows: listaDataRowParc,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              //Fim dataTable
            ],
          ),
        ),
      ),
      delay: Duration(milliseconds: 100),
      pixelRatio: 2.5, //1.5
      context: context,
    )
        .then((capturedImage) async {
      if (capturedImage != null) {
        print("Gerou imagem");
        final root = await getTemporaryDirectory();
        String diretorioPath = "${root.path}/calculadora_orcamento";
        await Directory(diretorioPath).create(recursive: true);
        String filePath =
            "${diretorioPath}/imagem${DateTime.now().millisecondsSinceEpoch}.png";
        final file = await File(filePath).writeAsBytes(capturedImage);

        ImageFile = file;
      }
    });

    return ImageFile;

    /*
      const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  width: 380,
                  height: quantidadeList * 60,
                  child: DataTable(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    dataRowMaxHeight: 60,
                    dataRowMinHeight: 30,
                    columns: const [
                      DataColumn2(
                          label: Text('Quant.\nParcela'), size: ColumnSize.S),
                      DataColumn2(
                          label: Text('Valor\nParcela'), size: ColumnSize.M),
                      DataColumn2(
                          label: Text('Valor\nFinal'), size: ColumnSize.M),
                      DataColumn2(
                          label: Text('Taxa\nJuros'), size: ColumnSize.S),
                    ],
                    rows: listaDataRowParc,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
    */
  }

  Future<void> compatilhaImagem(
      {String? LabelText, required File imageFile}) async {
    //Compatilhando Imagem
    await Share.shareXFiles([XFile(imageFile.path)], text: LabelText);
  }
}
