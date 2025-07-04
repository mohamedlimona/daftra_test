import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_pos_checkout/src/catalog/item.dart';
import 'package:mini_pos_checkout/src/cart/models.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartState> _undoStack = [];
  final List<CartState> _redoStack = [];

  CartBloc() : super(const CartState()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeQty>(_onChangeQty);
    on<ChangeDiscount>(_onChangeDiscount);
    on<ClearCart>(_onClearCart);
    on<UndoCart>(_onUndo);
    on<RedoCart>(_onRedo);
  }

  void _saveStateForUndo() {
    _undoStack.add(state);
    _redoStack.clear();
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    _saveStateForUndo();

    final List<CartLine> updatedLines = List.from(state.lines);
    final int existingIndex =
        updatedLines.indexWhere((line) => line.item.id == event.item.id);

    if (existingIndex != -1) {
      final CartLine existingLine = updatedLines[existingIndex];
      updatedLines[existingIndex] =
          existingLine.copyWith(quantity: existingLine.quantity + 1);
    } else {
      updatedLines.add(CartLine(item: event.item));
    }

    emit(_calculateTotals(state.copyWith(lines: updatedLines)));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    _saveStateForUndo();

    final List<CartLine> updatedLines = List.from(state.lines)
      ..removeWhere((line) => line.item.id == event.itemId);

    emit(_calculateTotals(state.copyWith(lines: updatedLines)));
  }

  void _onChangeQty(ChangeQty event, Emitter<CartState> emit) {
    _saveStateForUndo();

    final List<CartLine> updatedLines = List.from(state.lines);
    final int existingIndex =
        updatedLines.indexWhere((line) => line.item.id == event.itemId);

    if (existingIndex != -1) {
      final CartLine existingLine = updatedLines[existingIndex];
      if (event.quantity > 0) {
        updatedLines[existingIndex] =
            existingLine.copyWith(quantity: event.quantity);
      } else {
        updatedLines.removeAt(existingIndex);
      }
    }

    emit(_calculateTotals(state.copyWith(lines: updatedLines)));
  }

  void _onChangeDiscount(ChangeDiscount event, Emitter<CartState> emit) {
    _saveStateForUndo();

    final List<CartLine> updatedLines = List.from(state.lines);
    final int existingIndex =
        updatedLines.indexWhere((line) => line.item.id == event.itemId);

    if (existingIndex != -1) {
      final CartLine existingLine = updatedLines[existingIndex];
      updatedLines[existingIndex] =
          existingLine.copyWith(discount: event.discount);
    }

    emit(_calculateTotals(state.copyWith(lines: updatedLines)));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _saveStateForUndo();
    emit(const CartState(lines: [], totals: CartTotals()));
  }

  void _onUndo(UndoCart event, Emitter<CartState> emit) {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(state);
      emit(_undoStack.removeLast());
    }
  }

  void _onRedo(RedoCart event, Emitter<CartState> emit) {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(state);
      emit(_redoStack.removeLast());
    }
  }

  CartState _calculateTotals(CartState currentState) {
    double subtotal = 0.0;
    for (var line in currentState.lines) {
      subtotal += line.lineNet;
    }
    final double vat = subtotal * 0.15;
    final double grandTotal = subtotal + vat;

    return currentState.copyWith(
      totals: CartTotals(
        subtotal: subtotal,
        vat: vat,
        grandTotal: grandTotal,
      ),
    );
  }
}
