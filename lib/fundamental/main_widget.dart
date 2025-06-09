import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MainWidget {
  Widget text({
    required String data,
    bool? softWrap,
    TextStyle? style,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    softWrap ??= true;
    style ??= GoogleFonts.poppins();
    textAlign ??= TextAlign.center;
    color ??= Colors.black;

    return Text(
      data,
      softWrap: softWrap,
      style: style.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }

  Widget gap({double? height, double? width}) {
    return SizedBox(height: height, width: width);
  }

  Widget button({
    required Function() onPressed,
    required Widget child,
    Function()? onLongPress,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    Color? borderColor,
    double? borderWidth,
    bool? enabled,
  }) {
    backgroundColor ??= Colors.blue;
    borderRadius ??= BorderRadius.circular(16);
    borderColor ??= backgroundColor;
    borderWidth ??= 1.0;
    enabled ??= true;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      onLongPress: enabled ? onLongPress : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        elevation: elevation,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      child: child,
    );
  }

  Widget field({
    required TextEditingController controller,
    Color? cursorColor,
    String? initialValue,
    TextInputType? keyboardType,
    int? maxLength,
    Function(String)? onChanged,
    bool? readOnly,
    String? Function(String?)? validator,
    EdgeInsetsGeometry? contentPadding,
    InputBorder? enabledBorder,
    InputBorder? errorBorder,
    TextStyle? errorStyle,
    Color? fillColor,
    InputBorder? focusedBorder,
    InputBorder? focusedErrorBorder,
    bool? isDense,
    Widget? label,
    Widget? prefix,
    Widget? suffix,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    List<TextInputFormatter>? inputFormatters,
  }) {
    cursorColor ??= Colors.black;
    isDense ??= true;
    readOnly ??= false;
    fillColor ??= Colors.white;
    textColor ??= Colors.black;
    fontSize ??= 12;

    errorStyle ??= GoogleFonts.poppins(fontSize: 10, color: Colors.red);

    enabledBorder ??= OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.black, width: 1),
      gapPadding: 5,
    );

    errorBorder ??= OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.red, width: 1),
      gapPadding: 5,
    );

    focusedBorder ??= OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.black, width: 2),
      gapPadding: 5,
    );

    focusedErrorBorder ??= OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.red, width: 2),
      gapPadding: 5,
    );

    void onTapOutside(PointerDownEvent _) {
      FocusManager.instance.primaryFocus!.unfocus();
    }

    return TextFormField(
      controller: controller,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        enabledBorder: enabledBorder,
        errorBorder: errorBorder,
        errorStyle: errorStyle,
        fillColor: fillColor,
        filled: true,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        isDense: isDense,
        label: label,
        prefixIcon: prefix,
        suffixIcon: suffix,
        counterStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      style: GoogleFonts.poppins(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      readOnly: readOnly,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  Widget checkBox({
    required bool value,
    required Function(bool?) onChanged,
    Color? activeColor,
    Color? checkColors,
  }) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      checkColor: checkColors,
    );
  }
}

MainWidget get w => MainWidget();
