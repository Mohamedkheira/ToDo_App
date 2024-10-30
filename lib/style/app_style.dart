import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppStyle {
  static const Color primaryLightColor = Color(0xff5D9CEC);
  static const Color TextLightColor = Color(0xff383838);
  static const Color tertiaryColor= Color(0xff61E757);
  static ThemeData lightMode = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: const Color(0xffDFECDB),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLightColor,
      primary: primaryLightColor,
      tertiary:tertiaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLightColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.white,
          width: 4,
        )
      )
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: primaryLightColor,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize:17,
        color: Colors.white,
      ),
      labelLarge:  TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize:18,
        color: primaryLightColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize:12,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize:27,
        color: Colors.green
      ),
    )
  );
}
