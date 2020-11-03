import 'dart:convert';
import 'package:app_tecnica/API/_api_solicitacoesAgendadas.dart';
import 'package:app_tecnica/_MyApp/MyApp.dart';
import 'package:app_tecnica/_MyHome/_MylistViewSoltConcluidas.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app_tecnica/_MyHome/_formSoltAgendadasDetails.dart';

class MyListPage extends StatefulWidget {
  final String nome;
  final int usuarcodigo;
  const MyListPage({Key key, this.nome, this.usuarcodigo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MylistViewSoltAgendadas();
  }
}

class MylistViewSoltAgendadas extends State<MyListPage> {
  List<solicitacoesAgendadas> _api;
  String url1 = 'https://jsonplaceholder.typicode.com/users';
  String url2 =
      'http://sc9.portalunitrac.com/scriptcase/app/UNITRACGR/apptecnicos_webservice_consulta_pendentes/apptecnicos_webservice_consulta_pendentes.php';

  // Futures
  Future<List<solicitacoesAgendadas>> _getSolicitacoes() async {
    try {
      List<solicitacoesAgendadas> listUser = List();
      final response = await http
          .post(url2, body: {'usuarcodigo': widget.usuarcodigo.toString()});
      if (response.statusCode == 200) {
        try {
          var decodeJson = jsonDecode(response.body);
          decodeJson.forEach(
              (item) => listUser.add(solicitacoesAgendadas.fromJson(item)));
          print(listUser.length);
        } catch (ex) {
          print('Não foi possível decodificar o json');
        }
        return listUser;
      } else {
        print('Erro ao carregar lista.');
        return null;
      }
    } catch (ex) {
      print('Erro ao carregar lista.');
      return null;
    }
  }

  // Widgets
  Widget refreshIndicator_() {
    return RefreshIndicator(
      child: futureBuilder_(),
      onRefresh: () {
        setState(() {});
        return _getSolicitacoes();
      },
    );
  }

  Widget futureBuilder_() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.hasData == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          print('project snapshot data is: ${snapshot.data}');
          return Center(child: CircularProgressIndicator());
        } else {
          return listView_(snapshot);
        }
        //return Container();
      },
      future: _getSolicitacoes(),
    );
  }

  Widget listView_(snapshot) {
    if (snapshot.data.length == 0) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  'NÃO RETORNOU DADOS',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          //solicitacoesAgendadas _api = snapshot.data[index];
          return card_(snapshot.data[index], index);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.yellowAccent,
          );
        },
      );
    }
  }

  Widget card_(solicitacoesAgendadas _api, int index) {
    return Card(
        child: Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 80,
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => formSoltAgendadasDetails(
                            api: _api,
                          )));
              print('teste ' + index.toString());
            },
            /*leading:
                                  CircleAvatar(
                                    child: Icon(
                                      Icons.assistant_photo,color: Colors.white,
                                    ),
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                  ),*/
            title: Text(
              _api.placa + ' - ' + _api.tipoServico + ' - ' + _api.situacao,
              style: TextStyle(fontSize: 12),
            ),
            subtitle: Text(
              _api.endereco + ' ' + _api.dataAgendada,
              style: TextStyle(fontSize: 12),
            ),
            trailing: Text(
              _api.empresa,
              style: TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    )
        //height: 80,
        //color: Colors.black12,
        //child: Text(_api.servicos),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
            child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.nome),
              accountEmail: null,
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyListPage(
                              nome: widget.nome,
                              usuarcodigo: widget.usuarcodigo,
                            )));
              },
            ),
            ListTile(
              title: Text('Movimentar Equipamento'),
              leading: Icon(Icons.move_to_inbox),
              /*onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },*/
            ),
            ListTile(
              title: Text('Solicitações Concluídas'),
              leading: Icon(Icons.done),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyListPageConcluidas(
                              nome: widget.nome,
                              usuarcodigo: widget.usuarcodigo,
                            )));
              },
            ),
            ListTile(
              title: Text('Sair'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        )),
        appBar: AppBar(
          title: Text('SOLICITAÇÕES AGENDADAS'),
        ),
        body: refreshIndicator_());
  }
}
