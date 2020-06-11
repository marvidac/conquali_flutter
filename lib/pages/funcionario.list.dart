import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquali_flutter/pages/funcionario.form.dart';
import 'package:flutter/material.dart';

class FuncionarioList extends StatefulWidget {
  @override
  _FuncionarioListState createState() => _FuncionarioListState();
}

class _FuncionarioListState extends State<FuncionarioList> {
  @override
  Widget build(BuildContext context) {
    //final Funcionario funcionario = new Funcionario(nome: "Funcionário Flutter");
    //insertData(funcionario.toMap());

    return Scaffold(
        appBar: AppBar(
          title: Text("Funcionários"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                        //Buscando os registros da base Firebase
                  stream: Firestore.instance.collection("funcionario").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                    
                    //Verifica se houve erro recuperando lista de funcionários
                    if (querySnapshot.hasError)
                      return Text("Ocorreu um erro ao tentar listar.");

                    //Enquanto carrega exibe loading
                    if (querySnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      //Inicia renderização da lista de Funcionários
                      final list = querySnapshot.data.documents;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(list[index]["nome"]),
                            onTap: () {
                              Navigator.push(
                                context, MaterialPageRoute(builder: (context) => FuncionarioList()),
                              );
                            },
                          );
                        },
                        itemCount: list.length,
                      );
                    }
                  }),
            ),
          ],
        ),
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
}
