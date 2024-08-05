
import '../core/utils/constant/error_message.dart';

class ValidatorHelper {
  required(value) {
    print(value);
    if (value == null || value.isEmpty) {
      print("message");
      return ErrorMessageConstant.required;
    } else {
      return null;
    }
  }

  validPasswordFormat(String value) {
    if (value == "" || value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (value.length < 6) {
      return ErrorMessageConstant.lessThan6Characters;
    }
    return null;
  }

  validEmailAddressFormat(String value) {
    RegExp format = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (value == "" || value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (!format.hasMatch(value)) {
      return ErrorMessageConstant.invalidEmailFormat;
    }
    return null;
  }

  validConfirmPasswordFormat(String value, String compareValue) {
    if (value != compareValue) {
      return ErrorMessageConstant.passwordNotMatch;
    }
    return null;
  }

  validPhoneNumberFormat(String value, int minLength, int maxLength) {
    print(value.length);
    if (value == "" && value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (value.length <= minLength || value.length >= maxLength) {
      return ErrorMessageConstant.invalidMobileFormat;
    }
    return "";
  }

  validAge(String value) {
    if (value == "" && value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (value.length >= 150) {
      return ErrorMessageConstant.invalidAge;
    }
    return "";
  }

  validNumber(String value) {
    RegExp format = RegExp(r'^-?[0-9]+$');
    if (value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (!format.hasMatch(value)) {
      return ErrorMessageConstant.invalidNumber;
    }
    return "";
  }

  validDoubleNumber(String value) {
    RegExp format = RegExp(r'^-?[0-9]*\.?[0-9]+$');
    if (value.isEmpty) {
      return ErrorMessageConstant.required;
    } else if (!format.hasMatch(value)) {
      return ErrorMessageConstant.invalidNumber;
    }
    return "";
  }
}
