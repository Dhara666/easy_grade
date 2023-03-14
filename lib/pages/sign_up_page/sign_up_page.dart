import 'dart:io';

import 'package:easy_grade/constant/color_constant.dart';
import 'package:easy_grade/pages/sign_in_page/sign_in_page.dart';
import 'package:easy_grade/provider/signup_provider.dart';
import 'package:easy_grade/widgets/app_image_assets.dart';
import 'package:easy_grade/widgets/app_text.dart';
import 'package:easy_grade/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../provider/signin_provider.dart';
import '../../utills/app_logs.dart';
import '../../utills/app_validation.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer(builder: (context, SignUpProvider signUpProvider, _) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: ColorConstant.appWhite,
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: ColorConstant.appWhite,
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 30, right: 30,top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     AppText(
                      text: S.of(context).hi1,
                      fontWeight: FontWeight.w600,
                      fontSize: 40,
                    ),
                    SizedBox(height: height * 0.01),
                     AppText(
                      text: S.of(context).createNewAccount,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      textColor: ColorConstant.appThemeLight,
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                        controller: signUpProvider.nameController,
                        hint: S.of(context).enterName,
                        validator: (value) =>
                            emptyValidator(value!, S.of(context).nameIsRequired)),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      controller: signUpProvider.emailController,
                      hint: S.of(context).enterEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => emailValidator(value!, context),
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      controller: signUpProvider.phoneController,
                      hint:  S.of(context).enterMobileNo,
                      keyboardType: TextInputType.number,
                      // validator: (value) => mobileValidator(value!, context),
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      controller: signUpProvider.schoolNameController,
                      hint:  S.of(context).enterSchoolName,
                      keyboardType: TextInputType.text,
                      // validator: (value) =>
                      //     emptyValidator(value!, S.of(context).schoolNameIsRequired),
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      controller: signUpProvider.subDivisionController,
                      hint: S.of(context).enterSubDivision,
                      keyboardType: TextInputType.text,
                      // validator: (value) =>
                      //     emptyValidator(value!, S.of(context).subdivisionIsRequired),
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      enableInteractiveSelection: false,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1965),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          signUpProvider.dobController.text =
                              pickedDate.toString().substring(0, 10);
                          // ignore: invalid_use_of_protected_member
                          signUpProvider.notifyListeners();
                        } else {
                          logs("Date is not selected");
                        }
                      },
                      controller: signUpProvider.dobController,
                      hint: S.of(context).enterBirthdate,
                      // validator: (value) =>
                      //     emptyValidator(value!, S.of(context).birthIsRequired),
                    ),
                    SizedBox(height: height * 0.010),
                    AppTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: signUpProvider.passwordController,
                      hint: S.of(context).enterPassword,
                      obscureText: true,
                      validator: (value) => passwordValidator(value!, context),
                    ),
                    SizedBox(height: height * 0.05),
                    AppButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          signUpProvider.signUpUser(context);
                        }
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      buttonText: S.of(context).signUp,
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 1,
                          color: ColorConstant.appGrey,
                        )),
                         AppText(
                          text: S.of(context).or,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        Expanded(
                            child: Container(
                                height: 1, color: ColorConstant.appGrey)),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                     Center(
                        child: AppText(
                      text: S.of(context).socialMediaLogin,
                      textColor: ColorConstant.appThemeLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              SignInProvider signInProvider =
                                  Provider.of<SignInProvider>(context,
                                      listen: false);
                              await signInProvider.signWithGoogle(context);
                            },
                            child: const AppImageAsset(
                              image: AppAsset.googleLogo,
                              height: 35.0,
                              width: 35,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () async {
                              SignInProvider signInProvider =
                                  Provider.of<SignInProvider>(context,
                                      listen: false);
                              await signInProvider.signInWithFacebook(context);
                            },
                            child: const AppImageAsset(
                              image: AppAsset.facebookLogo,
                              height: 35.0,
                              width: 35,
                            ),
                          ),
                           SizedBox(width: Platform.isIOS ?  25 :0),
                          Platform.isIOS ?
                          InkWell(
                            onTap: () async {
                              print("----->Ios Login");
                              SignInProvider signInProvider =
                              Provider.of<SignInProvider>(context,
                                  listen: false);
                              await signInProvider.signInWithApple(context);
                            },
                            child: const AppImageAsset(
                              image: AppAsset.appleLogo,
                              height: 35.0,
                              width: 35,
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      children: [
                         AppText(
                            text: S.of(context).alreadyHaveAccount,
                            textColor: ColorConstant.appThemeLight),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInPage()));
                            },
                            child:  Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 10),
                              child: AppText(
                                text: S.of(context).signIn,
                                textColor: const Color(0xFF3c00f3),
                                fontWeight: FontWeight.w600,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          signUpProvider.isLoading ? const AppLoader() : const SizedBox()
        ],
      );
    });
  }
}
