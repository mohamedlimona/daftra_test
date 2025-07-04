# Mini-POS Checkout Core


---

## Project Structure

```
mini_pos_checkout/
├── lib/
│   └── src/
│       ├── catalog/
│       │   ├── catalog_bloc.dart         # CatalogBloc for managing catalog
│       │   ├── catalog_event.dart        # Events for CatalogBloc
│       │   └── item.dart                 # Product item model
│       └── cart/
│           ├── cart_bloc.dart            # CartBloc for cart business logic
│           ├── cart_event.dart           # Events for CartBloc
│           ├── cart_state.dart           # CartState with cart lines & totals
│           ├── models.dart               # CartLine, CartTotals models
│           └── receipt.dart              # Receipt builder
│      
├── assets/
│   └── catalog.json                      # Static catalog for item definitions
└── test/
    ├── catalog_bloc_test.dart            # Unit tests for catalog logic
    └── cart_bloc_test.dart               # Unit tests for cart logic (add, undo, redo, etc.)
```

---

## 🚀 Setup and Installation

**Clone the repository:**

[or use zip file]

```bash
git clone https://github.com/mohamedlimona/daftra_test.git
cd mini_pos_checkout
```


**Install dependencies:**

Ensure the following versions:

- ✅ Flutter SDK: `3.29.3`
- ✅ Dart SDK: `3.2.3`

Then run:

```bash
flutter pub get
```

**Estimated Time Spent:**

- ⏱️ **1 Day** of focused development and testing.

---

## 🧪 Running Unit Tests

To verify core functionality, run the unit tests:

```bash
flutter test
```

You should see all tests pass, covering:

- ✅ CartBloc operations: add, remove, quantity, discounts
- ✅ Undo/Redo logic with history stack
- ✅ Receipt generation
- ✅ CatalogBloc for loading catalog from JSON

---

## 📦 Features

-  Add, update, remove items from cart
-  Quantity and discount updates
-  Undo and redo operations
-  Receipt generation with tax and discount breakdown
-  Optional manual storage (save/load state)
-  Modular and testable architecture
-  Pure Dart logic – usable across Flutter/mobile/server



## 📦 Missed Items

- Hydration
---
 

## 🗃️ Asset: `catalog.json`

Your product catalog is defined in:

```
assets/catalog.json
```
 

## 🧠 Undo / Redo Support

The `CartBloc` supports:

- ⬅️ `Undo` — revert to previous cart state
- ➡️ `Redo` — re-apply a reverted change

  
## 👨‍💻 Author

**Mohamed Tawfik**  
GitHub: [@mohamedlimona](https://github.com/mohamedlimona)

 
