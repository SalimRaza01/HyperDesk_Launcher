import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperdesk/core/services/DeviceService.dart';
import 'package:hyperdesk/core/theme/Colors.dart';

class QuickPanel extends StatefulWidget {
  const QuickPanel({super.key});

  @override
  State<QuickPanel> createState() => _QuickPanelState();
}

class _QuickPanelState extends State<QuickPanel> {
  String _batteryLevel = '0';
  bool rotation = false;
  double currentVolume = 20;
    late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    _initializeStates();
  }

  Future<void> _initializeStates() async {
    await _getBatteryLevel();
    await _checkAutoRotationStatus();
  }

  Future<void> _getBatteryLevel() async {
    try {
      final result = await DeviceService.getBatteryLevel();
      setState(() => _batteryLevel = result.toString());
    } on PlatformException {
      setState(() => _batteryLevel = "Error");
    }
  }

  Future<void> _checkAutoRotationStatus() async {
    try {
      final result = await DeviceService.isRotationEnabled();
      setState(() => rotation = result);
    } on PlatformException {
      setState(() => rotation = false);
    }
  }

  IconData getBatteryIcon(int level) {
    if (level > 80) return Icons.battery_full;
    if (level > 60) return Icons.battery_6_bar;
    if (level > 40) return Icons.battery_4_bar;
    if (level > 20) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      height: screenHeight / 2,
      width: screenWidth / 3.3,
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderlightColor, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Grid buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                childAspectRatio:1.5,
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 7.0,
                shrinkWrap: true,
                children: [
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.wifi,
                      text: 'WiFi'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.bluetooth,
                      text: 'Bluetooth'),
                  OptionButtons(
                      active: true,
                      iconData: CupertinoIcons.circle_righthalf_fill,
                      text: 'Dark Mode'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.battery_charging,
                      text: 'Battery Saver'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.lightbulb_fill,
                      text: 'Night Mode'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.circle_grid_3x3_fill,
                      text: 'Accessibility'),
                  OptionButtons(
                      active: false, iconData: Icons.cast, text: 'Cast'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.device_desktop,
                      text: 'Project'),
                  OptionButtons(
                      active: false,
                      iconData: CupertinoIcons.light_min,
                      text: 'Nearby Sharing'),
                ],
              ),
            ),
          ),

          // Sliders for brightness and volume
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.brightness,
                      color: AppColor.white,
                      size: screenHeight * 0.017,
                    ),
                    Expanded(
                      child: Slider(
                        value: currentVolume,
                        min: 0,
                        max: 100,
                        activeColor: Colors.blue,
                        onChanged: (double value) {
                          setState(() {
                            currentVolume = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.speaker_3_fill,
                      color: AppColor.white,
                      size: screenHeight * 0.017,
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.blue,
                        value: double.parse(_batteryLevel),
                        min: 0,
                        max: 100,
                        onChanged: (double value) {
                          setState(() {
                            _batteryLevel = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom section with battery and settings
          Container(
            decoration: BoxDecoration(
              color: AppColor.darkgrey,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            height: screenHeight * 0.05,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        getBatteryIcon(int.tryParse(_batteryLevel) ?? 0),
                        color: AppColor.white,
                        size: screenHeight * 0.023,
                      ),
                      SizedBox(width: screenWidth * 0.006),
                      Text(
                        '$_batteryLevel %',
                        style: TextStyle(
                          fontSize: screenHeight * 0.015,
                          color: AppColor.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.settings,
                    color: AppColor.white,
                    size: screenHeight * 0.018,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButtons extends StatelessWidget {
  final bool active;
  final IconData iconData;
  final String text;
  final VoidCallback? onTap;

  const OptionButtons({
    Key? key,
    required this.active,
    required this.iconData,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.blue : AppColor.darkgrey,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: active ? Colors.white : AppColor.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : AppColor.white.withOpacity(0.7),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
