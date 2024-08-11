import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:community_energy_optimizer/models/energy_model.dart';

class ApiService {
  final String _baseUrl = 'https://api.community-energy-optimizer.com';

  Future<List<EnergyUsageData>> fetchEnergyUsageData(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId/usage'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => EnergyUsageData.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load energy usage data');
    }
  }

  Future<EnergyPrediction> fetchEnergyPrediction(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId/prediction'));

    if (response.statusCode == 200) {
      return EnergyPrediction.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load energy prediction');
    }
  }

  Future<List<EnergyOffer>> fetchAvailableEnergyOffers() async {
    final response = await http.get(Uri.parse('$_baseUrl/offers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => EnergyOffer.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load energy offers');
    }
  }

  Future<bool> executeEnergyTransaction(EnergyTransaction transaction) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transaction.toMap()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
