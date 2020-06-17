import 'dart:math';
import 'package:conquali_flutter/model/equipe.dart';
import 'package:conquali_flutter/dao/equipe_dao.dart';
import 'package:flutter/material.dart';
import 'package:conquali_flutter/pages/equipe_form.dart';

//Lista para ser exibida no botão de ação da lista de registros
enum ListAction { edit, delete }

class EquipeList extends StatefulWidget {
  EquipeList({Key key}) : super(key: key);

  @override
  _EquipeListState createState() => _EquipeListState();
}

class _EquipeListState extends State<EquipeList> {
  EquipeDao equipeDao = new EquipeDao();
  List<Equipe> listaEquipes;
  int qtdeRegistros = 0;

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _getEquipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipes"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //this._salvarEquipe();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EquipeForm()),
          );
        },
      ),
    );
  }

  void _getEquipes() async {
    await equipeDao.findAll().then((funcs) {
      setState(() {
        listaEquipes = funcs;
        qtdeRegistros = funcs.length;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  bool _delete(Equipe equipe) {
    this.equipeDao.delete(equipe.id)
    .then((tmp) {
      return tmp;
        
    })
    .catchError((onError) {
      this._showSnackBar("Erro ao tentar remover registro.");
      return false;
    });
  }

  Key _gerarKey() {
    //Atualizando a lista de movientações
    _getEquipes();

    //GErando nova key para o flutter atualiza o widget (gambiarra)
    return new Key(Random(10000000).toString());
  }

  //Função para criar snackbar
  _showSnackBar(texto) {
    final snackBar = new SnackBar(
      content: Text(texto),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                key: _gerarKey(),
                itemCount: qtdeRegistros,
                itemBuilder: (context, index) {
                  Equipe func = listaEquipes[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(func.nome),
                      trailing: PopupMenuButton<ListAction>(
                        onSelected: (ListAction result) {
                          if ("ListAction.edit" == result.toString()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EquipeForm(
                                        param: func,
                                      )),
                            );
                          } else if ("ListAction.delete" == result.toString()) {
                            BuildContext dialogContext;
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  
                                  //Criando contexto temporário para fechar Dialog
                                  dialogContext = ctx;

                                  return AlertDialog(
                                      title: Text("Deseja excluir registro?"),
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height /7,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            ClipOval(
                                              child: Material(
                                                color: Colors.blue, // button color
                                                child: InkWell(
                                                  splashColor: Colors.white, // inkwell color
                                                  child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: Icon(Icons.save, color: Colors.white,)),
                                                  onTap: () {
                                                    //Fechando Dialog com contexto temporário
                                                    Navigator.pop(dialogContext);

                                                    ////Deletar registro e atualizar lista
                                                    if(_delete(func)) {
                                                      this._getEquipes();
                                                    }
                                                    


                                                  },
                                                ),
                                              ),
                                            ),
                                            ClipOval(
                                              child: Material(
                                                color:
                                                    Colors.blue, // button color
                                                child: InkWell(
                                                  splashColor: Colors.white, // inkwell color
                                                  child: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          Icon(Icons.cancel, color: Colors.white)),
                                                  onTap: () {
                                                    
                                                    //Fechando Dialog com contexto temporário
                                                    Navigator.pop(dialogContext);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                });
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
