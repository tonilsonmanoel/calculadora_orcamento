import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculadora_orcamento/models/local_db.dart';
import 'package:flutter/material.dart';

class Calculos {
  double resultado() {
    return 10;
  }

  double pagamentoAvista(
      {required double custoTela,
      required double maoDeObra,
      required double margemDeLucro,
      required double desconto}) {
    double margemLucroValor = (margemDeLucro / 100) * custoTela;

    return (custoTela + margemLucroValor + maoDeObra) - desconto;
  }

  double pagamentoDebito({required double totalAvista}) {
    double debitoTaxaJuros =
        double.parse(allDataParcelamentoCard[0]["TaxaJuros"].toString());
    print("Taxa Debito: $debitoTaxaJuros");
    if (allDataParcelamentoCard[0]["Status"] == 1) {
      double debitoTaxa = (debitoTaxaJuros / 100) * totalAvista;
      return debitoTaxa + totalAvista;
    } else {
      return totalAvista;
    }
  }

  double lucroAvista(
      {required double custoTela,
      required double maoDeObra,
      required double margemDeLucro,
      required double desconto}) {
    double margemLucroValor = (margemDeLucro / 100) * custoTela;
    double lucroBruto = (margemLucroValor + maoDeObra + custoTela) - desconto;

    return lucroBruto - custoTela;
  }

  List<DataRow> listParcelamento({required double valorAvista}) {
    List<DataRow> listaParcelamento = [];

    //allDataParcelamentoCard[0]["TaxaJuros"] == Debito
    //Inicio do for
    for (var a = 1; a < allDataParcelamentoCard.length; a++) {
      double taxaJuros =
          double.parse(allDataParcelamentoCard[a]["TaxaJuros"].toString());
      double valorfinal = valorAvista +
          valorTaxaJuros(valor: valorAvista, taxaJuros: taxaJuros);
      double valorParcela =
          valorfinal / allDataParcelamentoCard[a]["NumParcela"];

      var dataRow = DataRow(cells: [
        DataCell(Text("${allDataParcelamentoCard[a]["NumParcela"]}x")),
        DataCell(Text(
            UtilBrasilFields.obterReal(valorParcela, decimal: 2, moeda: true))),
        DataCell(Text(
            UtilBrasilFields.obterReal(valorfinal, decimal: 2, moeda: true))),
        DataCell(Text(
            "${UtilBrasilFields.obterReal(taxaJuros, decimal: 2, moeda: false)}%")),
      ]);
      if (allDataParcelamentoCard[a]["Status"] == 1) {
        listaParcelamento.add(dataRow);
      }
    }
    //Fim do for
    return listaParcelamento;
  }

  List<DataRow> listParcelamentoSJuros({required double valorAvista}) {
    List<DataRow> listaParcelamento = [];

    //allDataParcelamentoCard[0]["TaxaJuros"] == Debito
    //Inicio do for
    for (var a = 1; a < allDataParcelamentoCard.length; a++) {
      double taxaJuros =
          double.parse(allDataParcelamentoCard[a]["TaxaJuros"].toString());
      double valorfinal = valorAvista +
          valorTaxaJuros(valor: valorAvista, taxaJuros: taxaJuros);
      double valorParcela =
          valorfinal / allDataParcelamentoCard[a]["NumParcela"];

      var dataRow = DataRow(cells: [
        DataCell(Text("${allDataParcelamentoCard[a]["NumParcela"]}x")),
        DataCell(Text(
            UtilBrasilFields.obterReal(valorParcela, decimal: 2, moeda: true))),
        DataCell(Text(
            UtilBrasilFields.obterReal(valorfinal, decimal: 2, moeda: true))),
      ]);
      if (allDataParcelamentoCard[a]["Status"] == 1) {
        listaParcelamento.add(dataRow);
      }
    }
    //Fim do for
    return listaParcelamento;
  }

  double valorTaxaJuros({required double valor, required double taxaJuros}) {
    double debitoTaxa = (taxaJuros / 100) * valor;
    return debitoTaxa;
  }

  double lucroTela({required double custoTela, required double margemLucro}) {
    double lucroTela = (margemLucro / 100) * custoTela;
    return lucroTela;
  }

  double porcetagemTelaAtualizada(
      {required double custoTela, required double lucroTela}) {
    return (lucroTela / custoTela) * 100;
  }
}
