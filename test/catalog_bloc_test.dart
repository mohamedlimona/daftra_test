import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_pos_checkout/src/catalog/catalog_bloc/catalog_bloc.dart';
import 'package:mini_pos_checkout/src/catalog/item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CatalogBloc', () {
    blocTest<
        CatalogBloc, CatalogState>(
      'emits [CatalogLoading, CatalogLoaded] when LoadCatalog is added',
      build: () => CatalogBloc(),
      act: (bloc) => bloc.add(LoadCatalog()),
      expect: () => [
        CatalogLoading(),
        isA<CatalogLoaded>(),
      ],
      verify: (bloc) {
        final loadedState = bloc.state as CatalogLoaded;
        expect(loadedState.items, isNotEmpty);
        expect(loadedState.items.length, 20);
        expect(loadedState.items[0], const Item(id: 'p01', name: 'Coffee', price: 2.50));
      },
    );
  });
}

