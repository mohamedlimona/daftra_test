import 'package:equatable/equatable.dart';
import 'package:mini_pos_checkout/src/cart/models.dart';
import 'cart_bloc/cart_bloc.dart';

class ReceiptHeader extends Equatable {
  final DateTime checkoutTime;

  const ReceiptHeader({required this.checkoutTime});

  @override
  List<Object> get props => [checkoutTime];
}

class ReceiptLine extends Equatable {
  final String itemId;
  final String itemName;
  final double price;
  final int quantity;
  final double discount;
  final double lineNet;

  const ReceiptLine({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.lineNet,
  });

  @override
  List<Object> get props => [itemId, itemName, price, quantity, discount, lineNet];
}

class Receipt extends Equatable {
  final ReceiptHeader header;
  final List<ReceiptLine> lines;
  final CartTotals totals;

  const Receipt({
    required this.header,
    required this.lines,
    required this.totals,
  });

  @override
  List<Object> get props => [header, lines, totals];
}

Receipt buildReceipt(CartState cartState, DateTime checkoutTime) {
  final header = ReceiptHeader(checkoutTime: checkoutTime);
  final lines = cartState.lines.map((cartLine) {
    return ReceiptLine(
      itemId: cartLine.item.id,
      itemName: cartLine.item.name,
      price: cartLine.item.price,
      quantity: cartLine.quantity,
      discount: cartLine.discount,
      lineNet: cartLine.lineNet,
    );
  }).toList();

  return Receipt(
    header: header,
    lines: lines,
    totals: cartState.totals,
  );
}

