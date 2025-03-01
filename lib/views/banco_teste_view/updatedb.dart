import 'package:calculadora_orcamento/models/localDB.dart';
import 'package:calculadora_orcamento/views/banco_teste_view/inserirdb.dart';
import 'package:flutter/material.dart';

class Updatedb extends StatefulWidget {
  const Updatedb({super.key, required this.id, required this.nome});
  final id;
  final nome;
  @override
  State<Updatedb> createState() => _UpdatedbState();
}

class _UpdatedbState extends State<Updatedb> {
  final TextEditingController nameUpdate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("id: ${widget.id}"),
              Text("Nome: ${widget.nome}"),
              SizedBox(
                height: 80,
              ),
              TextField(
                controller: nameUpdate,
                decoration:
                    InputDecoration.collapsed(hintText: "Inseri o nome"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Localdb()
                        .updateData(id: widget.id, name: nameUpdate.text);
                    await Localdb().readAllData();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InserirDB(),
                      ),
                      (route) => false,
                    );
                    setState(() {});
                  },
                  child: Text("Atualizar Nome no DB")),
            ],
          ),
        ),
      )),
    );
  }
}
