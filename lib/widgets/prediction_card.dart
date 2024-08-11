import 'package:flutter/material.dart';
import 'package:community_energy_optimizer/models/energy_model.dart';
import 'package:community_energy_optimizer/services/ml_service.dart';

class PredictionCard extends StatefulWidget {
  @override
  _PredictionCardState createState() => _PredictionCardState();
}

class _PredictionCardState extends State<PredictionCard> {
  double _predictedUsage = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getPrediction();
  }

  void _getPrediction() async {
    double prediction = await MLService().getEnergyPrediction();
    setState(() {
      _predictedUsage = prediction;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tomorrow\'s Predicted Usage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Estimated energy usage: $_predictedUsage kWh',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to detailed prediction screen
                    },
                    child: Text('View Details'),
                  ),
                ],
              ),
      ),
    );
  }
}

class DetailedPredictionView extends StatelessWidget {
  final List<EnergyUsageData> detailedData;

  DetailedPredictionView({required this.detailedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detailed Prediction')),
      body: ListView.builder(
        itemCount: detailedData.length,
        itemBuilder: (context, index) {
          final data = detailedData[index];
          return ListTile(
            title: Text(
                '${data.time.hour}:00 - ${data.time.hour + 1}:00: ${data.usage} kWh'),
          );
        },
      ),
    );
  }
}

class MLService {
  Future<double> getEnergyPrediction() async {
    // Simulate an ML model prediction by returning a random value
    await Future.delayed(Duration(seconds: 2));
    return 12.5; // Replace with actual ML model inference
  }
}
