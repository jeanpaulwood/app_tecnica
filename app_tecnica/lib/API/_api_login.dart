class api_login {
  int usuarcodigo;
  String usuarnome;
  int usuarsituacao;
  String status;
  String query;

  api_login({this.usuarcodigo, this.usuarnome, this.usuarsituacao, this.status, this.query});

  api_login.fromJson(Map<String, dynamic> json) {
    usuarcodigo = json['usuarcodigo'];
    usuarnome = json['usuarnome'];
    usuarsituacao = json['usuarsituacao'];
    status = json['status'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuarcodigo'] = this.usuarcodigo;
    data['usuarnome'] = this.usuarnome;
    data['usuarsituacao'] = this.usuarsituacao;
    data['status'] = this.status;
    data['query'] = this.query;
    return data;
  }
}