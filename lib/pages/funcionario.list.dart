import 'dart:math';
import 'package:conquali_flutter/model/funcionario.dart';
import 'package:conquali_flutter/dao/funcionario_dao.dart';
import 'package:flutter/material.dart';
import 'package:conquali_flutter/pages/funcionario.form.dart';

//Lista para ser exibida no botão de ação da lista de registros
enum ListAction { edit, delete }

class FuncionarioList extends StatefulWidget {
  FuncionarioList({Key key}) : super(key: key);

  @override
  _FuncionarioListState createState() => _FuncionarioListState();
}

class _FuncionarioListState extends State<FuncionarioList> {
  FuncionarioDao funcionarioDao = new FuncionarioDao();
  List<Funcionario> listaFuncionarios;
  int qtdeRegistros = 0;

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _getFuncionarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Funcionários"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //this._salvarFuncionario();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FuncionarioForm()),
          );
        },
      ),
    );
  }

  void _getFuncionarios() async {
    await funcionarioDao.findAll().then((funcs) {
      setState(() {
        listaFuncionarios = funcs;
        qtdeRegistros = funcs.length;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  bool _delete(Funcionario funcionario) {
    this.funcionarioDao.delete(funcionario.id)
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
    _getFuncionarios();

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
                  Funcionario func = listaFuncionarios[index];
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
                                  builder: (context) => FuncionarioForm(
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
                                                      this._getFuncionarios();
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
