import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/cubits/meal/meal_cubit.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/meal.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/models/nutrition.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/screens/detail/details_screen_provider.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/nutriments/nutriments_helper.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/theme.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  late RoutingCubit routingCubit;
  late ProductCubit productCubit;
  late MealCubit mealCubit;
  late String currentDate;
  late NutrimentsHelper nutrimentsHelper;
  late Nutrition nutrition;
  late bool dailyWeightUpdated;
  late List<Meal> meals;

  @override
  void initState() {
    super.initState();
    routingCubit = context.read();
    productCubit = context.read();
    mealCubit = MealCubit();
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    currentDate = dateFormat.format(DateTime.now());
    nutrimentsHelper = NutrimentsHelper();
    meals = <Meal>[];
    dailyWeightUpdated = true;
    productCubit.initializeProducts();
    mealCubit.initializeMealsData();
    nutrition = Nutrition();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: listeners(),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          children: <Widget>[
            calories(),
            addWeightPopUp(),
            dateCard(),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                child: mealPanelListIfNotEmpty(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BlocListener<BlocBase<Object>, Object>> listeners() {
    return <BlocListener<BlocBase<Object>, Object>>[
      BlocListener<ProductCubit, ProductState>(
        bloc: context.read(),
        listener: productListener,
      ),
      BlocListener<MealCubit, MealState>(
        bloc: mealCubit,
        listener: mealListener,
      ),
    ];
  }

  void productListener(BuildContext context, ProductState state) {
    final ProductStatus status = state.status;
    if (status == ProductStatus.loaded) {
      meals = state.meals;
      setState(() {});
    }
  }

  void mealListener(BuildContext context, MealState state) {
    final MealStatus status = state.status;
    if (status == MealStatus.loaded) {
      updateMealData(state);
      setState(() {});
    }
  }

  void updateMealData(MealState state) {
    dailyWeightUpdated = state.dailyWeightUpdated;
    final PersonalData personalData = state.personalData;
    nutrition = nutrimentsHelper.getNutrition(personalData);
    getNutritionWithCurrentDate();
  }

  Widget addWeightPopUp() {
    return !dailyWeightUpdated ? weightPopUp() : const SizedBox();
  }

  Widget weightPopUp() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.lightBlueAccent[200],
      child: GestureDetector(
        onTap: () {
          DefaultTabController.of(context).animateTo(2);
        },
        child: ListTile(
          trailing: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey[600],
            onPressed: () {
              mealCubit.updateDailyWeight();
              setState(() {});
            },
          ),
          title: Text(
            'Add your daily weight',
            textAlign: TextAlign.center,
            style: AppTextStyle.titleLarge(context)?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget dateCard() {
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
    final String strLastDate = _dateFormat.format(DateTime.now().subtract(const Duration(days: 7)));
    final String strDate = _dateFormat.format(DateTime.now());
    return Card(
      color: defaultColor,
      child: ListTile(
        leading: dataIconButton(strLastDate, 'sub', Icons.arrow_back),
        trailing: dataIconButton(strDate, 'add', Icons.arrow_forward),
        title: Text(
          currentDate,
          style: titleDateStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void getNutritionWithCurrentDate() {
    for (final Meal meal in meals) {
      for (final DatabaseProduct product in meal.meals) {
        if (currentDate == product.date) {
          nutrition = nutrimentsHelper.kcalAmount(product, nutrition);
        }
      }
    }
  }

  Widget dataIconButton(String strDate, String action, IconData icon) {
    final bool isCurrentDate = currentDate == strDate;
    return IconButton(
      splashColor: isCurrentDate ? defaultColor : const Color(0x66C8C8C8),
      highlightColor: isCurrentDate ? defaultColor : const Color(0x66C8C8C8),
      color: isCurrentDate ? Colors.grey[300] : Colors.grey[500],
      icon: Icon(icon),
      onPressed: () {
        swipeData(strDate, action);
      },
    );
  }

  void swipeData(String strDate, String action) {
    if (currentDate != strDate) {
      setState(() {
        DateTime newDate;
        if (action == 'sub') {
          newDate = DateTime.parse(currentDate).subtract(
            const Duration(days: 1),
          );
        } else {
          newDate = DateTime.parse(currentDate).add(
            const Duration(days: 1),
          );
        }

        final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
        currentDate = _dateFormat.format(newDate);
      });
    }
  }

  Widget mealPanelListIfNotEmpty() {
    if(meals.isNotEmpty) {
      return mealPanelList();
    }

    return loadingScreen();
  }

  Widget mealPanelList() {
    return ExpansionPanelList(
      key: UniqueKey(),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          meals[index] = meals[index].copyWith(isExpanded: !isExpanded);
        });
      },
      children: mealPanels(),
    );
  }

  List<ExpansionPanel> mealPanels() {
    return <ExpansionPanel>[
      for (Meal meal in meals) mealPanel(meal),
    ];
  }

  ExpansionPanel mealPanel(Meal meal) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(
                meal.name.toUpperCase(),
                softWrap: true,
              ),
            ),
          ],
        );
      },
      isExpanded: meal.isExpanded,
      body: mealPanelBody(meal),
    );
  }

  Widget mealPanelBody(Meal meal) {
    return Column(
      children: <Widget>[
        listBuilder(meal.meals),
        addMeal(meal.name),
      ],
    );
  }

  Widget addMeal(String meal) {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'ADD ${meal.toUpperCase()} ',
              style: defaultTextStyle,
            ),
          ),
          const Icon(Icons.add),
        ],
      ),
      onPressed: () {
        routingCubit.showAdderScreen(meal, currentDate);
      },
    );
  }

  Widget listBuilder(List<DatabaseProduct> mealList) {
    final List<DatabaseProduct> currentMealList = getProductsWithCurrentDate(mealList);
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: currentMealList.length,
      itemBuilder: (BuildContext context, int index) {
        return showFood(currentMealList, index);
      },
    );
  }

  List<DatabaseProduct> getProductsWithCurrentDate(List<DatabaseProduct> mealList) {
    final List<DatabaseProduct> currentMealList = <DatabaseProduct>[];
    for (final DatabaseProduct product in mealList) {
      if (currentDate == product.date) {
        currentMealList.add(product);
      }
    }

    return currentMealList;
  }

  Widget calories() {
    return Container(
      width: 350,
      height: 220,
      alignment: Alignment.topCenter,
      decoration: menuTheme(),
      child: Column(
        children: <Widget>[
          kcalRow(),
          const SizedBox(height: 14),
          nutritionRow(),
        ],
      ),
    );
  }

  Widget kcalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const SizedBox(width: 0),
        kcalPanel('kcal', 'left', subTitleStyle, (nutrition.kcalLeft - nutrition.kcal).toString()),
        const SizedBox(width: 20),
        kcalPanel('kcal', 'eaten', titleHomeStyle, nutrition.kcal.toString()),
        const SizedBox(width: 20),
        kcalPanel('kcal', 'burned', subTitleStyle, '0'),
      ],
    );
  }

  Widget kcalPanel(String name, String action, TextStyle style, String value) {
    return Column(
      children: <Widget>[
        Text(name, style: subTitleStyle),
        Text(action, style: subTitleStyle),
        Text(value, style: style),
      ],
    );
  }

  Widget nutritionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        nutritionText(
          'protein\nleft',
          nutrition.protein.toString(),
        ),
        nutritionText(
          'carbs\nleft',
          nutrition.carbs.toString(),
        ),
        nutritionText(
          'fats\nleft',
          nutrition.fats.toString(),
        ),
      ],
    );
  }

  Widget nutritionText(String name, String value) {
    return Column(
      children: <Widget>[
        Text(
          name,
          style: AppTextStyle.titleLarge(context)?.copyWith(
            color: Colors.white,
          ),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyle.titleLarge(context)?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget showFood(List<DatabaseProduct> mealList, int index) {
    final DatabaseProduct product = mealList[index];
    final Nutriments nutriments = product.nutriments;

    return ListTile(
      subtitle: subtitleListTile(product, nutriments),
      title: Text(product.name),
      trailing: deleteButton(product),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext _) => detailsScreen(product),
        ),
      ).then(
        (Widget? value) {
          setState(() {});
        },
      ),
    );
  }

  Widget detailsScreen(DatabaseProduct product) {
    return DetailsScreenProvider(
      product: product,
      context: context,
    );
  }

  Widget deleteButton(DatabaseProduct product) {
    return IconButton(
      onPressed: () {
        productCubit.deleteProduct(product);
        setState(() {});
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.black54,
      ),
    );
  }

  Widget subtitleListTile(DatabaseProduct product, Nutriments nutriments) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: 'kcal: ${nutrimentsHelper.amountOfNutriments(
              nutriments.caloriesPer100g,
              nutriments.caloriesPerServing,
              product,
            )}',
          ),
          TextSpan(
            text: ' protein: ${nutrimentsHelper.amountOfNutriments(
              nutriments.protein,
              nutriments.proteinPerServing,
              product,
            )}',
          ),
          TextSpan(
            text: ' carbs: ${nutrimentsHelper.amountOfNutriments(
              nutriments.carbs,
              nutriments.carbsPerServing,
              product,
            )}',
          ),
          TextSpan(
            text: ' fats: ${nutrimentsHelper.amountOfNutriments(
              nutriments.fats,
              nutriments.fatsPerServing,
              product,
            )}',
          ),
        ],
      ),
    );
  }
}
