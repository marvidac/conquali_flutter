import 'package:flutter/material.dart';
import 'package:conquali_flutter/model/funcao.dart';
import 'package:conquali_flutter/dao/funcao_dao.dart';
import 'package:conquali_flutter/pages/funcao_list.dart';

class FuncaoForm extends StatefulWidget {
  final Funcao param;

  FuncaoForm({Key key, this.param}) : super(key: key);

  @override
  _FuncaoFormState createState() => _FuncaoFormState();
}

////Possíveis valores para seleção de status
enum SingingCharacter { ativo, inativo }

class _FuncaoFormState extends State<FuncaoForm> {
  Funcao get funcao => widget.param;

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Objeto para persistência
  FuncaoDao funcaoDao = new FuncaoDao();

  //Controller do campo de texto
  final _nomeController = TextEditingController();

  //Definindo valor padrão para seleção do status
  SingingCharacter _status = SingingCharacter.ativo;

  void initState() {
    if (this.funcao != null) {
      setState(() {
        _nomeController.text = this.funcao.nome;
        _status= this.funcao.status == true ? SingingCharacter.ativo : SingingCharacter.inativo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastro de Função"),
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
              Funcao funcao = new Funcao(
                id: widget.param == null ? null : widget.param.id,
                nome: this._nomeController.text,
                status: this._status.index == 0 ? true : false,
                created: new DateTime.now().toString(),
              );

              funcaoDao.save(funcao).then((tmp) {
                if (tmp != null) this._showSnackBar("Dados salvos com sucesso.");
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
