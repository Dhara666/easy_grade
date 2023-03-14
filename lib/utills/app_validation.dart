
import '../generated/l10n.dart';

class AppValidation {
  static String namePattern = r'^[a-zA-Z]+$';
  static String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String mobilePattern = r'(^(?:[+0]9)*[0-9]{9}$)';
}

emptyValidator(String name,String errorMsg){
  if(name.isEmpty){
    return errorMsg;
  }
  return null;
}

emailValidator(String value,context){
  if (value.isEmpty) {
    return S.of(context).emailIsRequired;
  }
  if (!RegExp(AppValidation.emailPattern)
      .hasMatch(value)) {
    return S.of(context).validEmail;
  }
  return null;
}

mobileValidator(String value,context){
  if (value.isEmpty) {
    return S.of(context).mobileIsRequired;
  }
  if (!RegExp(AppValidation.mobilePattern)
      .hasMatch(value)) {
    return  S.of(context).validMobileNo;
  }
  return null;
}

passwordValidator(String value,context){
  if (value.isEmpty) {
    return S.of(context).passRequired;
  }
  if (value.length < 6) {
    return S.of(context).validPassword;
  }
  return null;
}