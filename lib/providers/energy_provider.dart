import 'package:flutter/material.dart';
import 'package:community_energy_optimizer/models/energy_model.dart';
import 'package:community_energy_optimizer/services/api_service.dart';
import 'package:community_energy_optimizer/services/realtime_db_service.dart';

class EnergyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final RealtimeDBService _dbService = RealtimeDBService();

  List<EnergyUsageData> _usageData = [];
  EnergyPrediction? _prediction;
  List<EnergyOffer> _offers = [];

  List<EnergyUsageData> get usageData => _usageData;
  EnergyPrediction? get prediction => _prediction;
  List<EnergyOffer> get offers => _offers;

  Future<void> fetchUsageData(String userId) async {
    _usageData = await _apiService.fetchEnergyUsageData(userId);
    notifyListeners();
  }

  Future<void> fetchPrediction(String userId) async {
    _prediction = await _apiService.fetchEnergyPrediction(userId);
    notifyListeners();
  }

  Future<void> fetchOffers() async {
    _offers = await _apiService.fetchAvailableEnergyOffers();
    notifyListeners();
  }

  Stream<List<EnergyUsageData>> usageDataStream(String userId) {
    return _dbService.energyUsageDataStream(userId);
  }

  Stream<EnergyPrediction> predictionStream(String userId) {
    return _dbService.energyPredictionStream(userId);
  }

  Stream<List<EnergyOffer>> offersStream() {
    return _dbService.energyOffersStream();
  }

  Future<void> addOffer(EnergyOffer offer) async {
    await _dbService.addEnergyOffer(offer);
    await fetchOffers();
  }

  Future<void> updateOffer(String offerId, EnergyOffer offer) async {
    await _dbService.updateEnergyOffer(offerId, offer);
    await fetchOffers();
  }

  EnergyProvider() {
    fetchOffers();
  }
}
