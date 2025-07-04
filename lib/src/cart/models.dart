import 'package:equatable/equatable.dart';
import 'package:mini_pos_checkout/src/catalog/item.dart';

class CartLine extends Equatable {
  final Item item;
  final int quantity;
  final double discount;

  const CartLine({
    required this.item,
    this.quantity = 1,
    this.discount = 0.0,
  });

  CartLine copyWith({
    Item? item,
    int? quantity,
    double? discount,
  }) {
    return CartLine(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  /// Net total for this cart line after applying discount
  double get lineNet => item.price * quantity * (1 - discount);

  /// Deserialize from JSON (used in HydratedBloc)
  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        item: Item.fromJson(json['item'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        discount: (json['discount'] as num).toDouble(),
      );

  /// Serialize to JSON (used in HydratedBloc)
  Map<String, dynamic> toJson() => {
        'item': item.toJson(),
        'quantity': quantity,
        'discount': discount,
      };

  @override
  List<Object> get props => [item, quantity, discount];
}

class CartTotals extends Equatable {
  final double subtotal;
  final double vat;
  final double grandTotal;

  const CartTotals({
    this.subtotal = 0.0,
    this.vat = 0.0,
    this.grandTotal = 0.0,
  });

  factory CartTotals.fromJson(Map<String, dynamic> json) => CartTotals(
        subtotal: json["subtotal"] as double,
        vat: json["vat"] as double,
        grandTotal: json["grandTotal"] as double,
      );

  Map<String, dynamic> toJson() => {
        'item': subtotal,
        'quantity': vat,
        'discount': grandTotal,
      };
  @override
  List<Object> get props => [subtotal, vat, grandTotal];

  // Custom equality check for floating point numbers
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartTotals &&
        (subtotal - other.subtotal).abs() < 0.01 &&
        (vat - other.vat).abs() < 0.01 &&
        (grandTotal - other.grandTotal).abs() < 0.01;
  }

  @override
  int get hashCode => subtotal.hashCode ^ vat.hashCode ^ grandTotal.hashCode;
}
