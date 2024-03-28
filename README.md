# Memo

## Flutter環境の確認
flutter doctor

## 依存関係更新
flutter clean
flutter pub get

## 全てのキャッシュされたパッケージを再ダウンロード
flutter pub cache repair

## classes変更時
flutter pub run build_runner build

## windowsでテスト
flutter run -d windows

## 分析ツールの実行
flutter analyze

## 実機テスト
1. Flutter: Launch Emulator [コマンドパレット]
2. flutter run [ターミナル]
3. Flutter: Hot Reload [コマンドパレット]