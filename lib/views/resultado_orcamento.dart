import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/control/calculos.dart';
import 'package:calculadora_orcamento/views/exportar_orcamento_cliente.dart';
import 'package:calculadora_orcamento/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_table_2/data_table_2.dart';

class ResultadoOrcamento extends StatefulWidget {
  final double custoTela;
  final String? tipoTelaName;
  final double margemLucroTela;
  final double maoDeObra;
  final double desconto;

  const ResultadoOrcamento(
      {super.key,
      required this.custoTela,
      required this.desconto,
      required this.maoDeObra,
      required this.tipoTelaName,
      required this.margemLucroTela});

  @override
  State<ResultadoOrcamento> createState() => _ResultadoOrcamentoState();
}

class _ResultadoOrcamentoState extends State<ResultadoOrcamento> {
  double aVistaValor = 0;
  double cartaoDebito = 0;
  double lucroTotal = 0;
  double lucroTela = 0;
  List<DataRow> listaDataRowParc = [];
  List<DataRow> listaDataRowParcSJuros = [];
  @override
  void initState() {
    // TODO: implement initState
    carregarCalculosResultado();
    super.initState();
  }

  void carregarCalculosResultado() {
    aVistaValor = Calculos().pagamentoAvista(
        custoTela: widget.custoTela,
        maoDeObra: widget.maoDeObra,
        margemDeLucro: widget.margemLucroTela,
        desconto: widget.desconto);
    cartaoDebito = Calculos().pagamentoDebito(totalAvista: aVistaValor);
    lucroTotal = Calculos().lucroAvista(
        custoTela: widget.custoTela,
        maoDeObra: widget.maoDeObra,
        margemDeLucro: widget.margemLucroTela,
        desconto: widget.desconto);
    lucroTela = Calculos().valorTaxaJuros(
        valor: widget.custoTela, taxaJuros: widget.margemLucroTela);
    listaDataRowParc = Calculos().listParcelamento(valorAvista: aVistaValor);
    listaDataRowParcSJuros =
        Calculos().listParcelamentoSJuros(valorAvista: aVistaValor);
  }

  @override
  Widget build(BuildContext context) {
    final double width_media = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Resultado Orçamento",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Resultado",
                style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 23),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  "Custo da Tela:  ",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                Text(
                  UtilBrasilFields.obterReal(widget.custoTela,
                      decimal: 2, moeda: true),
                  style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text(
                  "Tipo de Tela: ",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                Text(
                  widget.tipoTelaName ?? "Não informado",
                  style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text(
                  "Margem de lucro da Tela: ",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Text(
                    "${UtilBrasilFields.obterReal(widget.margemLucroTela, decimal: 2, moeda: false)}%",
                    style: GoogleFonts.roboto(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text("Valor lucro da Tela: ",
                    style: GoogleFonts.roboto(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                Text(
                    UtilBrasilFields.obterReal(lucroTela,
                        decimal: 2, moeda: true),
                    style: GoogleFonts.roboto(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text("Mão de obra: ",
                    style: GoogleFonts.roboto(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                Text(
                    UtilBrasilFields.obterReal(widget.maoDeObra,
                        decimal: 2, moeda: true),
                    style: GoogleFonts.roboto(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              children: [
                Text("Desconto: ",
                    style: GoogleFonts.roboto(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 17)),
                Text(
                    UtilBrasilFields.obterReal(widget.desconto,
                        decimal: 2, moeda: true),
                    style: GoogleFonts.roboto(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Orçamento",
                style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
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
                Text("Lucro Total: ",
                    style: GoogleFonts.roboto(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                Text(
                    UtilBrasilFields.obterReal(lucroTotal,
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
              child: ElevatedButton.icon(
                onPressed: () async {
                  await EasyLoading.show(status: 'Gerando Imagem...');
                  print('clicou');

                  //Gerando Imagem
                  File? imageFile = await ExportarOrcamentoCliente()
                      .orcamentoParaImagem(
                          aVistaValor: aVistaValor,
                          cartaoDebito: cartaoDebito,
                          desconto: widget.desconto,
                          listaDataRowParc: listaDataRowParcSJuros,
                          context: context);
                  //Fim gerando Imagem
                  if (imageFile != null) {
                    ExportarOrcamentoCliente()
                        .compatilhaImagem(imageFile: imageFile);
                  }
                  //
                  EasyLoading.dismiss();
                },
                label: Text(
                  "Compartilhar com Cliente",
                  style: TextStyle(color: Colors.black),
                ),
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 7,
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
            const SizedBox(
              height: 7,
            ),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 12,
                horizontalMargin: 12,
                dataRowMaxHeight: double.infinity,
                dataRowMinHeight: 50,
                columns: const [
                  DataColumn2(
                      label: Text('Quant.\nParcela'), size: ColumnSize.S),
                  DataColumn2(
                      label: Text('Valor\nParcela'), size: ColumnSize.M),
                  DataColumn2(label: Text('Valor\nFinal'), size: ColumnSize.M),
                  DataColumn2(label: Text('Taxa\nJuros'), size: ColumnSize.S),
                ],
                rows: listaDataRowParc,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.green.shade800),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Change button border radius
                      ),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    elevation: const WidgetStatePropertyAll(5)),
                child: Text(
                  "Voltar",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
