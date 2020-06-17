import 'package:flutter/material.dart';
import 'package:conquali_flutter/pages/funcionario_list.dart';
import 'package:conquali_flutter/pages/equipe_list.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("NOME DO USUÁRIO"),
            accountEmail: Text("nome.do.usuario@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
                child: Text("A",
                style: TextStyle(fontSize: 40.0),),
            ),
          ),
          ListTile(
            title: Text("Funcionário"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => FuncionarioList()),
              );
            }
          ),
          ListTile(
            title: Text("Equipe"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => EquipeList()),
              );
            }
          ),
          
        ],
      )
    );
  }
}