import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperdesk/core/theme/Colors.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> with SingleTickerProviderStateMixin {


@override
  void initState() {
  
    super.initState();
    print('Opened');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedContainer(
         curve:Curves.easeInOut,
      duration: Duration(milliseconds: 2000),
      height: screenHeight,
      width: screenWidth,
      color: AppColor.backgroundColor,
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.05,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    spacing: 15.0,
                    children: [
                      Image.asset(
                        'assets/thisPc.png',
                        height: screenHeight * 0.026,
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        // color: AppColor.borderlightColor,
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      child: Icon(CupertinoIcons.minus,
                          color: AppColor.white, size: screenHeight * 0.02),
                    )),
                    Container(
                        // color: AppColor.borderlightColor,
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      child: Icon(CupertinoIcons.app,
                          color: AppColor.white, size: screenHeight * 0.02),
                    )),
                    Container(
                        // color:  Colors.red,
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      child: Icon(CupertinoIcons.multiply,
                          color: AppColor.white, size: screenHeight * 0.02),
                    )),
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
                      height: screenHeight * 0.04,
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
          // Storage Section
          Expanded(
            child: Container(
              color: AppColor.explorerBG,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(spacing: 10.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Devices and drives",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenHeight * 0.018)),
                    Row(
                      spacing: 15.0,
                      children: [
                        Image.asset('assets/drive.png', height: screenHeight * 0.06,),
                        Expanded(
                          child: Column(
                            spacing: 5.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Internal",
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: screenHeight * 0.018)),
                              SizedBox(
                                width: screenWidth * 0.14,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: LinearProgressIndicator(
                                    value: 75.1 / 219.5,
                                    backgroundColor: Colors.white,
                                    color: Colors.blue,
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              Text("75.1 GB free of 219.5",
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: screenHeight * 0.018)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
