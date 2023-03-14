import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../provider/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getNotification(context);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, NotificationProvider notificationProvider, _) {
      return Scaffold(
          // backgroundColor: ColorConstant.appWhite,
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(
              color: ColorConstant.appBlack,
            ),
            backgroundColor: ColorConstant.appWhite,
            title: AppText(
              text:  S.of(context).notification,
              textColor: ColorConstant.appThemeColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          body: Stack(
            children: [
              notificationList(notificationProvider),
              notificationProvider.isLoading ? const AppLoader() : const SizedBox()
            ],
          )
      );
    });
  }

  notificationList(NotificationProvider notificationProvider) {
    return AnimationLimiter(
      child: ListView.builder(
        // padding: const EdgeInsets.only(
        //   left: 20,
        // ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: notificationProvider.notification.length,
        itemBuilder: (BuildContext c, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 50),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300.0,
              child: FlipAnimation(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  flipAxis: FlipAxis.y,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorConstant.appWhite,
                    ),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: ListTile(
                      leading:
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: SizedBox(
                          height: 100,
                          width: 80,
                          child: notificationProvider.notification[index].image == null
                              ? const AppImageAsset(image :AppAsset.appLogo,fit: BoxFit.fill)
                              : AppImageAsset(
                                isWebImage: true,
                                image :notificationProvider.notification[index].image,
                                  webFit: BoxFit.fill),
                        ),
                      ),
                      title: AppText(
                        text: notificationProvider.notification[index].title,
                        fontSize: 15,
                        textColor: ColorConstant.appBlack,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: notificationProvider.notification[index].description!,
                            textColor: ColorConstant.appGrey,
                            fontSize: 12,
                          ),
                          AppText(
                            text: DateFormat('dd-MM-yyyy').format(notificationProvider.notification[index].createdAt!),
                            textColor: ColorConstant.appGrey,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}
