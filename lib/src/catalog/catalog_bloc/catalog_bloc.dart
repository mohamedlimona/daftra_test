
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mini_pos_checkout/src/catalog/item.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc() : super(CatalogInitial()) {
    on<LoadCatalog>(_onLoadCatalog);
  }

  Future<void> _onLoadCatalog(LoadCatalog event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    try {
      final String response = await rootBundle.loadString('assets/catalog.json');
      final List<dynamic> data = json.decode(response);
      final List<Item> items = data.map((json) => Item.fromJson(json)).toList();
      emit(CatalogLoaded(items));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }
}

