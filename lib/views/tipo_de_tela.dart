import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:calculadora_orcamento/views/tipo_de_tela_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TipoDeTela extends StatefulWidget {
  const TipoDeTela({super.key});

  @override
  State<TipoDeTela> createState() => _TipoDeTelaState();
}

class _TipoDeTelaState extends State<TipoDeTela> {
  final TextEditingController nomeTipoTelaController = TextEditingController();
  final TextEditingController margemLucroController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    carregarListaTelas();
    super.initState();
  }

  void carregarListaTelas() async {
    await LocalDbCal().readAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Tipo de Tela",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: allDataTipoTelaList.length,
        itemBuilder: (context, index) {
          var margemlucro = double.parse(
              allDataTipoTelaList[index]['MargemLucro'].toString());
          return ListTile(
            title: Text("Tipo Tela ${allDataTipoTelaList[index]['NomeTela']}"),
            subtitle:
                Text("Margem de Lucro: ${margemlucro.toStringAsFixed(2)}%"),
            trailing: Wrap(
              direction: Axis.horizontal,
              children: [
                IconButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TipoDeTelaUpdate(
                                id: allDataTipoTelaList[index]['id'],
                                tipoTela: allDataTipoTelaList[index]
                                    ['NomeTela'],
                                margemLucro: margemlucro),
                          ));
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () async {
                      await LocalDbCal()
                          .deleteDb(id: allDataTipoTelaList[index]['id']);
                      await LocalDbCal().readAllData();
                      setState(() {});
                    },
                    icon: Icon(Icons.delete)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Adicionar Tipo de Tela"),
              content: Wrap(
                children: [
                  TextField(
                    controller: nomeTipoTelaController,
                    decoration:
                        InputDecoration(hintText: "Nome do Tipo de Tela"),
                  ),
                  TextField(
                    controller: margemLucroController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(casasDecimais: 2),
                    ],
                    decoration: InputDecoration(hintText: "Margem de Lucro"),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fechar")),
                ElevatedButton(
                    onPressed: () async {
                      await LocalDbCal().addTipoTela(
                          nomeTela: nomeTipoTelaController.text,
                          margemLucro:
                              UtilBrasilFields.converterMoedaParaDouble(
                                  margemLucroController.text));
                      await LocalDbCal().readAllData();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("Adicionar")),
              ],
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.lightGreen.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
