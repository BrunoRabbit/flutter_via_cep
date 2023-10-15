import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CepModel {
  CepModel({
    required this.objectId,
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  final String objectId;
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      objectId: map['objectId'] as String,
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      complemento: map['complemento'] as String,
      bairro: map['bairro'] as String,
      localidade: map['localidade'] as String,
      uf: map['uf'] as String,
      ibge: map['ibge'] as String,
      gia: map['gia'] as String,
      ddd: map['ddd'] as String,
      siafi: map['siafi'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CepModel.fromJson(String source) => CepModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
