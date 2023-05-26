import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/models/nutrition.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/utils/i18n.dart';

class NutrimentsHelper {
  Nutrition kcalAmount(final DatabaseProduct product, final Nutrition nutrition) {
    final Nutriments nutriments = product.nutriments;
    nutrition.kcal += _valueOfNutriment(nutriments.caloriesPer100g, nutriments.caloriesPerServing, product);
    nutrition.protein -= _valueOfNutriment(nutriments.protein, nutriments.proteinPerServing, product);
    nutrition.carbs -= _valueOfNutriment(nutriments.carbs, nutriments.carbsPerServing, product);
    nutrition.fats -= _valueOfNutriment(nutriments.fats, nutriments.fatsPerServing, product);

    return nutrition;
  }

  String amountOfNutriments(final double value, final double valuePerServing, final DatabaseProduct product) {
    if (valuePerServing == -1) {
      return '?';
    }

    final double valueOfNutriment = _getValueOfNutriment(valuePerServing, product, value);
    final double roundedDouble = valueOfNutriment.roundToDouble();

    return roundedDouble.toString();
  }

  Nutrition getNutrition(final PersonalData personalData) {
    final double kcalIntake = _getKcalIntake(personalData);
    final int roundedKcalIntake = kcalIntake.round();
    final double protein = (roundedKcalIntake * 0.25) / 4;
    final double carbs = (roundedKcalIntake * 0.60) / 4;
    final double fats = (roundedKcalIntake * 0.15) / 9;

    return Nutrition(
      kcalLeft: roundedKcalIntake,
      fats: fats.round(),
      protein: protein.round(),
      carbs: carbs.round(),
    );
  }

  int _valueOfNutriment(final double value, final double valuePerServing, final DatabaseProduct product) {
    if (valuePerServing == -1) {
      return 0;
    }

    final double valueOfNutriment = _getValueOfNutriment(valuePerServing, product, value);
    return valueOfNutriment.toInt();
  }

  double _getValueOfNutriment(final double valuePerServing, final DatabaseProduct product, final double value) {
    final String productAmount = product.value;
    if (productAmount == 'serving') {
      return valuePerServing * product.amount;
    }

    return value * product.amount;
  }

  double _getKcalIntake(final PersonalData personalData) {
    final double kcalIntake = _getSexKcalIntake(personalData);
    final double palParameter = _getPalParameter(personalData);
    final double physicalParameter = _getPhysicalParameter(personalData);

    return kcalIntake * palParameter * physicalParameter;
  }

  double _getSexKcalIntake(final PersonalData personalData) {
    final double weight = double.parse(personalData.weight);
    final double height = double.parse(personalData.height);
    final double age = _getUserAge(personalData);
    if (personalData.sex == 'Male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    }

    return 10 * weight + 6.25 * height - 5 * age - 161;
  }

  double _getUserAge(final PersonalData personalData) {
    final int currentYear = _currentYear();
    final int userYearOfBirth = _userYearOfBirth(personalData);
    final int userAge = currentYear - userYearOfBirth;

    return userAge.toDouble();
  }

  int _currentYear() {
    final DateTime dateTime = DateTime.now();
    return dateTime.year;
  }

  int _userYearOfBirth(final PersonalData personalData) {
    final String date = personalData.date;
    final DateTime parsedDate = DateTime.parse(date);

    return parsedDate.year;
  }

  double _getPalParameter(final PersonalData personalData) {
    switch (personalData.activity) {
      case I18n.activityLow:
        return 1.5;
      case I18n.activityNormal:
        return 1.8;
      case I18n.activityHigh:
        return 2.2;
      default:
        return 1.8;
    }
  }

  double _getPhysicalParameter(final PersonalData personalData) {
    switch (personalData.goal) {
      case I18n.loseWeight:
        return 0.9;
      case I18n.keepWeight:
        return 1.0;
      case I18n.gainWeight:
        return 1.1;
      default:
        return 1.0;
    }
  }
}
