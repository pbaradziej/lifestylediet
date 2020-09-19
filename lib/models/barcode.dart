class Barcode {
  final String code;
  final List<Code> codeList;

  Barcode(this.code, this.codeList);

  factory Barcode.fromJson(Map<String, dynamic> json) {
    var barcodeJson = json['products'] as List;
    List<Code> _barCodes =
        barcodeJson.map((barcode) => Code.fromJson(barcode)).toList();
    return Barcode(
      json['code'] as String,
      _barCodes,
    );
  }
}

class Code {
  final String code;

  Code(this.code);

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(json['code']);
  }
}
