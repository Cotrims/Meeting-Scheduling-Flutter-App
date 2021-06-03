import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:projeto_mobile/models/evento_model.dart';
import 'package:projeto_mobile/models/funcionario_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:projeto_mobile/data/api_services.dart';
import 'package:projeto_mobile/models/lugar_model.dart';
import 'package:projeto_mobile/models/tipo_model.dart';

class FormEvento extends StatefulWidget {
  FormEvento({Key key, this.lugares, this.tipos, this.funcionarios}) : super(key: key);

  final List<Lugar> lugares;
  final List<Tipo> tipos;
  final List<Funcionario> funcionarios;

  @override
  _FormEventoState createState() => _FormEventoState();
}

class _FormEventoState extends State<FormEvento> {
  String lugar = "";
  String tipo = "";
  Evento evento;
  List<Funcionario> convidados = [];

  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();
  final _responsavelController = TextEditingController();

  @override
  void initState() {
    lugar = widget.lugares[0].nome;
    tipo = widget.tipos[0].nome;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.all(10),
      child: Form(
          child: Column(children: <Widget>[
        TextFormField(
            controller: _nomeController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Nome")),
        TextFormField(
            controller: _dataController,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(labelText: "Data")),
        DropdownButton<String>(
            value: lugar,
            icon: const Icon(Icons.location_on),
            onChanged: (String lugarSelecionado) {
              setState(() {
                lugar = lugarSelecionado;
              });
            },
            items: setItensLugares()),
        DropdownButton<String>(
            value: tipo,
            onChanged: (String tipoSelecionado) {
              setState(() {
                tipo = tipoSelecionado;
              });
            },
            items: setItensTipos()),
        TextFormField(
            controller: _responsavelController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Responsavel")),
        Container(
          child: MultiSelectDialogField(
            items: setItensFuncionarios(),
            buttonText: Text("Participantes"),
            cancelText: Text("Fechar"),
            confirmText: Text("Feito"),
            title: Text("Participantes"),
            selectedColor: Colors.orange[500],
            unselectedColor: Colors.orange[100],
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              convidados = values;
            },
            searchable: true,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  addEvento();
                },
                child: Text("Criar evento",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ))
      ])),
    )));
  }

  addEvento() {
    APIServices.adicionarEvento(new Evento(
            0,
            _nomeController.text,
            _dataController.text,
            lugar,
            tipo,
            _responsavelController.text,
            convidados))
        .then((response) {});
  }

  List<DropdownMenuItem<String>> setItensLugares() {
    return widget.lugares
        .map((e) => DropdownMenuItem(value: e.nome, child: Text(e.nome)))
        .toList();
  }

  List<DropdownMenuItem<String>> setItensTipos() {
    return widget.tipos
        .map((e) => DropdownMenuItem(value: e.nome, child: Text(e.nome)))
        .toList();
  }

  List<MultiSelectItem<Funcionario>> setItensFuncionarios() {
    return widget.funcionarios
        .map((e) => MultiSelectItem(e, e.nome + "  " + e.equipe))
        .toList();
  }
}
