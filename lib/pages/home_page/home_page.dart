import 'dart:developer';
import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/pages/community_page/community_page.dart';
import 'package:easy_grade/pages/help_center.dart';
import 'package:easy_grade/pages/intro_page/intro_page.dart';
import 'package:easy_grade/provider/community_provider.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../provider/course_provider.dart';
import '../../shared_preference/shared_preference.dart';
import '../../utills/app_logs.dart';
import '../../widgets/app_image_assets.dart';
import '../../widgets/app_loader.dart';
import '../change_password_page.dart';
import '../course_detail_page/course_detail_page.dart';
import '../download_page/download_course_page.dart';
import '../my_course/my_course.dart';
import '../../widgets/app_button.dart';
import '../../provider/privacy_policy.dart';
import '../splash_page/splash_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<String> newListOption = [];
  String? selectedLanguage;

  searchCourse(String value) {

    if (value.isNotEmpty) {
      List<String> searchTemp = [];
      CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
      for (var element in courseProvider.myCourseDetail) {
        if (element.topicName
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase())) {
          searchTemp.add('${element.topicName} : ${element.id} : ${element.image} ');
        }
      }
      newListOption = searchTemp;
      return newListOption;
    }
    log('newListOption --> $newListOption');
  }

  void changeLanguage(String localization) {
    switch (localization) {
      case 'English':
        S.load(const Locale.fromSubtags(countryCode: 'US', languageCode: 'en'));
        break;
      case 'French':
        S.load(const Locale.fromSubtags(countryCode: 'CA', languageCode: 'fr'));
        break;
      default:
        S.load(const Locale.fromSubtags(countryCode: 'US', languageCode: 'en'));
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
    CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
    if(courseProvider.myCourseDetail.isEmpty){
      courseProvider.getCourse(context);
    }
  }

  getLanguage() async {
    var value = await getPrefStringValue("local");
    if (value == null) {
      selectedLanguage = "English";
    } else {
      selectedLanguage = value;
    }
    changeLanguage(selectedLanguage!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    List<GridItem> gridViewList = [
      GridItem(
        title: S.of(context).myCourses,
        image: AppAsset.myCourseGif,
        color: ColorConstant.appThemeLight,
      ),
      GridItem(
          title:S.of(context).downloads,
          image: AppAsset.downloadGif,
          color: const Color(0xFF62d7a2)),
      GridItem(
          title:S.of(context).qrScanner,
          image: AppAsset.qrCodeGif,
          color: const Color(0xFF6bc6f3)),
      GridItem(
          title:S.of(context).community,
          image: AppAsset.communityGif,
          color: const Color(0xFFf06e92)),
    ];

    return Scaffold(
      backgroundColor: ColorConstant.appWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: ColorConstant.appBlack,
        ),
        elevation: 0.0,
        toolbarHeight: 80,
        backgroundColor: ColorConstant.appWhite,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                focusColor: Colors.white,
                value: selectedLanguage,
                elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: ["English", "French"]
                    .map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value!,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    logs('Value --> $value');
                    changeLanguage(value!);
                    selectedLanguage = value;
                    removePrefValue('local');
                    setPrefStringValue("local", selectedLanguage);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      drawer: myDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "${S.of(context).hi}${userInfo?.name}",
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
            const SizedBox(height: 10),
            AppText(
              text: S.of(context).findMsg,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              textColor: ColorConstant.appGrey,
            ),
            const SizedBox(height: 20),
            TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: S.of(context).search,
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorConstant.appLightBlue,width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                      // borderSide: BorderSide(color: ColorConstant.appGrey,width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:  ColorConstant.appThemeLight),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: ColorConstant.appWhite,
                        )),
                    hintStyle: TextStyle(
                      color: ColorConstant.appThemeColor.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 16, 0, 0),
                  ),
                ),
                noItemsFoundBuilder: (context) {
                  return  ListTile(
                    title: Text(
                      S.of(context).noCourseAvailable,
                      style: const TextStyle(
                        color: ColorConstant.appThemeColor,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  searchController.clear();
                  List<String> arr = suggestion.toString().split(' : ');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                              name: arr[0],
                              topicId:arr[1],
                              topicImage: arr[2],
                          )));
                },
                hideOnError: true,
                itemBuilder: (context, itemData) => ListTile(
                  title: Text( itemData.toString().split(' : ').first.trim()),
                ),
                suggestionsCallback: (pattern) => searchCourse(pattern)
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                AppText(
                  text: S.of(context).dashboard,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (0.45 / 0.5),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: gridViewList.length,
                  itemBuilder: (context1, index) {
                    return InkWell(
                      onTap: () async {
                        if(index == 0){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyCourse()));
                        }
                        else if(index == 1) {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  const DownloadCoursePage()));
                        }
                        else if(index ==2){
                          String barcodeScanRes;
                          try {
                            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                '#2753f4', 'Cancel', false, ScanMode.QR);
                            logs("barcode: $barcodeScanRes");
                          } on PlatformException {
                            barcodeScanRes = 'Failed to get platform version.';
                          }
                          if(barcodeScanRes.isNotEmpty && barcodeScanRes != '-1') {
                            CourseProvider courseProvider =
                            Provider.of<CourseProvider>(this.context, listen: false);
                            courseProvider.addCourse(this.context,barcodeScanRes);
                          }
                        } else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  const CommunityPage()));
                        }
                        },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: gridViewList[index].color!, width: 1),
                          color: gridViewList[index].color,
                          //gridViewList[index].color,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6, top: 12),
                              child: AppText(
                                letterSpacing: 1,
                                textColor: ColorConstant.appWhite,
                                text: gridViewList[index].title,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            AppImageAsset(
                              image: gridViewList[index].image.toString(),
                              width:  index == 0 ? 125 :105,
                              height: index == 0 ? 125 :105,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  myDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: ColorConstant.appThemeLight,
            ),
            child:AppImageAsset(
              image: AppAsset.appLogo,
              fit: BoxFit.contain,
              height: 45,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.policy,color: ColorConstant.appThemeColor,size: 22,),
            horizontalTitleGap: -5,
            title:  AppText(text: S.of(context).privacyPolicy),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrivacyPolicy()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.live_help,color: ColorConstant.appThemeColor,size: 22,),
            horizontalTitleGap: -5,
            title:  AppText(text:S.of(context).helpCenter),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HelpCenter()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_open,color: ColorConstant.appThemeColor,size: 22,),
            horizontalTitleGap: -5,
            title:  AppText(text:S.of(context).changePassword),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete,color: ColorConstant.appThemeColor,size: 22,),
            horizontalTitleGap: -5,
            title: AppText(text:S.of(context).deleteAccount),
            onTap: () {
              Navigator.pop(context);
              deleteAccount();
            },
          ),
          ListTile(
            leading: const Icon(Icons.login_outlined,color: ColorConstant.appThemeColor,size: 22,),
            horizontalTitleGap: -5,
            title:  AppText(text:S.of(context).logout),
            onTap: () {
              Navigator.pop(context);
              showBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: ColorConstant.appWhite,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  AppText(
                    text: S.of(context).logout,
                    fontSize: 18,
                    textColor: Colors.red,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: AppText(
                        text: S.of(context).msgLogout,
                        textColor: ColorConstant.appBlack,
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: AppWithoutBgButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          textColor: ColorConstant.appBlue,
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                          buttonText:S.of(context).cancel,
                        ),
                      ),
                      Expanded(
                          child: AppButton(
                              onTap: () async {
                               // CourseProvider courseProvider =
                                // Provider.of<CourseProvider>(context, listen: false);
                                // courseProvider.myCourseDetail.clear();
                                // CommunityProvider communityProvider=
                                // Provider.of<CommunityProvider>(context, listen: false);
                                // communityProvider.userCommunityList.clear();
                                final tasks = await FlutterDownloader.loadTasks();
                                tasks?.forEach((element) async {
                                  await FlutterDownloader.remove(
                                    taskId: element.taskId,
                                    shouldDeleteContent: true,
                                  );
                                });
                                await removePrefValue(userKey);
                                await removePrefValue(downloadList);
                                myVideo.clear();
                                await GoogleSignIn().signOut();
                                await  FacebookAuth.instance.logOut();
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(this.context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (c) => const IntroPage()),
                                        (route) => false);
                              },
                              buttonText: S.of(context).yesLogout,
                              borderRadius: 30,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  deleteAccount() {
    return showModalBottomSheet(
        backgroundColor: ColorConstant.appWhite,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (context) {
          CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  AppText(
                    text: S.of(context).deleteAccount,
                    fontSize: 18,
                    textColor: Colors.red,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: AppText(
                        text:
                        S.of(context).deleteAccountMsg,
                        textColor: ColorConstant.appBlack,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: AppWithoutBgButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          textColor: ColorConstant.appBlue,
                          borderColor: Colors.transparent,
                          borderRadius: 30,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          buttonColor: ColorConstant.appBlue.withOpacity(0.2),
                          buttonText:S.of(context).cancel,
                        ),
                      ),
                      Expanded(
                          child: AppButton(
                              onTap: () async {
                                return await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => StatefulBuilder(builder: (context, setState) {
                                   return   AlertDialog(
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
                                          child:  AppText(
                                            text: S.of(context).delete,
                                            textColor: ColorConstant.appWhite,
                                          ),
                                        ),
                                        content: AppText(
                                          text: S.of(context).deleteAccountSureMsg,
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                        ),
                                        actions: [
                                          courseProvider.isLoading ? const AppLoader() : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              AppButton(
                                                height: 40,
                                                width: 80,
                                                buttonText: S.of(context).no,
                                                fontSize: 12,
                                                borderRadius: 10,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                               AppButton(
                                                height: 40,
                                                width: 80,
                                                buttonText: S.of(context).yes,
                                                fontSize: 12,
                                                borderRadius: 10,
                                                onTap: () async {
                                                  CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
                                                  setState(() => courseProvider.isLoading =true);
                                                  await  courseProvider.deleteAccount(context);
                                                  setState(() => courseProvider.isLoading = false);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                  })
                                );
                              },
                              buttonText: S.of(context).ok,
                              borderRadius: 30,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class GridItem {
  String? image;
  String? title;
  Color? color;

  GridItem({this.title, this.image,this.color});
}
