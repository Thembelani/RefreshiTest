String formatRand(int priceCents) {
  final rands = priceCents ~/ 100;
  final cents = (priceCents % 100).toString().padLeft(2, '0');
  return 'R$rands.$cents';
}

int sellingPriceToCents(double sellingPrice) => (sellingPrice * 100).round();
