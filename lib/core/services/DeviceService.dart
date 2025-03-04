import 'package:flutter/services.dart';

class DeviceService {
  static const MethodChannel _channel = MethodChannel('com.example.myapp/device');


  static Future<int> getBatteryLevel() async {
    try {
      final int result = await _channel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      print("Error getting battery level: ${e.message}");
      return -1;
    }
  }


static Future<List<dynamic>> getInstalledApps() async {
    try {
      final List<dynamic> apps = await _channel.invokeMethod("getInstalledApps");
      return apps;
    } on PlatformException catch (e) {
      print("Failed to get installed apps: '${e.message}'.");
      return [];
    }
  }


  static Future<bool> setRotationEnabled(bool enabled) async {
    try {
      return await _channel.invokeMethod('setRotationEnabled', {"enabled": enabled}) ?? false;
    } on PlatformException catch (e) {
      print("Error enabling rotation: ${e.message}");
      return false;
    }
  }


  static Future<bool> isRotationEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('isRotationEnabled');
      return result;
    } on PlatformException {
      return false;
    }
  }

 static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('getStorageInfo');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get storage info: '${e.message}'.");
      return {};
    }
  }


  static Future<void> launchApp(String packageName) async {
    try {
      await _channel.invokeMethod('launchApp', {'packageName': packageName});
    } on PlatformException catch (e) {
      print("Failed to launch app: ${e.message}");
    }
  }

}
