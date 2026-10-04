# Sunny Stickers — выполненные 8 пунктов

Учебный Flutter/Dart магазин стикеров. Реализованы **все восемь способов управления состоянием** из исходного плана; в каждом работает полный набор из **14 шагов бизнес-логики**. Варианты находятся в одной ветке `main` и запускаются отдельными точками входа.

[Восемь отчётов Word — Осман Асанов, М-И-25](docs/reports/README.md) · [Общий отчёт со снимками экранов](docs/REPORT.md) · [Исходное задание](docs/ASSIGNMENT.md) · [Учебник](tutorials/Stickers.pdf)

## Запуск

Проверенная версия: **Flutter 3.24.5 / Dart 3.5.4**. Версия Flutter записана в `.flutter-version`, версии пакетов зафиксированы в `pubspec.yaml` и `pubspec.lock`.

```bash
flutter pub get
flutter run -d chrome -t lib/main.dart
```

Для Android/iOS выберите подключённое устройство вместо `-d chrome`. Для Android нужны Android SDK и JDK 17; для iOS — macOS и Xcode.

## Восемь реализаций

1. **Без библиотек управления состоянием** — `setState` и `InheritedWidget` из Flutter SDK. [Код](lib/implementations/vanilla/vanilla_app.dart).
   ```bash
   flutter run -t lib/main.dart
   ```
2. **GetX** — `GetxController`, `Rx<StickerState>` и `GetX` для реактивной подписки. [Код](lib/implementations/getx/getx_app.dart).
   ```bash
   flutter run -t lib/main_getx.dart
   ```
3. **BLoC** — события `StickerAction`, обработчик `on`, состояния через `emit`, подписка `BlocBuilder`. [Код](lib/implementations/bloc/bloc_app.dart).
   ```bash
   flutter run -t lib/main_bloc.dart
   ```
4. **Cubit** — вызов метода `dispatch` без очереди событий, `emit` и `BlocBuilder`. [Код](lib/implementations/cubit/cubit_app.dart).
   ```bash
   flutter run -t lib/main_cubit.dart
   ```
5. **MobX** — `Observable`, `runInAction` и `Observer`; используется явный API без генерации файлов. [Код](lib/implementations/mobx/mobx_app.dart).
   ```bash
   flutter run -t lib/main_mobx.dart
   ```
6. **Redux** — `Store`, чистый reducer, действия, `StoreProvider` и `StoreConnector`. [Код](lib/implementations/redux/redux_app.dart).
   ```bash
   flutter run -t lib/main_redux.dart
   ```
7. **Provider** — `ChangeNotifier`, `notifyListeners`, `ChangeNotifierProvider` и `Consumer`. [Код](lib/implementations/provider/provider_app.dart).
   ```bash
   flutter run -t lib/main_provider.dart
   ```
8. **Riverpod** — `NotifierProvider`, `Notifier`, `ProviderScope` и `ref.watch`. [Код](lib/implementations/riverpod/riverpod_app.dart).
   ```bash
   flutter run -t lib/main_riverpod.dart
   ```

В VS Code/Cursor можно выбрать любую из восьми конфигураций в Run and Debug (`.vscode/launch.json`). Название текущего варианта показано в Profile. Чтобы сменить реализацию, остановите приложение и запустите другую точку входа.

## Что работает в каждом варианте

- Подсветка выбранной категории и фильтрация каталога.
- Детали именно выбранного стикера: изображение, название, рейтинг и описание.
- Изменение количества в деталях и корзине; минимум — 1.
- Пустая корзина, добавление без дубликатов и список покупок.
- Цена позиции, Subtotal, Taxes и Total пересчитываются при изменении количества. Как в главе 8 учебника, сбор — $5 за непустую корзину.
- Удаление свайпом влево или кнопкой сбрасывает количество удалённого стикера.
- Checkout очищает корзину и сбрасывает количество купленных стикеров, сохраняя избранное.
- Пустое избранное, добавление и удаление из деталей/из списка, переход к деталям.
- Светлая/тёмная тема: кнопка с кубиком в каталоге и переключатель в Profile.
- Дополнительно: поиск с учётом выбранной категории и счётчик количества товаров.

Корзина и избранное изначально пусты. Состояние сохраняется при переходах между экранами в рамках запуска приложения; при полном перезапуске начинается новый учебный сеанс.

## Как устроено решение

`lib/states/sticker_state.dart` содержит неизменяемые данные и все восемь действий из задания. `Sticker` и `StickerCategory` используют `final` и `copyWith`. Производные списки корзины, избранного и каталога всегда вычисляются из актуальных данных.

`lib/states/sticker_action.dart` описывает команды и чистые переходы состояния. Каждая реализация в `lib/implementations/` **сама хранит состояние и уведомляет интерфейс средствами своей библиотеки**. Общие правила предметной области исключают расхождения при сравнении вариантов.

`StickerScope` передаёт готовый снимок и функцию отправки команды общим экранам. Он не хранит состояние. Scope расположен над `MaterialApp`, поэтому новые маршруты деталей тоже видят обновления. Детали каждый раз получают актуальный стикер по ID.

UI-пакеты исходного проекта сохранены. Вариант «без библиотек» не импортирует внешние менеджеры состояния; пакеты других вариантов присутствуют в общем pubspec для запуска всех восьми из одного репозитория.

## Проверки

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --reporter expanded
flutter build web --release -t lib/main_riverpod.dart
flutter build apk --debug -t lib/main_riverpod.dart
```

25 содержательных тестов: 9 проверок модели и по 2 сценария интерфейса для каждой из 8 реализаций. Сценарии проходят весь цикл: категория → детали → количество → корзина → изменение суммы → удаление → Checkout → избранное → тема.

[GitHub Actions](https://github.com/1yuken/sun-stickers/actions) запускает анализ, тесты и отдельные сборки Web/Android для всех восьми точек входа. Готовые Web-сборки и APK доступны в артефактах успешного запуска workflow.

Снимки для отчёта можно воспроизвести:

```bash
flutter test --dart-define=CAPTURE_SCREENSHOTS=true test/report_screenshots_test.dart
```

Обычный запуск тестов пропускает этот служебный сценарий и не перезаписывает снимки.
