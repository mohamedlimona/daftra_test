part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartLine> lines;
  final CartTotals totals;

  const CartState({
    this.lines = const [],
    this.totals = const CartTotals(),
  });

  CartState copyWith({
    List<CartLine>? lines,
    CartTotals? totals,
  }) {
    return CartState(
      lines: lines ?? this.lines,
      totals: totals ?? this.totals,
    );
  }

  /// Deserialize from JSON (for HydratedBloc)
  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => CartLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: CartTotals.fromJson(json['totals'] as Map<String, dynamic>),
    );
  }

  /// Serialize to JSON (for HydratedBloc)
  Map<String, dynamic> toJson() => {
    'lines': lines.map((line) => line.toJson()).toList(),
    'totals': totals.toJson(),
  };

  @override
  List<Object> get props => [lines, totals];
}
