class solicitacoesAgendadas {
  String dataAgendada;
  String placa;
  String tipoServico;
  String empresa;
  String endereco;
  String situacao;
  int soltecodigo;
  String descricao;

  solicitacoesAgendadas(
      {this.dataAgendada,
      this.placa,
      this.tipoServico,
      this.empresa,
      this.endereco,
      this.situacao,
      this.soltecodigo,
      this.descricao});

  solicitacoesAgendadas.fromJson(Map<String, dynamic> json) {
    dataAgendada = json['data_agendada'];
    placa = json['placa'];
    tipoServico = json['tipo_servico'];
    empresa = json['empresa'];
    endereco = json['endereco'];
    situacao = json['situacao'];
    soltecodigo = json['soltecodigo'];
    descricao = json['soltedescricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_agendada'] = this.dataAgendada;
    data['placa'] = this.placa;
    data['tipo_servico'] = this.tipoServico;
    data['empresa'] = this.empresa;
    data['endereco'] = this.endereco;
    data['situacao'] = this.situacao;
    data['soltecodigo'] = this.soltecodigo;
    data['soltedescricao'] = this.descricao;
    return data;
  }
}
