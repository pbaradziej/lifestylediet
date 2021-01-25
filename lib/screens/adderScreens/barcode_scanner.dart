import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  ProductRepository _productRepository = new ProductRepository();
  String _barcode = 'Unknown';
  AddBloc _addBloc;

  @override
  void initState() {
    _addBloc = BlocProvider.of<AddBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _barcodeScanner();
  }

  Widget _barcodeScanner() {
    return GestureDetector(
      onTap: () {
        _scanner();
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
                      Icons.filter_center_focus,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 70),
              Text(
                'Scanner',
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  _scanner() async {
    await _scanBarcodeNormal();
    DatabaseProduct product;
    try {
      product = await _productRepository.getProductFromBarcode(_barcode);
    } catch (Exception) {}
    if (product != null) {
      _detailsNavigator(product);
    } else {
      _snackBar();
    }
  }

  Future<void> _scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _barcode = barcodeScanRes;
    });
  }

  _detailsNavigator(DatabaseProduct product) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          product: product,
          addBloc: _addBloc,
          isEditable: true,
          isNewProduct: true,
        ),
      ),
    );
  }

  Widget _snackBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context)
        ..showSnackBar(SnackBar(
          content: Text('Product not found!'),
        ));
    });
    _addBloc.add(InitialScreen());
    return Container();
  }
}
