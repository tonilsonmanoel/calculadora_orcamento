import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:calculadora_orcamento/views/homepage.dart';
import 'package:calculadora_orcamento/views/parcelamento_cartao.dart';
import 'package:calculadora_orcamento/views/resultado_orcamento.dart';
import 'package:calculadora_orcamento/views/tipo_de_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final TextEditingController maoDeObraValorController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    carregarDadosUser();
    super.initState();
  }

  void carregarDadosUser() async {
    await LocalDbCal().allDataUser();
    double maoDeObraValor =
        double.parse(allDataUserList.first["MaoDeObra"].toString());
    maoDeObraValorController.text =
        UtilBrasilFields.obterReal(maoDeObraValor, decimal: 2, moeda: true);
    setState(() {});
  }

  void openDialogEdit(
      {required TextEditingController textoController,
      required String labelTitle,
      required String hintText,
      TextInputType? textInputType,
      List<TextInputFormatter>? listTextInputFormat}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labelTitle),
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
              child: const Text("Fechar")),
          ElevatedButton(
              onPressed: () async {
                await LocalDbCal().updateMaoObraUser(
                    maoDeObra: UtilBrasilFields.converterMoedaParaDouble(
                        maoDeObraValorController.text),
                    id: 1);
                await LocalDbCal().allDataUser();

                Navigator.pop(context);
                setState(() {});
              },
              child: const Text("Modificar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Configurações",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
        child: Column(
          children: [
            //Tipo de Tela
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tipo da Tela:   ",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TipoDeTela(),
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
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      elevation: const WidgetStatePropertyAll(5)),
                  child: Text(
                    "Configuração",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //Tipo de Tela
            const SizedBox(
              height: 15,
            ),
            //Mão de Obra
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Mão de Obra:  ",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                    allDataUserList.first["MaoDeObra"] != null
                        ? UtilBrasilFields.obterReal(
                            double.parse(
                                allDataUserList.first["MaoDeObra"].toString()),
                            decimal: 2,
                            moeda: true)
                        : "",
                    style: GoogleFonts.roboto(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                IconButton(
                    onPressed: () async {
                      openDialogEdit(
                          textoController: maoDeObraValorController,
                          labelTitle: "Mão de Obrar",
                          hintText: "Valor mão de obrar",
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
            //Mão de Obra
            const SizedBox(
              height: 15,
            ),
            //Parcelamento no Cartão
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Parcelamento \nno Cartão:  ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ParcelamentoCartaoConfig(),
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
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      elevation: const WidgetStatePropertyAll(5)),
                  child: Text(
                    "Configuração",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //Parcelamento no Cartão
            const SizedBox(
              height: 20,
            ),
            //Botao Volta
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

            //Botao Volta
          ],
        ),
      ),
      //Drawer Inicio
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green.shade800),
              currentAccountPicture: Image.asset("assets/logoapp.png"),
              currentAccountPictureSize: const Size(100, 100),
              accountName: const Text("Calculadora de Orçamento"),
              accountEmail: const Text("TrocaCell"),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Pagina Inicial"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
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
              leading: Icon(
                Icons.settings,
                color: Colors.green.shade800,
              ),
              title: Text(
                "Configurações",
                style: TextStyle(
                  color: Colors.green.shade800,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
