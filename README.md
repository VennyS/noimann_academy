# Noimann Academy

Noimann Academy — кроссплатформенное приложение на Flutter для отображения веб-сайта `https://ru.noimann.academy` в нативном WebView с поддержкой Windows, iOS, Android и macOS. Приложение включает проверку интернет-соединения и отображение сплэш-скрина или ошибки при отсутствии сети.

## Архитектура

Код проекта организован в папке `lib` с чёткой структурой для обеспечения модульности и удобства поддержки.

### Структура директорий

- **lib/**
  - **constants.dart**: Содержит глобальные константы, такие как базовый протокол (`https://`) и хост (`ru.noimann.academy`).
  - **main.dart**: Точка входа приложения, инициализирует `MaterialApp` и основной виджет `MyHomePage`.
  - **widgets/**: Модульные UI-компоненты:
    - **no_internet/no_internet.dart**: Виджет, отображаемый при отсутствии интернет-соединения (иконка и текст ошибки).
    - **splash_screen/splash_screen.dart**: Сплэш-скрин с индикатором прогресса, показываемый во время загрузки WebView.
    - **webview/webview.dart**: Кроссплатформенный WebView-виджет, использующий `webview_windows` для Windows и `webview_flutter` для iOS, Android и macOS.

### Ключевые особенности

- **Кроссплатформенность**: `WebViewWidget` выбирает подходящую реализацию WebView в зависимости от платформы:
  - Windows: `WebviewWindows` с использованием `webview_windows`.
  - iOS, Android, macOS: с использованием `webview_flutter`.
- **Ограничение навигации**: WebView разрешает доступ только к `ru.noimann.academy` и его поддоменам/подпутям.
- **Проверка сети**: Используется `connectivity_plus` для отслеживания состояния интернета. При отсутствии сети отображается `NoInternetWidget`.
- **Состояние загрузки**: Callback `onLoadingChanged` сообщает родительскому виджету, когда WebView начинает или завершает загрузку.

## Зависимости

- `flutter`: SDK для кроссплатформенной разработки.
- `webview_windows: ^0.2.2`: Для WebView на Windows.
- `connectivity_plus: ^6.0.0`: Для проверки состояния сети.

Добавьте в `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  webview_windows: ^0.2.2
  connectivity_plus: ^6.0.0
```

## Запуск

### Требования

- **Flutter**: Версия 3.0.0 или выше.
- **Dart**: Версия, совместимая с Flutter (обычно 2.17.0+).
- **ОС**: Windows, macOS, Linux (для разработки).
- **Устройства**: Windows, iOS (9.0+), Android (API 19+), macOS (10.13+).

### Подготовка

1. Установите зависимости:
   ```bash
   flutter pub get
   ```
2. Настройте платформы:
   - **Windows**: Убедитесь, что Flutter настроен для Windows (см. [Flutter Windows Setup](https://docs.flutter.dev/get-started/install/windows)).
   - **Android**: В `android/app/build.gradle` установите `minSdkVersion` ≥ 19. Добавьте в `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
     ```
   - **iOS**: В `ios/Runner/Info.plist` добавьте:
     ```xml
     <key>io.flutter.embedded_views_preview</key>
     <true/>
     <key>NSAppTransportSecurity</key>
     <dict>
       <key>NSAllowsArbitraryLoads</key>
       <true/>
     </dict>
     ```
   - **macOS**: В `macos/Runner/*.entitlements` добавьте:
     ```xml
     <key>com.apple.security.network.client</key>
     <true/>
     ```

### Запуск приложения

```bash
flutter run -d windows
flutter run -d ios
flutter run -d android
flutter run -d macos
```

## Сборка

### Сборка для выпуска

1. **Windows**:

   - Создайте релизную сборку:
     ```bash
     flutter build windows
     ```
   - Выходные файлы находятся в `build/windows/x64/runner/Release`.
   - Для распространения упакуйте содержимое `Release` в инсталлятор (например, с помощью Inno Setup).

2. **Android**:

   - Создайте APK или AAB:
     ```bash
     flutter build apk --release
     flutter build appbundle --release
     ```
   - Выходные файлы: `build/app/outputs/flutter-apk/app-release.apk` или `build/app/outputs/bundle/release/app-release.aab`.

3. **iOS**:

   - Создайте IPA:
     ```bash
     flutter build ios --release
     ```
   - Архивируйте приложение через Xcode для загрузки в App Store:
     ```bash
     open ios/Runner.xcworkspace
     ```
   - Настройте подписи в Xcode (см. [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)).

4. **macOS**:
   - Создайте релизную сборку:
     ```bash
     flutter build macos --release
     ```
   - Выходной файл: `build/macos/Build/Products/Release/<app_name>.app`.
   - Для распространения создайте DMG или подпишите приложение (см. [Flutter macOS Deployment](https://docs.flutter.dev/deployment/macos)).
