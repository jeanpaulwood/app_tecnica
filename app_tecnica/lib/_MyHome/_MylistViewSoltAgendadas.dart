import 'dart:convert';
import 'package:app_tecnica/API/_api_solicitacoesAgendadas.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/*class MyListPage extends StatefulWidget {
  final String nome;
  const MyListPage({Key key, this.nome}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Menu();
  }

  //@override
  //Menu createState() => Menu();
}*/

class MylistViewSoltAgendadas extends /*State<MyListPage>*//*StatefulWidget*/StatelessWidget {

  MylistViewSoltAgendadas({Key key, this.nome, this.usuarcodigo}) : super(key : key);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Variáveis
  String nome;
  int usuarcodigo;
  List<solicitacoesAgendadas> _api;
  String url1 = 'https://jsonplaceholder.typicode.com/users';
  String url2 = 'http://sc9.portalunitrac.com/scriptcase/app/UNITRACGR/apptecnicos_webservice_consulta_pendentes/apptecnicos_webservice_consulta_pendentes.php';

  AlertDialog _showAlertDialog(BuildContext context, String _errorTitle){
    // Configurar btn
    Widget okButton = FlatButton(
      child: Text('OK',style: TextStyle(fontSize: 15.00, color: Colors.black),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // Configurar o AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      title: Text('ERRO:',),
      content: Text(_errorTitle,),
      actions: <Widget>[
        okButton
      ],
    );
    // Exibe o AlertDialog
    showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
    );
    return AlertDialog();
  }

  // Futures
  Future<List<solicitacoesAgendadas>> _getSolicitacoes() async {

    try{
      List<solicitacoesAgendadas> listUser = List();
      final response = await http.post(url2, body: {'usuarcodigo':usuarcodigo.toString()});
      if(response.statusCode == 200){
        try {
          var decodeJson = jsonDecode(response.body);
          decodeJson.forEach((item) => listUser.add(solicitacoesAgendadas.fromJson(item)));
          print(listUser.length);
        } catch (ex){
          print('Não foi possível decodificar o json');
        }
        return listUser;
      }else{
        print('Erro ao carregar lista.');
        return null;
      }
    } catch (ex){
      print('Erro ao carregar lista.');
      return null;
    }
  }

  // Widgets
  Widget refreshIndicator_() {
    return
      RefreshIndicator(
        child: futureBuilder_(),
        onRefresh: () {
          return _getSolicitacoes();
        } ,
      );
  }

  Widget futureBuilder_(){
    return
      FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none || snapshot.hasData == null
              || snapshot.connectionState == ConnectionState.waiting) {
            print('project snapshot data is: ${snapshot.data}');
            return Center(child: CircularProgressIndicator());
          }else{
            return listView_(snapshot);
          }
          //return Container();

        },
        future: _getSolicitacoes(),
      );
  }

  Widget listView_(snapshot){
    if(snapshot.data.length == 0){
      return Scaffold(
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                  child: Text('NÃO RETORNOU DADOS',style: TextStyle(fontSize: 20),),
              ),
            )
          ],
        ),
      );
    }else {
      return
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            //solicitacoesAgendadas _api = snapshot.data[index];
            return card_(snapshot.data[index], index);
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.yellowAccent,);
          },
        );
    }
  }

  Widget card_(solicitacoesAgendadas _api, int index){
    return
      Card(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //height: 50,
                child: ListTile(
                  onTap: () {
                    print('teste '+index.toString());
                  },
                  /*leading:
                                  CircleAvatar(
                                    child: Icon(
                                      Icons.assistant_photo,color: Colors.white,
                                    ),
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                  ),*/
                  title: Text(_api.placa+' - '+_api.tipoServico,style: TextStyle(fontSize: 12),),
                  subtitle: Text(_api.endereco+' '+_api.dataAgendada,style: TextStyle(fontSize: 12),),
                  trailing: Text(_api.empresa/*+' '+_api.soltecodigo.toString()*/,style: TextStyle(fontSize: 12),),
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
      appBar: AppBar(
        title: Text(nome/*widget.nome*/),
      ),
      body: refreshIndicator_()
    );
  }

}