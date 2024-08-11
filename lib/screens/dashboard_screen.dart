import 'package:flutter/material.dart';
import 'package:community_energy_optimizer/widgets/energy_chart.dart';
import 'package:community_energy_optimizer/widgets/prediction_card.dart';
import 'package:community_energy_optimizer/services/energy_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  EnergyChart(),
                  SizedBox(height: 20),
                  PredictionCard(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/trading');
              },
              child: Text('Trade Energy'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final energyProvider = Provider.of<EnergyProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Hello, ${energyProvider.userName}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Your current energy usage:',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
