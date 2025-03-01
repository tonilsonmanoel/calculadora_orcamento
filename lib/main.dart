import 'package:calculadora_orcamento/views/banco_teste_view/inserirdb.dart';
import 'package:calculadora_orcamento/views/configucoes.dart';
import 'package:calculadora_orcamento/views/homepage.dart';
import 'package:calculadora_orcamento/views/parcelamento_cartao.dart';
import 'package:calculadora_orcamento/views/resultado_orcamento.dart';
import 'package:calculadora_orcamento/views/tipo_de_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Orcamento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
