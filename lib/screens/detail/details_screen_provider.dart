import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/screens/detail/details_screen.dart';

class DetailsScreenProvider extends StatelessWidget {
  final DatabaseProduct product;
  final BuildContext context;
  final bool isEditable;
  final bool isNewProduct;

  const DetailsScreenProvider({
    required this.product,
    required this.context,
    this.isEditable = false,
    this.isNewProduct = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers(),
      child: DetailsScreen(
        product: product,
        isEditable: isEditable,
        isNewProduct: isNewProduct,
      ),
    );
  }

  List<BlocProvider<BlocBase<Object>>> providers() {
    return <BlocProvider<BlocBase<Object>>>[
      BlocProvider<RoutingCubit>.value(
        value: context.read(),
      ),
      BlocProvider<ProductCubit>.value(
        value: context.read(),
      ),
    ];
  }
}
