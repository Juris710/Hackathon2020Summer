import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class AppInfo {
  static String get name => _appName;
  static String get version => _appVersion;
  static String get buildNumber => _buildNumber;
  static String get packageName => _packageName;
  static String _appName = '';
  static String _appVersion = '';
  static String _buildNumber = '';
  static String _packageName = '';
  static Future _initializeForWeb() async {
    //TODO：Webでのアプリ名：バージョン情報取得方法模索
    _appName = 'Nior';
    _appVersion = '1.0.0';
    _buildNumber = '1';
  }

  static Future initialize() async {
    if (kIsWeb) {
      _initializeForWeb();
      return;
    }
    final packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    _packageName = packageInfo.packageName;
  }
}