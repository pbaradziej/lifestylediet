import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/screens/detail/multi_details_screen.dart';

class MultiDetailsScreenProvider extends StatelessWidget {
  final List<DatabaseProduct> products;
  final BuildContext context;

  const MultiDetailsScreenProvider({
    required this.products,
    required this.context,
  });

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: providers(),
      child: MultiDetailsScreen(
        products: products,
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
