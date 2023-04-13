import 'package:intl/intl.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/models/nutriments_data.dart';

class NutrimentsDataHelper {
  static NutrimentsData getNutrimentsDataList(List<DatabaseProduct> productList) {
    final List<NutrimentsData> nutrimentDataList = _getNutrimentDataList(productList);
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
    for (final NutrimentsData nutrimentsData in nutrimentDataList) {
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

    return NutrimentsData(
      calories: calories / nutrimentDataList.length,
      carbs: carbs / nutrimentDataList.length,
      fiber: fiber / nutrimentDataList.length,
      sugars: sugars / nutrimentDataList.length,
      protein: protein / nutrimentDataList.length,
      fats: fats / nutrimentDataList.length,
      saturatedFats: saturatedFats / nutrimentDataList.length,
      cholesterol: cholesterol / nutrimentDataList.length,
      sodium: sodium / nutrimentDataList.length,
      potassium: potassium / nutrimentDataList.length,
    );
  }

  static List<NutrimentsData> _getNutrimentDataList(List<DatabaseProduct> productList) {
    final List<NutrimentsData> nutrimentDataList = <NutrimentsData>[];
    for (int days = 0; days < 7; days++) {
      final NutrimentsData nutrimentsData = getNutrimentsData(productList, days);
      if (nutrimentsData.calories != 0) nutrimentDataList.add(nutrimentsData);
    }

    return nutrimentDataList;
  }

  static NutrimentsData getNutrimentsData(
    List<DatabaseProduct> productList,
    int days,
  ) {
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
    for (final DatabaseProduct product in productList) {
      final String subtractedDate = _getSubtractedDate(days);
      final Nutriments nutriments = product.nutriments;
      if (product.date == subtractedDate) {
        if (product.value == 'serving') {
          calories += nutriments.caloriesPerServing * product.amount;
          carbs += nutriments.carbsPerServing * product.amount;
          fiber += nutriments.fiberPerServing * product.amount;
          sugars += nutriments.sugarsPerServing * product.amount;
          protein += nutriments.proteinPerServing * product.amount;
          fats += nutriments.fatsPerServing * product.amount;
          saturatedFats += nutriments.saturatedFatsPerServing * product.amount;
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

    return NutrimentsData(
      calories: calories,
      carbs: carbs,
      fiber: fiber,
      sugars: sugars,
      protein: protein,
      fats: fats,
      saturatedFats: saturatedFats,
      cholesterol: cholesterol,
      sodium: sodium,
      potassium: potassium,
    );
  }

  static String _getSubtractedDate(int days) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime todayDate = DateTime.now();
    final Duration duration = Duration(days: days);
    final DateTime subtractedDate = todayDate.subtract(duration);

    return dateFormat.format(subtractedDate);
  }
}
