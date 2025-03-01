import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/control/calculos.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:calculadora_orcamento/views/configucoes.dart';
import 'package:calculadora_orcamento/views/parcelamento_cartao.dart';
import 'package:calculadora_orcamento/views/resultado_orcamento.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  //TextEdition Variaveis
  final TextEditingController custoTelacontroller = TextEditingController();
  final TextEditingController margeLucroTelaController =
      TextEditingController();
  final TextEditingController valorLucroTelaController =
      TextEditingController();
  final TextEditingController maoDeObracontroller = TextEditingController();
  final TextEditingController descontocontroller = TextEditingController();
  //Fim TextEdition

  final List<String> tipoTelasItems = [];

  String? selectedValue;
  double margemLucroVal = 65.00;
  double maoDeObraValor = 80.00;
  double valorLucroTela = 0;
  @override
  void initState() {
    // TODO: implement initState
    carregarDadosDB();
    super.initState();
  }

  void carregarDadosDB() async {
    await LocalDbCal().allDataUser();
    await LocalDbCal().readAllData();
    await LocalDbCal().allDataParceCard();

    descontocontroller.text = "0,00";
    custoTelacontroller.text = "0,00";
    valorLucroTelaController.text = "0,00";
    margeLucroTelaController.text = margemLucroVal.toStringAsFixed(2);

    //Inicio Mao de Obra Dados
    maoDeObraValor =
        double.parse(allDataUserList.first["MaoDeObra"].toString());
    maoDeObracontroller.text =
        UtilBrasilFields.obterReal(maoDeObraValor, decimal: 2, moeda: false);
    //Fim Mao de Obra Dados

    //DadosTIpo Tela

    for (var a = 0; a < allDataTipoTelaList.length; a++) {
      tipoTelasItems.add(allDataTipoTelaList[a]["NomeTela"].toString());
    }

    //Fim DadosTIpo Tela

    setState(() {});
  }

  // Alert Dialog

  void openDialogEdit(
      {required TextEditingController textoController,
      required String labelTitle,
      required String hintText,
      TextInputType? textInputType,
      List<TextInputFormatter>? listTextInputFormat,
      required ElevatedButton buttonAction}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labelTitle),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Wrap(
          children: [
            TextField(
              controller: textoController,
              keyboardType: textInputType ?? TextInputType.text,
              inputFormatters: listTextInputFormat,
              decoration: InputDecoration(
                  hintText: hintText,
                  label: Text(labelTitle),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Fechar")),
          buttonAction
        ],
      ),
    );
  }

  // Alert Dialog

  void limparDadosTela() {
    margemLucroVal = 65.00;
    maoDeObraValor = 80.00;
    valorLucroTela = 0;
    descontocontroller.text = "0,00";
    custoTelacontroller.text = "0,00";
    valorLucroTelaController.text = "0,00";
    margeLucroTelaController.text = margemLucroVal.toStringAsFixed(2);
    //Inicio Mao de Obra Dados
    maoDeObraValor =
        double.parse(allDataUserList.first["MaoDeObra"].toString());
    maoDeObracontroller.text =
        UtilBrasilFields.obterReal(maoDeObraValor, decimal: 2, moeda: false);
    //Fim Mao de Obra Dados
    setState(() {});
  }

  //
  Widget buttonDropDown() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Selecionar Tipo de Tela',
        style: TextStyle(fontSize: 14),
      ),
      items: tipoTelasItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      onChanged: (value) {
        selectedValue = value.toString();
        //For Select
        for (var a = 0; a < allDataTipoTelaList.length; a++) {
          if (allDataTipoTelaList[a]["NomeTela"].toString() == value) {
            // Inicio Atualizar MargemLucro
            double margemLucroValor =
                double.parse(allDataTipoTelaList[a]["MargemLucro"].toString());
            margeLucroTelaController.text = UtilBrasilFields.obterReal(
                margemLucroValor,
                decimal: 2,
                moeda: false);
            margemLucroVal = UtilBrasilFields.converterMoedaParaDouble(
                margeLucroTelaController.text);
            // Fim Atualizar MargemLucro
            // Inicio Atualizar LucroTela
            valorLucroTela = Calculos().lucroTela(
                custoTela: UtilBrasilFields.converterMoedaParaDouble(
                    custoTelacontroller.text),
                margemLucro: margemLucroValor);
            valorLucroTelaController.text = UtilBrasilFields.obterReal(
                valorLucroTela,
                decimal: 2,
                moeda: false);
            // Fim Atualizar LucroTela
            setState(() {});
            break;
          }
        }
        //For Select
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Calculadora de Orçamento",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15, left: 35, right: 35),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Custo da Tela",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextFormField(
                    controller: custoTelacontroller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(casasDecimais: 2),
                    ],
                    onFieldSubmitted: (value) {
                      // Inicio Atualizar LucroTela
                      valorLucroTela = Calculos().lucroTela(
                          custoTela: UtilBrasilFields.converterMoedaParaDouble(
                              custoTelacontroller.text),
                          margemLucro: margemLucroVal);
                      valorLucroTelaController.text =
                          UtilBrasilFields.obterReal(valorLucroTela,
                              decimal: 2, moeda: false);
                      // Fim Atualizar LucroTela
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Custo da Tela",
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    "Tipo de Tela",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  buttonDropDown(),
                  Row(
                    children: [
                      Text(
                        "Margem de lucro da Tela: ",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      Text("${margeLucroTelaController.text}%",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      IconButton(
                          onPressed: () {
                            ElevatedButton botaomargeLucroTela = ElevatedButton(
                                onPressed: () {
                                  margemLucroVal =
                                      UtilBrasilFields.converterMoedaParaDouble(
                                          margeLucroTelaController.text);
                                  // Inicio Atualizar LucroTela
                                  valorLucroTela = Calculos().lucroTela(
                                      custoTela: UtilBrasilFields
                                          .converterMoedaParaDouble(
                                              custoTelacontroller.text),
                                      margemLucro: margemLucroVal);
                                  valorLucroTelaController.text =
                                      UtilBrasilFields.obterReal(valorLucroTela,
                                          decimal: 2, moeda: false);
                                  // Fim Atualizar LucroTela

                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text("Salvar"));
                            openDialogEdit(
                                textoController: margeLucroTelaController,
                                labelTitle: "Margem de Lucro Tela",
                                hintText: "Margem de Lucro Tela",
                                buttonAction: botaomargeLucroTela,
                                textInputType: TextInputType.number,
                                listTextInputFormat: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(casasDecimais: 2),
                                ]);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Text("Valor lucro da Tela: ",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      Text("R\$ ${valorLucroTelaController.text}",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      IconButton(
                          onPressed: () {
                            ElevatedButton botaoLucroTela = ElevatedButton(
                                onPressed: () {
                                  valorLucroTela =
                                      UtilBrasilFields.converterMoedaParaDouble(
                                          valorLucroTelaController.text);
                                  // Inicio Atualizar MargemLucro
                                  double newMargemLucroTela = Calculos()
                                      .porcetagemTelaAtualizada(
                                          custoTela: UtilBrasilFields
                                              .converterMoedaParaDouble(
                                                  custoTelacontroller.text),
                                          lucroTela: valorLucroTela);

                                  margemLucroVal = newMargemLucroTela;
                                  margeLucroTelaController.text =
                                      UtilBrasilFields.obterReal(
                                          newMargemLucroTela,
                                          decimal: 2,
                                          moeda: false);

                                  // Fim Atualizar MargemLucro

                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text("Salvar"));
                            openDialogEdit(
                              textoController: valorLucroTelaController,
                              labelTitle: "Valor Lucro da Tela",
                              hintText: "Lucro da tela",
                              buttonAction: botaoLucroTela,
                              textInputType: TextInputType.number,
                              listTextInputFormat: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(casasDecimais: 2),
                              ],
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Text("Mão de obra: ",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      Text(
                          UtilBrasilFields.obterReal(maoDeObraValor,
                              decimal: 2, moeda: true),
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      IconButton(
                          onPressed: () {
                            ElevatedButton botaoMaodeObra = ElevatedButton(
                                onPressed: () {
                                  maoDeObraValor =
                                      UtilBrasilFields.converterMoedaParaDouble(
                                          maoDeObracontroller.text);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text("Salvar"));
                            openDialogEdit(
                              textoController: maoDeObracontroller,
                              labelTitle: "Mão de obra",
                              hintText: "Valor mão de obra",
                              buttonAction: botaoMaodeObra,
                              textInputType: TextInputType.number,
                              listTextInputFormat: [
                                FilteringTextInputFormatter.digitsOnly,
                                CentavosInputFormatter(casasDecimais: 2),
                              ],
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    children: [
                      Text("Desconto: R\$  ",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      SizedBox(
                        width: 150,
                        height: 30,
                        child: TextFormField(
                          controller: descontocontroller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(casasDecimais: 2),
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Desconto",
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          double custoTelaDouble =
                              UtilBrasilFields.converterMoedaParaDouble(
                                  custoTelacontroller.text);
                          double descontoDouble =
                              UtilBrasilFields.converterMoedaParaDouble(
                                  descontocontroller.text);
                          double maoDeObraDouble =
                              UtilBrasilFields.converterMoedaParaDouble(
                                  maoDeObracontroller.text);
                          double margemLucroTelaDouble =
                              UtilBrasilFields.converterMoedaParaDouble(
                                  margeLucroTelaController.text);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultadoOrcamento(
                                  custoTela: custoTelaDouble,
                                  desconto: descontoDouble,
                                  maoDeObra: maoDeObraDouble,
                                  tipoTelaName: selectedValue ?? "",
                                  margemLucroTela: margemLucroTelaDouble,
                                ),
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
                            padding: WidgetStatePropertyAll(EdgeInsets.only(
                                left: 15, right: 15, top: 7, bottom: 8)),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            elevation: const WidgetStatePropertyAll(5)),
                        child: Text(
                          "Calcular\n Orçamento",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          limparDadosTela();
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Colors.blueGrey.shade600),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Change button border radius
                              ),
                            ),
                            padding: WidgetStatePropertyAll(EdgeInsets.only(
                                left: 12, right: 12, top: 15, bottom: 15)),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            elevation: const WidgetStatePropertyAll(5)),
                        child: Text(
                          "Limpar",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // Inicio Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green.shade800),
              currentAccountPicture: Image.asset("assets/logoapp.png"),
              currentAccountPictureSize: Size(100, 100),
              accountName: const Text("Calculadora de Orçamento"),
              accountEmail: const Text("TrocaCell"),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.green.shade800,
              ),
              title: Text(
                "Pagina Inicial",
                style: TextStyle(
                  color: Colors.green.shade800,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Parcelamento no Cartão"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParcelamentoCartaoConfig(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Configuracoes(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
