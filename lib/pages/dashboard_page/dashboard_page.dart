import 'dart:developer';
import 'package:easy_grade/pages/academic_calender/academic_calender.dart';
import 'package:easy_grade/provider/dashboard_provider.dart';
import 'package:easy_grade/provider/profile_provider.dart';
import 'package:easy_grade/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../widgets/app_text.dart';
import '../../widgets/flashy_tabbar.dart';
import '../home_page/home_page.dart';
import '../my_course/my_course.dart';
import '../notification_page/notification_page.dart';
import '../profile_page/profile_page.dart';

class DashBoardPage extends StatefulWidget {
  final int selectedIndex;
  const DashBoardPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<DashBoardPage> createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage> {

  List<Widget> pages =  [
    const HomePage(),
    const MyCourse(),
    const NotificationPage(),
    const AcademicCalender(),
    const ProfilePage()
  ];

  @override
  void initState() {
    DashBoardProvider dashBoardProvider = Provider.of<DashBoardProvider>(context, listen: false);
    dashBoardProvider.selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("------>Current Screen: $runtimeType");
    return Consumer2(
        builder: (context,DashBoardProvider dashBoardProvider,ProfileProvider profileProvider,_) {
          return WillPopScope(
            onWillPop: () async {
            if( dashBoardProvider.selectedIndex == 0){
              return await showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      titlePadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      title: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: ColorConstant.appLightBlue,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        padding: const EdgeInsets.all(10),
                        child: AppText(
                          text: S.of(context).exitApp,
                          textColor: ColorConstant.appWhite,
                        ),
                      ),
                      content:  AppText(
                        text: S.of(context).exitAppMsg,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              height: 40,
                              width: 80,
                              buttonText: S.of(context).no,
                              fontSize: 12,
                              borderRadius: 10,
                              onTap: () => Navigator.pop(context),
                            ),
                            AppButton(
                              height: 40,
                              width: 80,
                              buttonText:  S.of(context).yes,
                              fontSize: 12,
                              borderRadius: 10,
                              onTap: () => SystemNavigator.pop(),
                            ),
                          ],
                        ),
                      ],
                    ),
              );
            }
            else{
              return await dashBoardProvider.changeIndex(0);
            }

            },
            child: Scaffold(
              bottomNavigationBar: FlashyTabBar(
                height: 68,
                iconSize: 25,
                animationCurve: Curves.linear,
                 animationDuration: const Duration(milliseconds: 800),
                selectedIndex: dashBoardProvider.selectedIndex,
                showElevation: true, // use this to remove appBar's elevation
                onItemSelected: (index) {
                  dashBoardProvider.changeIndex(index);
                  profileProvider.profileImage = null;
                },
                items: [
                  FlashyTabBarItem(
                    icon: const Icon(Icons.home_sharp),
                    title:  Text(S.of(context).home),
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(CupertinoIcons.doc_text_fill),
                    title:  Text(S.of(context).myCourses),
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(CupertinoIcons.chat_bubble_text),
                    title:  Text(S.of(context).notification),
                  ),
                  FlashyTabBarItem(
                    icon: const Icon(Icons.calendar_month_outlined),
                    title:  Text(S.of(context).calender),
                  ),    FlashyTabBarItem(
                    icon: const Icon(CupertinoIcons.person),
                    title: Text(S.of(context).profile),
                  ),
                ],
              ),
              body: pages[dashBoardProvider.selectedIndex]
            ),
          );
        }
    );
  }
}
