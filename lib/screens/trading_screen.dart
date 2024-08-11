import 'package:flutter/material.dart';
import 'package:community_energy_optimizer/services/trading_service.dart';
import 'package:community_energy_optimizer/models/energy_model.dart';

class TradingScreen extends StatefulWidget {
  @override
  _TradingScreenState createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  List<EnergyOffer> _offers = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  void _loadOffers() async {
    List<EnergyOffer> offers = await TradingService().getAvailableOffers();
    setState(() {
      _offers = offers;
    });
  }

  void _tradeEnergy(EnergyOffer offer) async {
    bool success = await TradingService().executeTrade(offer);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trade successful!')),
      );
      _loadOffers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trade failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Energy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Available Energy Offers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _offers.isEmpty
                  ? Center(child: Text('No offers available.'))
                  : ListView.builder(
                      itemCount: _offers.length,
                      itemBuilder: (context, index) {
                        final offer = _offers[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${offer.amount} kWh at \$${offer.pricePerKWh}/kWh'),
                            subtitle: Text('Offered by ${offer.sellerName}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _tradeEnergy(offer);
                              },
                              child: Text('Trade'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnergyOffer {
  final String sellerName;
  final double amount;
  final double pricePerKWh;

  EnergyOffer({required this.sellerName, required this.amount, required this.pricePerKWh});
}

class TradingService {
  Future<List<EnergyOffer>> getAvailableOffers() async {
    // Simulate fetching data from a blockchain or backend service
    await Future.delayed(Duration(seconds: 2));
    return [
      EnergyOffer(sellerName: 'Alice', amount: 50, pricePerKWh: 0.10),
      EnergyOffer(sellerName: 'Bob', amount: 75, pricePerKWh: 0.12),
    ];
  }

  Future<bool> executeTrade(EnergyOffer offer) async {
    // Simulate executing a trade on the blockchain
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
