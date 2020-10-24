import 'dart:async';
import 'dart:convert';
import 'package:app_tecnica/API/_api_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '_MylistViewSoltAgendadas.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variáveis
  final Connectivity _connectivity = Connectivity();
  final _formKey = GlobalKey<FormState>();
  double width;
  bool _isOnline = true;
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String url1 = 'https://jsonplaceholder.typicode.com/users';
  String url2 =
      'http://sc9.portalunitrac.com/scriptcase/app/UNITRACGR/apptecnicos_webservice_login/apptecnicos_webservice_login.php';

  AlertDialog _showAlertDialog(BuildContext context, String _errorTitle) {
    // Configurar btn
    Widget okButton = FlatButton(
      child: Text(
        'OK',
        style: TextStyle(fontSize: 15.00, color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // Configurar o AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'ERRO:',
      ),
      content: Text(
        _errorTitle,
      ),
      actions: <Widget>[okButton],
    );
    // Exibe o AlertDialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
    return AlertDialog();
  }

  // Futures
  Future<List<api_login>> _getUser(String login, String senha) async {
    try {
      List<api_login> listUser = List();
      final response =
          await http.post(url2, body: {'login': login, 'senha': senha});
      if (response.statusCode == 200) {
        try {
          var decodeJson = jsonDecode(response.body);
          decodeJson.forEach((item) => listUser.add(api_login.fromJson(item)));
        } catch (ex) {
          print(response.body);
          print('Não foi possível decodificar o json. ' + ex.toString());
        }
        return listUser;
      } else {
        print('Erro ao carregar lista 1.');
        return null;
      }
    } catch (ex) {
      print('Erro ao carregar lista 2.' + ex.toString());
      return null;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        _isOnline = true;
        break;
      case ConnectivityResult.mobile:
        _isOnline = true;
        break;
      case ConnectivityResult.none:
        _isOnline = false;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Widgets
  Widget container_() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textFieldLogin_(),
          SizedBox(height: 10),
          textFieldPassaword_(),
          raisedButton_(),
        ],
      ),
    );
  }

  Widget textFieldLogin_() {
    return Container(
      width: 260,
      child: TextFormField(
        controller: _login,
        cursorColor: Colors.yellowAccent,
        style: TextStyle(
            //backgroundColor: Colors.black12,
            color: Colors.yellowAccent),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Login',
            //helperText: 'E-mail do usuário',
            border: new OutlineInputBorder(
              //borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Colors.yellowAccent),
            ),
            icon: Icon(
              Icons.email,
              color: Colors.yellowAccent,
            )),
        validator: (value) {
          if (value.isEmpty) {
            return 'Preencha o login';
          }
          return null;
        },
      ),
    );
  }

  Widget textFieldPassaword_() {
    return Container(
        width: 260,
        child: TextFormField(
          controller: _password,
          cursorColor: Colors.yellowAccent,
          style: TextStyle(
              //backgroundColor: Colors.black12,
              color: Colors.yellowAccent),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Senha',
            //helperText: 'Senha de acesso do usuário',
            border: new OutlineInputBorder(
              //borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Colors.yellowAccent),
            ),
            icon: Icon(Icons.lock, color: Colors.yellowAccent),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Preencha a senha';
            }
            return null;
          },
        ));
  }

  Widget raisedButton_() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          // Process data
          //print(_isOnline);
          if (!_isOnline) {
            _showAlertDialog(context, 'SEM CONEXÃO!');
          } else {
            _getUser(_login.text, _password.text).then((map) {
              if (map.isNotEmpty) {
                if (map[0].status == 'OK') {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyListPage(
                                nome: map[0].usuarnome,
                                usuarcodigo: map[0].usuarcodigo,
                              ))).then((value) {
                    _login.clear();
                    _password.clear();
                  });
                } else {
                  _showAlertDialog(context, 'USUÁRIO OU SENHA INVÁLIDOS!');
                  //print(map[0].query);
                }
              } else {
                _showAlertDialog(context, 'SEM DADOS!');
                print('Map veio vazio.');
                print(map[0].query);
              }
            });
          }
        } else {
          _showAlertDialog(context, 'PREENCHA TODOS OS CAMPOS!');
        }
      },
      child: Text('Entrar'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          width: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              //backgroundBlendMode: BlendMode.modulate,
              //borderRadius: BorderRadius.circular(50.0),
              image: DecorationImage(
                  image: AssetImage('assets/grisweb.jpg'),
                  fit: BoxFit.fitWidth)),
          child: Form(key: _formKey, child: container_())),
    );
  }
}
