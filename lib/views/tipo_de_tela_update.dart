import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:calculadora_orcamento/views/tipo_de_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TipoDeTelaUpdate extends StatefulWidget {
  final int id;
  final String tipoTela;
  final double margemLucro;
  const TipoDeTelaUpdate(
      {super.key,
      required this.id,
      required this.tipoTela,
      required this.margemLucro});

  @override
  State<TipoDeTelaUpdate> createState() => _TipoDeTelaUpdateState();
}

class _TipoDeTelaUpdateState extends State<TipoDeTelaUpdate> {
  final TextEditingController tipoTelaController = TextEditingController();
  final TextEditingController margemlucroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    tipoTelaController.text = widget.tipoTela;
    margemlucroController.text = widget.margemLucro.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tipo de Tela",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text("ATUALIZAR TIPO DE TELA"),
                const SizedBox(
                  height: 10,
                ),
                Text("Tipo de tela: ${widget.tipoTela}"),
                const SizedBox(
                  height: 10,
                ),
                Text("Margem de lucro: ${widget.margemLucro}"),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: tipoTelaController,
                  decoration: InputDecoration(
                    hintText: "Inseri o tipo de Tela",
                    label: const Text("Tipo de Tela"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: margemlucroController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CentavosInputFormatter(casasDecimais: 2),
                  ],
                  decoration: InputDecoration(
                    hintText: "Inseri a margem de lucro",
                    label: const Text("Margem de Lucro"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await LocalDbCal().updateData(
                          id: widget.id,
                          nameTela: tipoTelaController.text,
                          margemLucro:
                              double.parse(margemlucroController.text));

                      await LocalDbCal().readAllData();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TipoDeTela(),
                        ),
                        (route) => false,
                      );
                      setState(() {});
                    },
                    child: const Text("Atualizar Nome no DB")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
