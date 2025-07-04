# Mini-POS Checkout Core

This project implements a "Mini-POS Checkout Core" in Dart using the BLoC state management library. It includes a catalog, a shopping cart, and a receipt builder, along with comprehensive unit test coverage.

## Project Structure

- `lib/src/catalog/`: Contains the `Item` model, `CatalogBloc` for managing the product catalog, and related events.
- `lib/src/cart/`: Contains `CartLine`, `CartTotals`, `CartState` models, `CartBloc` for managing the shopping cart logic, and `Receipt` builder.
- `assets/`: Contains `catalog.json` which serves as the product database.
- `test/`: Contains unit tests for `CatalogBloc` and `CartBloc`.

## Setup and Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd mini_pos_checkout
    ```

2.  **Install dependencies:**
    Make sure you have Flutter SDK installed and configured. Then run:
    ```bash
    flutter pub get
    ```

## Running Tests

To run all unit tests, execute the following command in the project root directory:

```bash
flutter test
```

All tests should pass, indicating the core logic is functioning as expected.


