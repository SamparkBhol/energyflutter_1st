import 'package:flutter/material.dart';

class EnergyUsageData {
  final DateTime time;
  final double usage;

  EnergyUsageData({
    required this.time,
    required this.usage,
  });

  factory EnergyUsageData.fromMap(Map<String, dynamic> data) {
    return EnergyUsageData(
      time: DateTime.parse(data['time']),
      usage: data['usage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'usage': usage,
    };
  }
}

class EnergyPrediction {
  final DateTime date;
  final double predictedUsage;

  EnergyPrediction({
    required this.date,
    required this.predictedUsage,
  });

  factory EnergyPrediction.fromMap(Map<String, dynamic> data) {
    return EnergyPrediction(
      date: DateTime.parse(data['date']),
      predictedUsage: data['predictedUsage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'predictedUsage': predictedUsage,
    };
  }
}

class EnergyOffer {
  final String sellerName;
  final double amount;
  final double pricePerKWh;

  EnergyOffer({
    required this.sellerName,
    required this.amount,
    required this.pricePerKWh,
  });

  factory EnergyOffer.fromMap(Map<String, dynamic> data) {
    return EnergyOffer(
      sellerName: data['sellerName'],
      amount: data['amount'],
      pricePerKWh: data['pricePerKWh'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerName': sellerName,
      'amount': amount,
      'pricePerKWh': pricePerKWh,
    };
  }
}

class EnergyTransaction {
  final String buyerName;
  final EnergyOffer offer;
  final DateTime transactionDate;

  EnergyTransaction({
    required this.buyerName,
    required this.offer,
    required this.transactionDate,
  });

  factory EnergyTransaction.fromMap(Map<String, dynamic> data) {
    return EnergyTransaction(
      buyerName: data['buyerName'],
      offer: EnergyOffer.fromMap(data['offer']),
      transactionDate: DateTime.parse(data['transactionDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerName': buyerName,
      'offer': offer.toMap(),
      'transactionDate': transactionDate.toIso8601String(),
    };
  }
}
