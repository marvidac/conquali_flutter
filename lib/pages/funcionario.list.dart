import 'package:conquali_flutter/pages/funcionario.form.dart';
import 'package:conquali_flutter/service/funcionario.service.dart';
import 'package:conquali_flutter/model/funcionario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Lista para ser exibida no botão de ação da lista de registros
enum ListAction { edit, delete }

class FuncionarioList extends StatefulWidget {
  @override
  _FuncionarioListState createState() => _FuncionarioListState();
}

class _FuncionarioListState extends State<FuncionarioList> {

  _FuncionarioListState() {
    //Carregando lista na construção da tela
    this._getList();
  }

  GlobalKey _key;

  //Instancia do serviços do banco
  FuncionarioService funcionarioService = FuncionarioService();

  //Lista de registros recuperados da base
  List<Map> _lista;

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text("Funcionários"),
      ),
      body: buildContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FuncionarioForm()),
          );
        },
      ),
    );
  }

  Column buildContent() {
    DateFormat df = DateFormat('dd/MM/YYYY HH:MM');

    //Se lista não tiver sido carregada
    if (this._lista == null) {
      return Column(children: <Widget>[
        Expanded(
          child: Text("Nenhum dado encontrado."),
        )
      ]);
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            key: this._key,
            shrinkWrap: true,
            itemCount: this._lista.length,
            itemBuilder: (BuildContext ctx, int index) {
              Map<String, dynamic> item = this._lista[index];
              Funcionario funcionarioTmp = Funcionario.fromMap(item);
              DateTime created = null;

              if(funcionarioTmp.created != null)
                created = DateTime.tryParse(funcionarioTmp.created);

              return ListTile(
                title: Text(item['nome']),
                subtitle: Text(created != null ? df.format(created):" "),
                trailing: PopupMenuButton<ListAction>(
                  onSelected: (ListAction result) {
                    if(ListAction.edit==result) { quebrando aqui
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FuncionarioForm(param: item,)),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<ListAction>>[
                      PopupMenuItem<ListAction>(
                        value: ListAction.edit,
                        child: Row(children: <Widget>[
                          Icon(Icons.edit),
                          Text('Editar')
                        ]),
                      ),
                      PopupMenuItem<ListAction>(
                        value: ListAction.delete,
                        child: Row(children: <Widget>[
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
    await funcionarioService.list().then((value) {
      this._geraNovaKey();
      this._lista = value;
    }).catchError((onError) {
      print(onError);
    });

    //return lista;
  }

  _geraNovaKey() {
    setState(() {
      this._key = GlobalKey();
    });
  }
}
