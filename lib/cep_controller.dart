import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_via_cep/cep_model.dart';
import 'package:flutter_via_cep/cep_service.dart';

class CepController with ChangeNotifier {
  List<CepModel> listModel = [];
  CepService service = CepService();
  String randomMessage = "Carregando...";
  bool isLoading = false;

  final _random = Random();
  final _loadingMessages = [
    'Carregando...',
    'Aguarde um momento...',
    'Preparando...',
    'Carregando dados...',
    'Carregando conteúdo...',
  ];

  Future<void> handleCep(String cep) async {
    final cepModel = await service.fetchCep(cep);
    print(cepModel);

    await service.cadastrarCep(cepModel.toMap());
    listModel.add(cepModel);

    notifyListeners();
  }

  Future<void> getCeps() async {
    isLoading = true;
    listModel = await service.getCeps();
    isLoading = false;
    notifyListeners();
  }

  loadMessage() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      final randomIndex = _random.nextInt(_loadingMessages.length);

      randomMessage = _loadingMessages[randomIndex];
      notifyListeners();
    });
  }

  removeCep(String objectId, int index) async {
    await service.removeCep(objectId);
    listModel.removeAt(index);
    notifyListeners();
  }
}
