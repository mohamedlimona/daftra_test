import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_pos_checkout/src/cart/cart_bloc/cart_bloc.dart';
import 'package:mini_pos_checkout/src/cart/models.dart';
import 'package:mini_pos_checkout/src/cart/receipt.dart';
import 'package:mini_pos_checkout/src/catalog/item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartBloc', () {
    final Item item1 = const Item(id: 'p01', name: 'Coffee', price: 2.50);
    final Item item2 = const Item(id: 'p02', name: 'Bagel', price: 3.20);

    test(
      'initial state is empty cart with zero totals',
      () {
        final cartBloc = CartBloc();
        expect(cartBloc.state, const CartState());
        cartBloc.close();
      },
    );

    blocTest<CartBloc, CartState>(
      'adds item and calculates correct totals',
      build: () => CartBloc(),
      act: (bloc) => bloc.add(AddItem(item1)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 1, discount: 0.0)],
          totals: CartTotals(
            subtotal: item1.price * 1,
            vat: item1.price * 1 * 0.15,
            grandTotal: item1.price * 1 * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'adds two different items and calculates correct totals',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(item1))
        ..add(AddItem(item2)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 1, discount: 0.0)],
          totals: CartTotals(
            subtotal: item1.price * 1,
            vat: item1.price * 1 * 0.15,
            grandTotal: item1.price * 1 * 1.15,
          ),
        ),
        CartState(
          lines: [
            CartLine(item: item1, quantity: 1, discount: 0.0),
            CartLine(item: item2, quantity: 1, discount: 0.0),
          ],
          totals: CartTotals(
            subtotal: item1.price + item2.price,
            vat: (item1.price + item2.price) * 0.15,
            grandTotal: (item1.price + item2.price) * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'undo restores previous state after add',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(item1))
        ..add(UndoCart()),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 1)],
          totals: CartTotals(
            subtotal: 2.50,
            vat: 0.375,
            grandTotal: 2.875,
          ),
        ),
        const CartState(lines: [], totals: CartTotals()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'redo restores state after undo',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(item1))
        ..add(UndoCart())
        ..add(RedoCart()),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 1)],
          totals: CartTotals(
            subtotal: 2.50,
            vat: 0.375,
            grandTotal: 2.875,
          ),
        ),
        const CartState(lines: [], totals: CartTotals()),
        CartState(
          lines: [CartLine(item: item1, quantity: 1)],
          totals: CartTotals(
            subtotal: 2.50,
            vat: 0.375,
            grandTotal: 2.875,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'increases quantity of existing item and calculates correct totals',
      build: () => CartBloc(),
      seed: () => CartState(lines: [CartLine(item: item1, quantity: 1)]),
      act: (bloc) => bloc.add(AddItem(item1)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 2, discount: 0.0)],
          totals: CartTotals(
            subtotal: item1.price * 2,
            vat: item1.price * 2 * 0.15,
            grandTotal: item1.price * 2 * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item and calculates correct totals',
      build: () => CartBloc(),
      seed: () => CartState(
        lines: [
          CartLine(item: item1, quantity: 1),
          CartLine(item: item2, quantity: 1),
        ],
      ),
      act: (bloc) => bloc.add(RemoveItem(item1.id)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item2, quantity: 1, discount: 0.0)],
          totals: CartTotals(
            subtotal: item2.price * 1,
            vat: item2.price * 1 * 0.15,
            grandTotal: item2.price * 1 * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'changes quantity of an item and calculates correct totals',
      build: () => CartBloc(),
      seed: () => CartState(lines: [CartLine(item: item1, quantity: 1)]),
      act: (bloc) => bloc.add(ChangeQty(itemId: item1.id, quantity: 3)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 3, discount: 0.0)],
          totals: CartTotals(
            subtotal: item1.price * 3,
            vat: item1.price * 3 * 0.15,
            grandTotal: item1.price * 3 * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item if quantity is set to 0',
      build: () => CartBloc(),
      seed: () => CartState(lines: [CartLine(item: item1, quantity: 1)]),
      act: (bloc) => bloc.add(ChangeQty(itemId: item1.id, quantity: 0)),
      expect: () => [
        const CartState(lines: [], totals: CartTotals()),
      ],
    );

    blocTest<CartBloc, CartState>(
      'applies discount to an item and calculates correct totals',
      build: () => CartBloc(),
      seed: () => CartState(lines: [CartLine(item: item1, quantity: 2)]),
      act: (bloc) => bloc.add(ChangeDiscount(itemId: item1.id, discount: 0.10)),
      expect: () => [
        CartState(
          lines: [CartLine(item: item1, quantity: 2, discount: 0.10)],
          totals: CartTotals(
            subtotal: item1.price * 2 * (1 - 0.10),
            vat: item1.price * 2 * (1 - 0.10) * 0.15,
            grandTotal: item1.price * 2 * (1 - 0.10) * 1.15,
          ),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears the cart and resets state',
      build: () => CartBloc(),
      seed: () => CartState(
        lines: [
          CartLine(item: item1, quantity: 1),
          CartLine(item: item2, quantity: 1),
        ],
      ),
      act: (bloc) => bloc.add(ClearCart()),
      expect: () => [
        const CartState(lines: [], totals: CartTotals()),
      ],
    );

    test('buildReceipt function creates correct Receipt model', () {
      final cartState = CartState(
        lines: [
          CartLine(item: item1, quantity: 2, discount: 0.10),
          CartLine(item: item2, quantity: 1, discount: 0.0),
        ],
        totals: CartTotals(
          subtotal: (item1.price * 2 * (1 - 0.10)) + (item2.price * 1),
          vat: ((item1.price * 2 * (1 - 0.10)) + (item2.price * 1)) * 0.15,
          grandTotal:
              ((item1.price * 2 * (1 - 0.10)) + (item2.price * 1)) * 1.15,
        ),
      );
      final checkoutTime = DateTime(2025, 7, 3, 10, 30);

      final receipt = buildReceipt(cartState, checkoutTime);

      expect(receipt.header.checkoutTime, checkoutTime);
      expect(receipt.lines.length, 2);
      expect(receipt.lines[0].itemId, item1.id);
      expect(receipt.lines[0].itemName, item1.name);
      expect(receipt.lines[0].price, item1.price);
      expect(receipt.lines[0].quantity, 2);
      expect(receipt.lines[0].discount, 0.10);
      expect(receipt.lines[0].lineNet, 4.50);
      expect(receipt.lines[1].itemId, item2.id);
      expect(receipt.lines[1].itemName, item2.name);
      expect(receipt.lines[1].price, item2.price);
      expect(receipt.lines[1].quantity, 1);
      expect(receipt.lines[1].discount, 0.0);
      expect(receipt.lines[1].lineNet, 3.20);
      expect(receipt.totals, cartState.totals);
    });
  });
}
