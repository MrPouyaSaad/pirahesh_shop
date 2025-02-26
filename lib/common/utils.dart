import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLabel on double {
  String get withPriceLabel => this > 0 ? '$separateByComma \$' : 'Free';

  String get separateByComma {
    final numberFormat = NumberFormat.currency(symbol: '');
    return numberFormat.format(this);
  }
}
