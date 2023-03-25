import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';

class BarcodeScanner extends StatefulWidget {
  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  late ProductCubit productCubit;
  late String barcode;

  @override
  void initState() {
    super.initState();
    productCubit = context.read();
    barcode = 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: scanner,
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
                      Icons.filter_center_focus,
                      size: 120,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 70),
              const Text(
                'Scanner',
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  void scanner() async {
    await scanBarcodeNormal();
    productCubit.scanProduct(barcode);
  }

  Future<void> scanBarcodeNormal() async {
    final String scannedBarcode = await getBarcode();
    if (!mounted) {
      return;
    }

    setState(() {
      barcode = scannedBarcode;
    });
  }

  Future<String> getBarcode() async {
    try {
      return await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      return 'Failed to get platform version.';
    }
  }
}
