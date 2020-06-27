import 'package:flutter/material.dart';
import 'package:conquali_flutter/model/funcionario.dart';
import 'package:conquali_flutter/model/funcao.dart';
import 'package:conquali_flutter/dao/funcionario_dao.dart';
import 'package:conquali_flutter/dao/funcao_dao.dart';

class FuncionarioForm extends StatefulWidget {
  final Funcionario param;

  FuncionarioForm({Key key, this.param}) : super(key: key);

  @override
  _FuncionarioFormState createState() => _FuncionarioFormState();
}

////Possíveis valores para seleção de status
enum SingingCharacter { ativo, inativo }

class _FuncionarioFormState extends State<FuncionarioForm> {
  Funcionario get funcionario => widget.param;

  Funcao _funcao = new Funcao();

  String _funcaoSelected = null;
  List<String> _listFuncoes = [];
  List<Funcao> _listaDeFuncoes = [];

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Objeto para persistência
  FuncionarioDao funcionarioDao = new FuncionarioDao();

  FuncaoDao funcaoDao = new FuncaoDao();

  //Controller do campo de texto
  final _nomeController = TextEditingController();

  //Definindo valor padrão para seleção do status
  SingingCharacter _status = SingingCharacter.ativo;

  void initState() {
    if (this.funcionario != null) {
      this._getFuncaoById(this.funcionario.funcao);

      if (this._funcao != null) {
        this._funcaoSelected = this._funcao.nome;
      }

      setState(() {
        _nomeController.text = this.funcionario.nome;
        _status = this.funcionario.status == true
            ? SingingCharacter.ativo
            : SingingCharacter.inativo;
        //_funcaoSelected = this.funcionario.funcao.nome;
      });
    }

    this._getFuncoes();
  }

  _getFuncaoById(int idFuncao) {
    //Setando valor da função
    this.funcaoDao.findById(idFuncao).then((retorno) {
      setState(() {
        this._funcao = retorno;
      });
    });
  }

  _getFuncoes() {
    this.funcaoDao.findAllByStatus(true).then((retorno) {
      List<String> tmp = [];
      List<Funcao> tmpF = [];

      retorno.forEach((f) {
        //Setando o valor inicial do select para prevenir erro na abertura da tela
        if (tmp.length == 0 && this._funcaoSelected == null) {
          //Seta Funcao da classe
          this._getFuncaoById(f.id);
          //Seta nome da funcao da classe
          setState(() {
            this._funcaoSelected = f.nome;
          });
        }

        tmp.add(f.nome);
        tmpF.add(f);
      });

//      retorno.map((funcao) => tmp.add(funcao.id.toString()) );

      setState(() {
        this._listFuncoes = tmp;
        this._listaDeFuncoes = tmpF;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  _getFuncaoPorNome() {
    this.funcaoDao.findByNome(this._funcaoSelected).then((retorno) {
      this._funcao = retorno;
    }).catchError((erro) {
      print(erro);
      this._showSnackBar("Erro ao tentar buscar Função por nome.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastro de Funcionário"),
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

          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: Text("Função"),
              ),
              _dropdownButton(),
            ],
          ),
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

  DropdownButton<String> _dropdownButton() {
    return DropdownButton<String>(
      value: this._funcaoSelected,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          this._funcaoSelected = newValue;
        });

        //Seta this._funcao para o valor selecionado na lista
        this._getFuncaoPorNome();
      },
      items: this._listFuncoes.map<DropdownMenuItem<String>>((String value) {
        //Buscando Função pelo nome
        this._listaDeFuncoes.map((item) {
          if (item.nome == this._funcaoSelected) {
            setState(() {
              this._funcao = item;
            });
          }
        });

        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
              //Coleta dados pra salvar no Firebase;~~[8]
              Funcionario funcionario = new Funcionario(
                id: widget.param == null ? null : widget.param.id,
                nome: this._nomeController.text,
                funcao: this._funcao.id,
                status: this._status.index == 0 ? true : false,
                created: new DateTime.now().toString(),
              );

              funcionarioDao.save(funcionario).then((tmp) {
                if (tmp != null)
                  this._showSnackBar("Dados salvos com sucesso.");
              }).catchError((onError) {
                this._showSnackBar('Erro ao tentar salvar. Informe: $onError');
              });
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
