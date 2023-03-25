import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/components/snack_bar.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/screens/detail/details_screen_provider.dart';
import 'package:lifestylediet/screens/detail/multi_details_screen_provider.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/screens/product/barcode_scanner.dart';
import 'package:lifestylediet/screens/product/database_list.dart';
import 'package:lifestylediet/screens/product/database_products.dart';
import 'package:lifestylediet/utils/palette.dart';

class AddProductScreen extends StatefulWidget {
  final String meal;
  final String date;

  const AddProductScreen({
    required this.meal,
    required this.date,
  });

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late ProductCubit productCubit;
  late RoutingCubit routingCubit;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    productCubit = context.read();
    routingCubit = context.read();
    searchController = TextEditingController();
    productCubit.initializeScreen();
  }

  @override
  Widget build(BuildContext context) {
    final ProductState state = context.select<ProductCubit, ProductState>(getProductState);
    return ColoredBox(
      color: defaultColor,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              appBar(),
              searchField(),
              builder(state),
            ],
          ),
        ),
      ),
    );
  }

  ProductState getProductState(ProductCubit cubit) {
    return cubit.state;
  }

  Future<bool> onWillPop() async {
    routingCubit.showHomeScreen();
    return false;
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: defaultColor,
        ),
        onPressed: () => routingCubit.showHomeScreen(),
      ),
    );
  }

  Widget searchField() {
    return TextFormFieldComponent(
      onChangedParameter: onChangedParameter,
      searchField: true,
      controller: searchController,
      hintText: 'Search products...',
      onFieldSubmitted: (_) => productCubit.searchProducts(searchController.text),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: defaultBorderColor,
        ),
        onPressed: () => productCubit.searchProducts(searchController.text),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  void onChangedParameter() {
    if (searchController.text == '') {
      productCubit.initializeScreen();
    }
  }

  Widget builder(ProductState state) {
    final ProductStatus status = state.status;
    final List<DatabaseProduct> updatedProducts = getUpdatedProducts(state);
    if (status == ProductStatus.loading) {
      return loadingScreen();
    } else if (status == ProductStatus.loaded) {
      showSnackBar(state.message);
    } else if (status == ProductStatus.filtered) {
      getSearchProductList(updatedProducts);
    } else if (status == ProductStatus.listProducts) {
      return DatabaseListScreen(
        products: updatedProducts,
      );
    }

    return adderCards();
  }

  List<DatabaseProduct> getUpdatedProducts(ProductState state) {
    final List<DatabaseProduct> products = state.products;
    return <DatabaseProduct>[
      for(DatabaseProduct product in products) product = product.copyWith(
        meal: widget.meal,
        date: widget.date,
      )
    ];
  }

  void showSnackBar(String message) {
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) => SnackBarBuilder.showSnackBar(context, message),
      );
    }
  }

  void getSearchProductList(List<DatabaseProduct> products) async {
    final int productsListSize = products.length;
    if (productsListSize > 1) {
      return multiDetailsNavigator(products);
    } else if (productsListSize == 1) {
      return detailsNavigator(products.first);
    }
  }

  void multiDetailsNavigator(List<DatabaseProduct> products) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => navigateToMultiDetails(products),
    );
  }

  Future<void> navigateToMultiDetails(List<DatabaseProduct> products) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) =>
            MultiDetailsScreenProvider(
              products: products,
              context: context,
            ),
      ),
    );
  }

  void detailsNavigator(DatabaseProduct product) {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => navigateToDetails(product),
    );
  }

  Future<void> navigateToDetails(DatabaseProduct product) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext _) =>
            DetailsScreenProvider(
              product: product,
              context: context,
              isEditable: true,
              isNewProduct: true,
            ),
      ),
    );
  }

  Widget adderCards() {
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: BarcodeScanner(),
              ),
              Flexible(
                child: DatabaseProducts(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
