import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';

class DatabaseProducts extends StatefulWidget {
  @override
  _DatabaseProductsState createState() => _DatabaseProductsState();
}

class _DatabaseProductsState extends State<DatabaseProducts> {
  late ProductCubit productCubit;

  @override
  void initState() {
    super.initState();
    productCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: productCubit.listProducts,
      child: SizedBox(
        height: 170,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.list,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'Get from database',
                style: TextStyle(fontSize: 19),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
