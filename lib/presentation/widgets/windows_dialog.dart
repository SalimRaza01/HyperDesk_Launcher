import 'package:flutter/material.dart';

class WindowsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(16),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.window, size: 40, color: Colors.blue),
                SizedBox(width: 10),
                Text('Windows 11',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Microsoft Windows\nVersion Dev (OS Build 21996.1)\n© Microsoft Corporation. All rights reserved.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'The Windows 11 SE operating system and its user interface are protected by trademark and other pending or existing intellectual property rights in the United States and other countries/regions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text('Microsoft Software License Terms',
                  style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
