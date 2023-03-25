import 'package:intl/intl.dart';
import 'package:lifestylediet/models/nutriments.dart';

class DatabaseProduct {
  final String id;
  final String date;
  final String meal;
  final String image;
  final String name;
  final Nutriments nutriments;
  final double amount;
  final String value;
  final String servingUnit;
  final bool isExpanded;

  DatabaseProduct({
    required this.amount,
    required this.image,
    required this.name,
    required this.value,
    required this.nutriments,
    this.id = '',
    this.date = '',
    this.meal = '',
    this.servingUnit = '',
    this.isExpanded = true,
  });

  DatabaseProduct copyWith({
    String? id,
    String? date,
    String? meal,
    String? image,
    String? name,
    Nutriments? nutriments,
    double? amount,
    String? value,
    String? servingUnit,
    bool? isExpanded,
  }) {
    return DatabaseProduct(
      id: id ?? this.id,
      date: date ?? this.date,
      meal: meal ?? this.meal,
      image: image ?? this.image,
      name: name ?? this.name,
      nutriments: nutriments ?? this.nutriments,
      amount: amount ?? this.amount,
      value: value ?? this.value,
      servingUnit: servingUnit ?? this.servingUnit,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  factory DatabaseProduct.fromJson(Map<String, Object?> json) {
    return DatabaseProduct(
      id: json['id'] as String,
      date: _getDate(json),
      meal: json['meal'] as String,
      amount: json['amount'] as double,
      image: json['image'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
      servingUnit: json['servingUnit'] as String,
      nutriments: Nutriments.fromJson(json['nutriments'] as Map<String, Object?>? ?? <String, Object>{}),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'date': date,
      'meal': meal,
      'name': name,
      'image': image,
      'amount': amount,
      'value': value,
      'servingUnit': servingUnit,
      'nutriments': <String, Object?>{
        'caloriesPer100g': nutriments.caloriesPer100g,
        'caloriesPerServing': nutriments.caloriesPerServing,
        'carbs': nutriments.carbs,
        'carbsPerServing': nutriments.carbsPerServing,
        'fiber': nutriments.fiber,
        'fiberPerServing': nutriments.fiberPerServing,
        'sugars': nutriments.sugars,
        'sugarsPerServing': nutriments.sugarsPerServing,
        'protein': nutriments.protein,
        'proteinPerServing': nutriments.proteinPerServing,
        'fats': nutriments.fats,
        'fatsPerServing': nutriments.fatsPerServing,
        'saturatedFats': nutriments.saturatedFats,
        'saturatedFatsPerServing': nutriments.saturatedFatsPerServing,
        'cholesterol': nutriments.cholesterol,
        'cholesterolPerServing': nutriments.cholesterolPerServing,
        'sodium': nutriments.sodium,
        'sodiumPerServing': nutriments.sodiumPerServing,
        'potassium': nutriments.potassium,
        'potassiumPerServing': nutriments.potassiumPerServing,
      }
    };
  }

 static String _getDate(Map<String, Object?> json) {
    final String date = json['date'] as String;
    if (date == 'currentDate') {
      return _getDateNow();
    }

    return date;
  }

  static String _getDateNow() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime dateNow = DateTime.now();

    return dateFormat.format(dateNow);
  }
}
