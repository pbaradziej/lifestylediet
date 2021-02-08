import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';

class DatabaseProducts extends StatefulWidget {
  @override
  _DatabaseProductsState createState() => _DatabaseProductsState();
}

class _DatabaseProductsState extends State<DatabaseProducts> {
  AddBloc _addBloc;

  @override
  void initState() {
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _addBloc.add(DatabaseProductList());
      },
      child: Container(
        height: 170,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.list,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
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
