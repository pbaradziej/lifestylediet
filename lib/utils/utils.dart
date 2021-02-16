import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';

class Utils {
  Nutrition kcalAmount(DatabaseProduct product, Nutrition nutrition) {
    Nutriments nutriments = product.nutriments;
    nutrition.kcal += _valueOfNutriment(
        nutriments.caloriesPer100g, nutriments.caloriesPerServing, product);
    nutrition.protein -= _valueOfNutriment(
        nutriments.protein, nutriments.proteinPerServing, product);
    nutrition.carbs -= _valueOfNutriment(
        nutriments.carbs, nutriments.carbsPerServing, product);
    nutrition.fats -=
        _valueOfNutriment(nutriments.fats, nutriments.fatsPerServing, product);

    return nutrition;
  }

  _valueOfNutriment(
      double value, double valuePerServing, DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == -1 || valuePerServing == null) return 0;
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (valuePerServing == -1 || value == null) return 0;
        val = value * product.amount;
        break;
    }
    return val.toInt();
  }

  amountOfNutriments(
      double value, double valuePerServing, DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == -1 || valuePerServing == null) return '?';
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (value == -1 || valuePerServing == null) return '?';
        val = value * product.amount;
        break;
    }
    return val.roundToDouble().toString();
  }

  Nutrition getNutrition(PersonalData personalData) {
    double kcalIntake;
    double weight = double.parse(personalData.weight);
    double height = double.parse(personalData.height);
    double age = (DateTime.now().year - DateTime.parse(personalData.date).year)
        .toDouble();
    switch (personalData.sex) {
      case ('Male'):
        kcalIntake = 10 * weight + 6.25 * height - 5 * age + 5;
        break;
      case ('Female'):
        kcalIntake = 10 * weight + 6.25 * height - 5 * age - 161;
        break;
    }
    kcalIntake *= _getPalParameter(personalData);
    kcalIntake *= _getPhysicalParameter(personalData);
    double protein = (kcalIntake.round() * 0.25) / 4;
    double carbs = (kcalIntake.round() * 0.60) / 4;
    double fats = (kcalIntake.round() * 0.15) / 9;
    return Nutrition(
      kcalIntake.round(),
      0,
      0,
      fats.round(),
      protein.round(),
      carbs.round(),
    );
  }

  double _getPalParameter(PersonalData personalData) {
    switch (personalData.activity) {
      case "Low":
        return 1.5;
      case "Medium":
        return 1.8;
      case "High":
        return 2.2;
      default:
        return 1.8;
    }
  }

  double _getPhysicalParameter(PersonalData personalData) {
    switch (personalData.goal) {
      case "Lose weight":
        return 0.9;
      case "Keep weight":
        return 1.0;
      case "Gain weight":
        return 1.1;
      default:
        return 1.0;
    }
  }

  NutrimentsData getNutrimentsData(List<DatabaseProduct> productList) {
    List<NutrimentsData> nutrimentDataList = _getNutrimentDataList(productList);
    double calories = 0;
    double carbs = 0;
    double fiber = 0;
    double sugars = 0;
    double protein = 0;
    double fats = 0;
    double saturatedFats = 0;
    double cholesterol = 0;
    double sodium = 0;
    double potassium = 0;
    for (NutrimentsData nutrimentsData in nutrimentDataList) {
      calories += nutrimentsData.calories;
      carbs += nutrimentsData.carbs;
      fiber += nutrimentsData.fiber;
      sugars += nutrimentsData.sugars;
      protein += nutrimentsData.protein;
      fats += nutrimentsData.fats;
      saturatedFats += nutrimentsData.saturatedFats;
      cholesterol += nutrimentsData.cholesterol;
      sodium += nutrimentsData.sodium;
      potassium += nutrimentsData.potassium;
    }
    return new NutrimentsData(
      calories / nutrimentDataList.length,
      carbs / nutrimentDataList.length,
      fiber / nutrimentDataList.length,
      sugars / nutrimentDataList.length,
      protein / nutrimentDataList.length,
      fats / nutrimentDataList.length,
      saturatedFats / nutrimentDataList.length,
      cholesterol / nutrimentDataList.length,
      sodium / nutrimentDataList.length,
      potassium / nutrimentDataList.length,
    );
  }

  _getNutrimentDataList(List<DatabaseProduct> productList) {
    List<NutrimentsData> nutrimentDataList = [];
    for (int i = 0; i < 7; i++) {
      double calories = 0;
      double carbs = 0;
      double fiber = 0;
      double sugars = 0;
      double protein = 0;
      double fats = 0;
      double saturatedFats = 0;
      double cholesterol = 0;
      double sodium = 0;
      double potassium = 0;
      for (DatabaseProduct product in productList) {
        DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
        String strDate =
            dateFormat.format(DateTime.now().subtract(Duration(days: i)));
        Nutriments nutriments = product.nutriments;
        if (product.date == strDate) {
          if (product.value == "serving") {
            calories += nutriments.caloriesPerServing * product.amount;
            carbs += nutriments.carbsPerServing * product.amount;
            fiber += nutriments.fiberPerServing * product.amount;
            sugars += nutriments.sugarsPerServing * product.amount;
            protein += nutriments.proteinPerServing * product.amount;
            fats += nutriments.fatsPerServing * product.amount;
            saturatedFats +=
                nutriments.saturatedFatsPerServing * product.amount;
            cholesterol += nutriments.cholesterolPerServing * product.amount;
            sodium += nutriments.sodiumPerServing * product.amount;
            potassium += nutriments.potassiumPerServing * product.amount;
          } else {
            calories += nutriments.caloriesPer100g * product.amount;
            carbs += nutriments.carbs * product.amount;
            fiber += nutriments.fiber * product.amount;
            sugars += nutriments.sugars * product.amount;
            protein += nutriments.protein * product.amount;
            fats += nutriments.fats * product.amount;
            saturatedFats += nutriments.saturatedFats * product.amount;
            cholesterol += nutriments.cholesterol * product.amount;
            sodium += nutriments.sodium * product.amount;
            potassium += nutriments.potassium * product.amount;
          }
        }
      }
      if (calories != 0.0)
        nutrimentDataList.add(new NutrimentsData(
          calories,
          carbs,
          fiber,
          sugars,
          protein,
          fats,
          saturatedFats,
          cholesterol,
          sodium,
          potassium,
        ));
    }

    return nutrimentDataList;
  }
}
