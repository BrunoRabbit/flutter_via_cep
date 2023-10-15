import 'dart:convert';

import 'package:flutter_via_cep/cep_model.dart';
import 'package:http/http.dart' as http;

class CepService {
  static const appId = "<>";
  static const restApiKey = "<>";
  static const clientKey = "<>";
  static const server = 'https://parseapi.back4app.com';

  Future<CepModel> fetchCep(String cep) async {
    http.Client client = http.Client();
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      client.close();
      return CepModel.fromMap(data);
    }

    throw Exception('Falha ao buscar o CEP');
  }

  Future<List<CepModel>> getCeps() async {
    http.Client client = http.Client();
    final url = Uri.parse('https://parseapi.back4app.com/classes/CEP');
    try {
      final response = await client.get(
        url,
        headers: {
          'X-Parse-Application-Id': appId,
          'X-Parse-REST-API-Key': restApiKey,
          'Content-Type': 'application/json',
        },
      );
    print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List<dynamic> results = data['results'];

          final cepList = results
              .where((result) => result['cep'] != null)
              .map((item) => CepModel.fromMap(item))
              .toList();

          return cepList;
        } else {
          throw Exception(
              'Invalid response format: Missing or invalid "results" field');
        }
      } else {
        throw Exception(
            'Erro ao obter a lista de CEPs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao obter a lista de CEPs: $e');
    } finally {
      client.close();
    }
  }

  Future<void> cadastrarCep(Map<String, dynamic> cepData) async {
    http.Client client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('https://parseapi.back4app.com/classes/CEP'),
        body: jsonEncode(cepData),
        headers: {
          'X-Parse-Application-Id': appId,
          'X-Parse-REST-API-Key': restApiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        print('CEP cadastrado com sucesso no Back4App');
        return;
      } else {
        throw Exception(
            'Erro ao cadastrar o CEP no Back4App. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro no cadastro do CEP: $e');
    } finally {
      client.close();
    }
  }

  removeCep(String objectId) async {
    http.Client client = http.Client();
    try {
      final response = await client.delete(
        Uri.parse('https://parseapi.back4app.com/classes/CEP/$objectId'),
        headers: {
          'X-Parse-Application-Id': appId,
          'X-Parse-REST-API-Key': restApiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('CEP removido com sucesso no Back4App');
        return;
      }
    } catch (e) {
      throw Exception('Erro ao remover o CEP: $e');
    } finally {
      client.close();
    }
  }
}
