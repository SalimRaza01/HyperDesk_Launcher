import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperdesk/core/services/DeviceService.dart';
import 'package:hyperdesk/core/theme/Colors.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer>
    with SingleTickerProviderStateMixin {
  int totalSpace = 0;
  int freeSpace = 0;
  int usedSpace = 0;

  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    fetchStorageInfo();
    print('Opened');
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  void fetchStorageInfo() async {
    var storage = await DeviceService.getStorageInfo();
    print(storage);
    setState(() {
      totalSpace = storage['total'];
      usedSpace = storage['used'];
      freeSpace = storage['free'];
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      height: screenHeight,
      width: screenWidth,
      color: AppColor.explorerBG,
      child: Column(
        children: [

          Container(
            height: screenHeight / 18,
            decoration: BoxDecoration(
              color: AppColor.borderdarkColor,
              border: Border(
                  bottom:
                      BorderSide(color: AppColor.borderlightColor, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/thisPc.png',
                        height: screenHeight * 0.026,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "This PC",
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(CupertinoIcons.minus,
                          color: AppColor.white, size: screenHeight * 0.02),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.app,
                          color: AppColor.white, size: screenHeight * 0.02),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.multiply,
                          color: Colors.red, size: screenHeight * 0.02),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: AppColor.explorerBG,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(spacing: 15.0, children: [
                  Icon(CupertinoIcons.arrow_left,
                      color: AppColor.white, size: screenHeight * 0.02),
                  Icon(CupertinoIcons.arrow_right,
                      color: AppColor.white, size: screenHeight * 0.02),
                  Expanded(
                    child: Container(
                      height: screenHeight / 25,
                      decoration: BoxDecoration(
                          color: AppColor.darkgrey,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              color: AppColor.borderlightColor, width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          spacing: 10.0,
                          children: [
                            Icon(CupertinoIcons.home,
                                color: AppColor.white,
                                size: screenHeight * 0.02),
                            Icon(CupertinoIcons.chevron_right,
                                color: AppColor.white,
                                size: screenHeight * 0.02),
                            Text(
                              'Home',
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: screenHeight * 0.018),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              )),
          // File Explorer Body
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: screenWidth * 0.15,
                  color: AppColor.explorerBG,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      spacing: 2.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sidebarItem('This PC', 'assets/thisPc.png',
                            screenHeight, screenWidth),
                        _sidebarItem('Desktop', 'assets/folder.png',
                            screenHeight, screenWidth),
                        _sidebarItem('Documents', 'assets/folder.png',
                            screenHeight, screenWidth),
                        _sidebarItem('Downloads', 'assets/folder.png',
                            screenHeight, screenWidth),
                        _sidebarItem('Pictures', 'assets/folder.png',
                            screenHeight, screenWidth),
                        _sidebarItem('Music', 'assets/folder.png', screenHeight,
                            screenWidth),
                        _sidebarItem('Videos', 'assets/folder.png',
                            screenHeight, screenWidth),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                // Main Content Area
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: AppColor.explorerBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Devices and Drives",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.018)),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/drive.png',
                              height: screenHeight * 0.06,
                            ),
                            SizedBox(width: screenWidth * 0.009),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Internal Storage",
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: screenHeight * 0.015)),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.14,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: LinearProgressIndicator(
                                      value: usedSpace / totalSpace, 
                                      backgroundColor: Colors.grey,
                                      color: Colors.blue,
                                      minHeight: screenHeight * 0.01,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.003,
                                ),
                                Text(
                                    "${freeSpace.toString()} GB free of ${totalSpace.toString()} GB",
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: screenHeight * 0.012)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
      String title, String iconPath, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Row(
        children: [
          Image.asset(iconPath, height: screenHeight * 0.025),
          SizedBox(width: screenWidth * 0.01),
          Text(
            title,
            style:
                TextStyle(color: Colors.white, fontSize: screenHeight * 0.015),
          ),
        ],
      ),
    );
  }
}
