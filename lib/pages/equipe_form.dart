import 'package:flutter/material.dart';
import 'package:conquali_flutter/model/equipe.dart';
import 'package:conquali_flutter/model/funcionario.dart';
import 'package:conquali_flutter/model/equipe_funcionario.dart';
import 'package:conquali_flutter/dao/equipe_dao.dart';
import 'package:conquali_flutter/dao/funcionario_dao.dart';
import 'package:conquali_flutter/dao/equipe_funcionario_dao.dart';
import 'package:conquali_flutter/pages/equipe_list.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class EquipeForm extends StatefulWidget {
  final Equipe param;

  EquipeForm({Key key, this.param}) : super(key: key);

  @override
  _EquipeFormState createState() => _EquipeFormState();
}

////Possíveis valores para seleção de status
enum SingingCharacter { ativo, inativo }

class _EquipeFormState extends State<EquipeForm> {
  Equipe get equipe => widget.param;
  EquipeFuncionario equipeFuncionario = EquipeFuncionario();

  List _listaDeFuncionariosArray = [];
  List _funcionariosSelecionados = [];
  List _listaDeEquipeFuncionarios = [];

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  //Objeto para persistência
  EquipeDao equipeDao = EquipeDao();
  FuncionarioDao funcionarioDao = FuncionarioDao();
  EquipeFuncionarioDao equipeFuncionarioDao = EquipeFuncionarioDao();

  //Controller do campo de texto
  final _nomeController = TextEditingController();

  //Definindo valor padrão para seleção do status
  SingingCharacter _status = SingingCharacter.ativo;

  void initState() {
    if (this.equipe != null) {
      setState(() {
        _nomeController.text = this.equipe.nome;
        _status = this.equipe.status == true
            ? SingingCharacter.ativo
            : SingingCharacter.inativo;
      });

      //Buscar todos registros relacionados à equipe
      this.equipeFuncionarioDao.findAllByEquipe(this.equipe.id).then((lista) {
        lista.map((ef) {
          this._listaDeEquipeFuncionarios.add({
            "id": ef.id,
            "equipe": ef.equipe,
            "funcionario": ef.funcionario
          });
        });

        lista.map((ef) {
          this.funcionarioDao.findById(ef.funcionario).then((func) {
            this
                ._listaDeFuncionariosArray
                .add({"id": func.id, "nome": func.nome});
          });
        });
      });
    }

    this._getFuncionarios();
  }

  _getFuncionarios() {
    this.funcionarioDao.findAllByStatus(true).then((retorno) {
      List tmpF = [];

      retorno.forEach((f) {
        tmpF.add({"id": f.id, "nome": f.nome});
      });

//      retorno.map((funcao) => tmp.add(funcao.id.toString()) );

      setState(() {
        this._listaDeFuncionariosArray = tmpF;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastro de Equipe"),
        ),
        body: _body(context),
        bottomNavigationBar: _bottomBar(context),
      ),
    );
  }

  _body(context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: this._nomeController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Nome'),
          ),

          Row(children: <Widget>[
            Expanded(
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16),
                          child: MultiSelectFormField(
                            autovalidate: false,
                            titleText: 'Funcionários',
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Selecione um ou mais';
                              }
                              return null;
                            },
                            dataSource: this._listaDeFuncionariosArray,
                            textField: 'nome',
                            valueField: 'id',
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            // required: true,
                            hintText: 'Selecione um ou mais',
                            initialValue: this._funcionariosSelecionados,
                            onSaved: (value) {
                              if (value == null) return;
                              setState(() {
                                this._funcionariosSelecionados = value;
                              });
                            },
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ]),

          //Container com label status
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 5),
              child: Text("Exibe nas pesquisas?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                  )),
            ),
          ),

          //Linha com seleção de status
          Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: RadioListTile<SingingCharacter>(
                    title: Text("Sim"),
                    value: SingingCharacter.ativo,
                    groupValue: _status,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _status = value;
                      });
                    }),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: RadioListTile<SingingCharacter>(
                    title: Text("Não"),
                    value: SingingCharacter.inativo,
                    groupValue: _status,
                    onChanged: (SingingCharacter value) {
                      setState(() {
                        _status = value;
                      });
                    }),
              ),
            ],
          ),

          //Divider para separar status dos demais itens
          Divider(
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  Container _bottomBar(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Construindo Botão SALVAR com Icon, Texto e animação de click
          InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.save,
                    color: Colors.blue[300],
                    size: 30,
                  ),
                  Text(
                    "Salvar",
                    style: TextStyle(color: Colors.blue[300]),
                  )
                ],
              ),
            ),
            onTap: () {
              //Coleta dados pra salvar no Firebase
              Equipe equipe = new Equipe(
                id: widget.param == null ? null : widget.param.id,
                nome: this._nomeController.text,
                status: this._status.index == 0 ? true : false,
                created: new DateTime.now().toString(),
              );

              bool podeExibirMsg = false;
              Equipe equipeSalva = null;
              equipeDao
                  .save(equipe, this._funcionariosSelecionados)
                  .then((tmp) {
                if (tmp != null) {
                  equipeSalva = Equipe();
                  equipeSalva.id = tmp;
                }
              }).catchError((onError) {
                this._showSnackBar('Erro ao tentar salvar. Informe: $onError');
              });

              if (equipeSalva != null) {
                //Salvando EquipeFuncionario
                this._funcionariosSelecionados.map((obj) {
                  EquipeFuncionario ef = EquipeFuncionario();
                  ef.equipe = equipeSalva.id;
                  ef.funcionario = obj[0];

                  this.equipeFuncionarioDao.save(ef).then((ef) {
                    podeExibirMsg = true;
                  }).catchError((onError) {
                    podeExibirMsg = true;
                    this._showSnackBar('Erro ao tentar salvar. $onError');
                  });
                });

                if (podeExibirMsg)
                  this._showSnackBar("Dados salvos com sucesso.");
              }
            },
          ),
          Container(
            color: Colors.blueGrey[200],
            width: 1,
          ),
          //Construindo Botão LIMPAR com Icon, Texto e animação de click
          InkWell(
            onTap: () {
              //_resetarFormulario();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.clear,
                    color: Colors.blueGrey[300],
                    size: 30,
                  ),
                  Text(
                    "Limpar",
                    style: TextStyle(color: Colors.blueGrey[300]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Função para criar snackbar
  _showSnackBar(texto) {
    final snackBar = new SnackBar(
      content: Text(texto),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
