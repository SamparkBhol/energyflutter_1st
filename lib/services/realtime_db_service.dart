import 'package:firebase_database/firebase_database.dart';
import 'package:community_energy_optimizer/models/energy_model.dart';

class RealtimeDBService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  Stream<List<EnergyUsageData>> energyUsageDataStream(String userId) {
    return _dbRef.child('users/$userId/usage').onValue.map((event) {
      final List<dynamic> data = event.snapshot.value;
      return data.map((item) => EnergyUsageData.fromMap(item)).toList();
    });
  }

  Future<void> saveEnergyUsageData(String userId, EnergyUsageData data) async {
    await _dbRef.child('users/$userId/usage').push().set(data.toMap());
  }

  Stream<EnergyPrediction> energyPredictionStream(String userId) {
    return _dbRef.child('users/$userId/prediction').onValue.map((event) {
      final Map<String, dynamic> data = event.snapshot.value;
      return EnergyPrediction.fromMap(data);
    });
  }

  Stream<List<EnergyOffer>> energyOffersStream() {
    return _dbRef.child('offers').onValue.map((event) {
      final List<dynamic> data = event.snapshot.value;
      return data.map((item) => EnergyOffer.fromMap(item)).toList();
    });
  }

  Future<void> addEnergyOffer(EnergyOffer offer) async {
    await _dbRef.child('offers').push().set(offer.toMap());
  }

  Future<void> updateEnergyOffer(String offerId, EnergyOffer offer) async {
    await _dbRef.child('offers/$offerId').update(offer.toMap());
  }
}
