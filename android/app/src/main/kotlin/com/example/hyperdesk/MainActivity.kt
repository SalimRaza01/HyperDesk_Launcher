package com.example.hyperdesk

import io.flutter.embedding.android.FlutterActivity
import android.content.*
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.drawable.BitmapDrawable
import android.os.BatteryManager
import android.os.Build
import android.provider.Settings
import android.util.Base64
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.os.StatFs
import java.io.File
import android.graphics.Bitmap



class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.myapp/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> result.success(getBatteryLevel())
                "getInstalledApps" -> result.success(getInstalledApps())
                "setRotationEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    result.success(setRotationEnabled(enabled))
                }
                "isRotationEnabled" -> result.success(isRotationEnabled()) 
            
                "getStorageInfo" -> result.success(getStorageInfo())
                "launchApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
                        if (launchIntent != null) {
                            startActivity(launchIntent)
                            result.success(true)
                        } else {
                            result.error("APP_NOT_FOUND", "App not found", null)
                        }
                    } else {
                        result.error("INVALID_PACKAGE", "Package name is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

private fun getStorageInfo(): Map<String, Any> {
        val path: File = Environment.getDataDirectory() // Internal Storage
        val stat = StatFs(path.path)

        val blockSize = stat.blockSizeLong
        val totalBlocks = stat.blockCountLong
        val availableBlocks = stat.availableBlocksLong

        val totalStorage = totalBlocks * blockSize // Total Storage (Bytes)
        val freeStorage = availableBlocks * blockSize // Free Storage (Bytes)
        val usedStorage = totalStorage - freeStorage // Used Storage (Bytes)

        return mapOf(
            "total" to totalStorage / (1024 * 1024 * 1024), // Convert to GB
            "used" to usedStorage / (1024 * 1024 * 1024), // Convert to GB
            "free" to freeStorage / (1024 * 1024 * 1024) // Convert to GB
        )
    }

    private fun hasWriteSettingsPermission(): Boolean {
        return Settings.System.canWrite(this)
    }

    private fun requestWriteSettingsPermission() {
        val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
        intent.data = Uri.parse("package:$packageName")
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

 
    private fun setRotationEnabled(enable: Boolean): Boolean {
        return if (hasWriteSettingsPermission()) {
            Settings.System.putInt(contentResolver, Settings.System.ACCELEROMETER_ROTATION, if (enable) 1 else 0)
            true
        } else {
            requestWriteSettingsPermission()
            false
        }
    }


    private fun isRotationEnabled(): Boolean {
        return Settings.System.getInt(contentResolver, Settings.System.ACCELEROMETER_ROTATION, 0) == 1
    }


    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

private fun getInstalledApps(): List<Map<String, String>> {
    val packageManager: PackageManager = packageManager
    val apps = mutableListOf<Map<String, String>>()

    val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
    
    for (app in packages) {

        val launchIntent = packageManager.getLaunchIntentForPackage(app.packageName)
        if (launchIntent != null) {
            val isSystemApp = (app.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            val iconBase64 = app.loadIcon(packageManager)?.let { drawableToBase64(it) } ?: ""
            apps.add(
                mapOf(
                    "name" to (app.loadLabel(packageManager)?.toString() ?: "Unknown"),
                    "packageName" to app.packageName,
                    "icon" to iconBase64,
                    "isSystemApp" to isSystemApp.toString()
                )
            )
        }
    }
    return apps
}


private fun drawableToBase64(drawable: android.graphics.drawable.Drawable): String {
    val bitmap = (drawable as? BitmapDrawable)?.bitmap ?: return ""
    val stream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
    return Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP) 
}

}

