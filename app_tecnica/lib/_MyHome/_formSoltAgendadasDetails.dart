import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_tecnica/API/_api_solicitacoesAgendadas.dart';

class formSoltAgendadasDetails extends StatefulWidget {
  final solicitacoesAgendadas api;

  const formSoltAgendadasDetails({
    Key key,
    this.api,
  }) : super(key: key);

  @override
  _formSoltAgendadasDetailsState createState() =>
      _formSoltAgendadasDetailsState();
}

class _formSoltAgendadasDetailsState extends State<formSoltAgendadasDetails> {
  final double sizeFont = 13;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalhes da solicitação'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    color: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMPRESA: ' + widget.api.empresa,
                          style: TextStyle(fontSize: sizeFont),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'PLACA: ' + widget.api.placa,
                          style: TextStyle(fontSize: sizeFont),
                        ),
                        Text(
                          'ENDEREÇO: ' + widget.api.endereco,
                          style: TextStyle(fontSize: sizeFont),
                        ),
                        Text(
                          'SITUAÇÃO: ' + widget.api.situacao,
                          style: TextStyle(fontSize: sizeFont),
                        ),
                        Text(
                          'TIPO DE SERVIÇO: ' + widget.api.tipoServico,
                          style: TextStyle(fontSize: sizeFont),
                        ),
                        Text(
                          'DATA AGENDADA: ' + widget.api.dataAgendada,
                          style: TextStyle(fontSize: sizeFont),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('DESCRIÇÃO DA SOLICITAÇÃO'),
              Divider(
                color: Colors.black12,
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(widget.api.descricao),
              ),
            ],
          ),
        ));
  }
}
