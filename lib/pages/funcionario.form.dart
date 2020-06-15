import 'package:flutter/material.dart';
import 'package:conquali_flutter/model/funcionario.dart';
import 'package:conquali_flutter/service/funcionario.service.dart';


class FuncionarioForm extends StatefulWidget {
  
  //Será passado como parâmetro para o statfull
  Map param;

  FuncionarioForm({this.param}) {
  }

  @override
  _FuncionarioFormState createState() => _FuncionarioFormState(param: this.param);
}

////Possíveis valores para seleção de status
enum SingingCharacter { ativo, inativo }

class _FuncionarioFormState extends State<FuncionarioForm> {
  Map param;
  
  FuncionarioService funcionarioService;
  //Construtor para receber parâmetro da lista
  _FuncionarioFormState({this.param}) {
      this.funcionarioService = FuncionarioService();
      this.param = param;

      //Setando campos na construção da classe apartir do parâmetro enviado
      if(this.param != null) {
        this._nomeController.text = this.param['nome'];
        this._status = this.param['nome'] == 1 ? SingingCharacter.ativo : SingingCharacter.inativo;
      }
  }

  //Key criada para exibir SnackBar quando necessário
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Estados para controle de tela
  bool _loading = false;

  //Definindo valor padrão para seleção do status
  SingingCharacter _status = SingingCharacter.ativo;

  //Definindo controller para textinput
  final _nomeController = TextEditingController();

  //Função para criar snackbar
  _showSnackBar(texto) {
    final snackBar = new SnackBar(
      content: Text(texto),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  //Reset de valores da tela
  _resetarFormulario() {
    _nomeController.clear();
    _status = SingingCharacter.ativo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro de Funcionário"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              //TextField para usuário escrever nome do funcionário
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
          )),

      //Barra de baixo com botões
      bottomNavigationBar: Container(
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
                Funcionario funcionario = new Funcionario(
                    nome: this._nomeController.text,
                    status: this._status.index == 0 ? true : false,
                    created: new DateTime.now().toString(),
                );

                int documentId;
                this.funcionarioService.insert(funcionario.toMap())
                .then((retorno) {
                  documentId = retorno;
                  this._showSnackBar("Dados salvos com sucesso.");
                }).catchError((onError) {
                  this._showSnackBar(onError);
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
                _resetarFormulario();
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
      ),
    );
  }
}
