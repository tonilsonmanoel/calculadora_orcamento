import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/models/localDB.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParcelamentoCartaoConfig extends StatefulWidget {
  const ParcelamentoCartaoConfig({super.key});

  @override
  State<ParcelamentoCartaoConfig> createState() =>
      _ParcelamentoCartaoConfigState();
}

class _ParcelamentoCartaoConfigState extends State<ParcelamentoCartaoConfig> {
  List<bool?> listCheckbox = [];
  final TextEditingController taxaJurosController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    carregarDados();
    super.initState();
  }

  void carregarDados() async {
    await LocalDbCal().allDataParceCard();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 105, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Parcelamento no Cartão",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: allDataParcelamentoCard.length,
        itemBuilder: (context, index) {
          bool? isChecked = false;
          if (allDataParcelamentoCard[index]["Status"] == 1) {
            isChecked = true;
          }
          listCheckbox.add(isChecked);
          return ListTile(
            leading: Checkbox(
              value: listCheckbox[index],
              activeColor: Colors.green,
              onChanged: (value) async {
                int statusCard = 0;
                if (value == true) {
                  statusCard = 1;
                }
                await LocalDbCal().updateStatusParcelamento(
                    status: statusCard,
                    id: allDataParcelamentoCard[index]["id"]);
                setState(() {
                  listCheckbox[index] = value;
                });
              },
            ),
            title: Text(allDataParcelamentoCard[index]["id"] == 1
                ? "Débito"
                : "Parcelamento em ${allDataParcelamentoCard[index]["NumParcela"]}x "),
            subtitle: Text(
                "Taxa de Juros: ${UtilBrasilFields.obterReal(allDataParcelamentoCard[index]["TaxaJuros"], decimal: 2, moeda: false)}%"),
            trailing: Wrap(
              direction: Axis.horizontal,
              children: [
                IconButton(
                    onPressed: () {
                      double juros = double.parse(allDataParcelamentoCard[index]
                              ["TaxaJuros"]
                          .toString());
                      taxaJurosController.text = juros.toStringAsFixed(2);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Modificar Parcelamento"),
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          content: Wrap(
                            children: [
                              TextField(
                                controller: taxaJurosController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(casasDecimais: 2),
                                ],
                                decoration: InputDecoration(
                                  label: const Text("Margem de Lucro"),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
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
                                  await LocalDbCal().updateTaxaDeJuros(
                                      taxaJuros: UtilBrasilFields
                                          .converterMoedaParaDouble(
                                              taxaJurosController.text),
                                      id: allDataParcelamentoCard[index]["id"]);
                                  await LocalDbCal().allDataParceCard();
                                  Navigator.pop(context);
                                  setState(() {});
                                  taxaJurosController.text = "";
                                },
                                child: Text("Atualiza")),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
          );
        },
      ),
    );
  }
}
