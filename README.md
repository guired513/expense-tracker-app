
# 💸  Expense Tracker App

**Expense Tracker App** is a minimalist, offline-first Flutter mobile app that helps users track their daily income and expenses by category. It uses the lightweight [Hive](https://docs.hivedb.dev/) NoSQL database for fast local storage and supports category-based organization, intuitive UI, and expandable features for analytics and reporting.

![Flutter](https://img.shields.io/badge/Flutter-Expense%20Tracker-blue)
![Hive](https://img.shields.io/badge/Hive-local--storage-yellow)
![Status](https://img.shields.io/badge/Status-Stable%20v1.1-green)

---

## 📱 Features

- ✅ Add and manage **expenses** by category
- ✅ Add and manage **income** by category
- ✅ Toggle **Income/Expense** in unified entry form
- ✅ View **transaction list** with filters
- ✅ Hive-powered local data persistence (offline capable)
- ✅ Modular and scalable codebase using Flutter best practices

---

## 🏗️ Project Structure

```
lib/
├── models/                 # Hive models: Expense, Income, Category
├── screens/               # Main UI screens (Home, Analytics, etc.)
├── widgets/               # Reusable widgets (entry forms, cards, etc.)
├── utils/                 # Constants, helpers
└── main.dart              # App initialization & Hive setup
```

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter SDK (v3.10+ recommended)
- Dart SDK
- Android Studio or VS Code
- Android/iOS Emulator or Physical Device

### 🛠️ Installation

1. **Clone the repo**

```bash
git clone https://github.com/yourusername/expense-tracker-app.git
cd expense-tracker-app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate Hive TypeAdapters**

```bash
flutter packages pub run build_runner build
```

4. **Run the app**

```bash
flutter run
```

---

## 🗃️ Local Storage Setup (Hive)

Hive is initialized in `main.dart`:

```dart
await Hive.initFlutter();
Hive.registerAdapter(ExpenseAdapter());
Hive.registerAdapter(IncomeAdapter());
Hive.registerAdapter(CategoryAdapter());
await Hive.openBox<Expense>('expenses');
await Hive.openBox<Income>('incomes');
await Hive.openBox<Category>('categories');
```

---

## 🧪 Testing

Basic testing is currently manual. Unit and widget test files will be added in future versions.

---

## 🔮 Roadmap

Planned for upcoming versions:
- [ ] Edit/Delete entries
- [ ] Monthly/Yearly summary charts
- [ ] Export to CSV
- [ ] Google Sign-in (optional cloud backup)
- [ ] Dark mode toggle
- [ ] Responsive layout for tablets

---

## 🙋‍♂️ Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss your proposal.

To contribute:

1. Fork this repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a new Pull Request

---

## 🧑‍💻 Author

**Guillermo V. Red, Jr., DIT**  
Assistant Professor
Bicol University - Polangui  
[GitHub](https://github.com/guired513)

---

## 📄 License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for details.

---

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev)
- [Hive](https://docs.hivedb.dev)
- [VS Code](https://code.visualstudio.com/)
- [Freepik](https://www.freepik.com/) for UI inspirations
