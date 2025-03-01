import 'package:calculadora_orcamento/models/localDB.dart';
import 'package:calculadora_orcamento/views/banco_teste_view/updatedb.dart';
import 'package:flutter/material.dart';

class InserirDB extends StatefulWidget {
  const InserirDB({super.key});

  @override
  State<InserirDB> createState() => _InserirDBState();
}

class _InserirDBState extends State<InserirDB> {
  final TextEditingController name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    carregarData();
    super.initState();
  }

  void carregarData() async {
    await Localdb().readAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration:
                    InputDecoration.collapsed(hintText: "Inseri o nome"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Localdb().addDataLocally(name: name.text);
                    await Localdb().readAllData();
                    setState(() {});
                  },
                  child: Text("Salvar Nome")),
              ListView.builder(
                itemCount: wholeDataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wholeDataList[index]["Name"]),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Updatedb(
                                      id: wholeDataList[index]["id"],
                                      nome: wholeDataList[index]["Name"]),
                                ));
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.green,
                        ),
                        IconButton(
                          onPressed: () async {
                            await Localdb()
                                .deleteDb(id: wholeDataList[index]['id']);
                            await Localdb().readAllData();
                            setState(() {});
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
