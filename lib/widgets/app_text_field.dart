import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/color_constant.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;

  final TextInputType keyboardType;
  final String? hint;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final  GestureTapCallback? onTap;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final int maxLines;
  final EdgeInsetsGeometry margin;
  final bool autofocus;
  final Color? fillColor;

  const AppTextField({
    Key? key,
    this.controller,
    this.keyboardType = TextInputType.text,
    @required this.hint,
    this.label,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.enableInteractiveSelection = true,
    this.enabledBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.errorBorder,
    this.maxLines =1,
    this.margin= const EdgeInsets.only(top: 8,bottom: 8,right: 20),
    this.autofocus = false,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        autofocus: autofocus,
        enableInteractiveSelection : enableInteractiveSelection,
        onTap: onTap,
        obscureText: obscureText,
        readOnly: readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: ColorConstant.appThemeColor,
        cursorWidth: 1,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        style:  const TextStyle(fontSize: 15,color:ColorConstant.appBlue,fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint!,
          labelStyle: const TextStyle(fontSize: 15),
          hintStyle: const TextStyle(fontSize: 15, color:ColorConstant.appBlue,fontFamily: AppAsset.defaultFont,fontWeight: FontWeight.w400),
          filled: true,
          fillColor: fillColor ?? ColorConstant.appWhite,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
          enabledBorder: enabledBorder ?? const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.appGrey,width: 1),
         ),
          focusedBorder: focusedBorder ?? const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstant.appBlue,width: 1),
          ),
          errorBorder: errorBorder ?? const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red,width: 1),
          ),
          focusedErrorBorder: focusedErrorBorder ?? const UnderlineInputBorder(
               borderSide: BorderSide(color: Colors.red,width: 1)),
          // border: appOutlineInputBorder(),
          // disabledBorder:appOutlineInputBorder(),
          // enabledBorder: appOutlineInputBorder(),
          // errorBorder: appOutlineInputBorder(
          //     color: Colors.red),
          // focusedBorder: appOutlineInputBorder(
          //     color: ColorConstant.appThemeColor),
        ),
      ),
    );
  }

  static OutlineInputBorder appOutlineInputBorder({Color? color}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: color ?? ColorConstant.appBlue,width: 1),
      );
}

