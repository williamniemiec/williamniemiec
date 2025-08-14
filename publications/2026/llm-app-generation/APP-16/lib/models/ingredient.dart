class Ingredient {
  final String name;
  final String amount;
  final String unit;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      amount: map['amount'].toString(),
      unit: map['unit'],
    );
  }
}