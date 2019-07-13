import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatUang {
  uangFormat(String value) {
    final FlutterMoneyFormatter nominalTampil = FlutterMoneyFormatter(
        amount: double.parse(value),
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.long));

    return nominalTampil.output.symbolOnLeft;
  }

  formatUnSimbol(String value) {
    final FlutterMoneyFormatter nominalTampil = FlutterMoneyFormatter(
        amount: double.parse(value),
        settings: MoneyFormatterSettings(
            symbol: '',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.long));

    return nominalTampil.output.symbolOnLeft;
  }

  formatSimbolUjung(String value) {
    final FlutterMoneyFormatter nominalTampil = FlutterMoneyFormatter(
        amount: double.parse(value),
        settings: MoneyFormatterSettings(
            symbol: 'Rp',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: '',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.short));

    return nominalTampil.output.compactSymbolOnLeft;
  }
}
