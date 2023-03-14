import 'package:easy_grade/provider/profile_provider.dart';
import 'package:easy_grade/widgets/app_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/color_constant.dart';
import '../../generated/l10n.dart';
import '../../utills/app_validation.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image_assets.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_call_super
  void initState() {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProfileProvider profileProvider, _) {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: ColorConstant.appWhite,
              appBar: AppBar(
                backgroundColor: ColorConstant.appWhite,
                iconTheme: const IconThemeData(
                  color: ColorConstant.appBlack,
                ),
                elevation: 0.0,
                title:  AppText(
                  text: S.of(context).fillYourProfile,
                  textColor: ColorConstant.appThemeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ColorConstant.appBlue, width: 2)),
                              margin: const EdgeInsets.only(top: 15, bottom: 18),
                              height: 125,
                              width: 125,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child:
                                profileProvider.profileImage != null
                                    ? Image.file(
                                        profileProvider.profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : profileProvider.networkImg != null && profileProvider.networkImg != '' ?
                                AppImageAsset(
                                           image: profileProvider.networkImg!,
                                            webFit: BoxFit.cover,
                                        isWebImage: true,
                                          ) :
                                const AppImageAsset(
                                 image : AppAsset.profileLogo,
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  profileProvider.selectImage(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstant.appBlue),
                                    child: const Icon(
                                      Icons.edit,
                                      color: ColorConstant.appWhite,
                                      size: 20,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppTextField(
                        controller: profileProvider.nameController,
                        hint:  S.of(context).enterName,
                        label: S.of(context).name,
                        validator: (value) =>
                            emptyValidator(value!, S.of(context).nameIsRequired),
                      ),

                      AppTextField(
                        enableInteractiveSelection: false,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1965),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            if (kDebugMode) {
                              print(pickedDate);
                            }
                            setState(() {
                              profileProvider.dobController.text = pickedDate
                                  .toString()
                                  .substring(0,
                                      10); //set output date to TextField value.
                            });
                          } else {
                            if (kDebugMode) {
                              print("Date is not selected");
                            }
                          }
                        },
                        //validator: (value) => emptyValidator(value!, S.of(context).birthIsRequired),
                        controller: profileProvider.dobController,
                        hint: S.of(context).enterBirthdate,
                        label: S.of(context).birthdate,
                      ),
                      AppTextField(
                        controller: profileProvider.emailController,
                        keyboardType: TextInputType.emailAddress,
                        hint: S.of(context).enterEmail,
                        label: S.of(context).email,
                        // readOnly: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstant.appBlue)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstant.appGrey))),
                          hint: profileProvider.dropDownValue == null
                              ? const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: AppText(
                                    text: 'Select Gender',
                                    fontSize: 15,
                                    textColor: ColorConstant.appBlue,
                                    fontWeight: FontWeight.w300,
                                  ),
                              )
                              : Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AppText(
                                    text: profileProvider.dropDownValue!,
                                    textColor: ColorConstant.appBlue),
                              ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.blue),
                          items: ['Male', 'Female'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: AppText(
                                      text: val, textColor: ColorConstant.appBlue),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                profileProvider.dropDownValue = val as String?;
                              },
                            );
                          },
                        ),
                      ),
                      AppTextField(
                        keyboardType: TextInputType.number,
                        controller: profileProvider.phoneController,
                        hint: S.of(context).enterMobileNo,
                        label: S.of(context).mobileNo,
                        // validator: (value) => profileProvider.phoneController.text.isNotEmpty ? mobileValidator(value!,context) : null,
                      ),
                      AppTextField(
                        keyboardType: TextInputType.text,
                        controller: profileProvider.schoolNameController,
                        hint:  S.of(context).enterSchoolName,
                        label: S.of(context).schoolName,
                        // validator: (value) =>
                        //     emptyValidator(value!, S.of(context).schoolNameIsRequired),
                      ),
                      AppTextField(
                        keyboardType: TextInputType.text,
                        controller: profileProvider.subdivisionController,
                        hint: S.of(context).enterSubDivision,
                        label: S.of(context).subDivision,
                        // validator: (value) =>
                        //     emptyValidator(value!, S.of(context).subdivisionIsRequired),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                        onTap: () async {
                          if(_formKey.currentState!.validate()) {
                            profileProvider.updateUser(context);
                          }
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        buttonText: S.of(context).save,


                      ),
                    ],
                  ),
                ),
              )),
          profileProvider.isLoading ? const AppLoader() : Container()
        ],
      );
    });
  }
}
