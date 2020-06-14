import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquali_flutter/pages/funcionario.form.dart';
import 'package:conquali_flutter/service/funcionario.service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:conquali_flutter/model/funcionario.dart';

//Lista para ser exibida no botão de ação da lista de registros
enum ListAction { edit, delete }

class FuncionarioList extends StatefulWidget {
  @override
  _FuncionarioListState createState() => _FuncionarioListState();
}

class _FuncionarioListState extends State<FuncionarioList> {

  //Instancia do serviços do banco
  FuncionarioService funcionarioService = FuncionarioService();

  //Lista de registros recuperados da base
  List<Map> _lista;


  @override
  Widget build(BuildContext context) {
    this._lista = this._getList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Funcionários"),
        ),
        body: buildContent(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FuncionarioForm()),
              );
          },
        ),
      );
  }

  Column buildContent() {
    DateFormat df = DateFormat('dd/MM/YYYY HH:MM');
    return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: this._lista.length,
              itemBuilder: (BuildContext ctx, int index) {
              Map item = this._lista[index];
              DateTime created = DateTime.tryParse(item['created']);

              return ListTile(
                title: Text(item['nome']),
                subtitle: Text(df.format(created)),
                trailing: PopupMenuButton<ListAction>(
                  onSelected: (ListAction result) {

                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<ListAction>> [
                      PopupMenuItem<ListAction>(
                        value: ListAction.edit,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text('Editar')
                          ]),
                      ),
                      PopupMenuItem<ListAction>(
                        value: ListAction.delete,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete),
                            Text('Deletar')
                          ]),
                      ),
                    ];
                  },
                ),
              );

              },
            ),
          ),
        ],
      );
  }

  _getList() async {
    List<Map> lista;
    await funcionarioService.list()   
    .then((value) {
      lista = value;
    }).catchError((onError) {
      print(onError);
    });

    return lista;
  }
}
