import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_app/utils/app_colors.dart';

class AppTheme {
  static ThemeData myTheme = ThemeData(
      // primaryColor:
      scaffoldBackgroundColor: AppColors.scaffoldColor,
      appBarTheme: AppBarTheme(color: AppColors.lightBlue),
      textTheme: TextTheme(
          bodySmall:
              GoogleFonts.poppins(fontSize: 15, color: AppColors.darkBlue),
          displaySmall: GoogleFonts.poppins(fontSize: 15, color: AppColors.white,fontWeight: FontWeight.bold),
              ),
      // buttonTheme: ButtonThemeData(
      //     buttonColor: AppColors.lightBlue, focusColor: AppColors.lightBlue),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.lightBlue),
            textStyle: WidgetStatePropertyAll(GoogleFonts.poppins(fontSize: 15,
                color: AppColors.white, fontWeight: FontWeight.bold)
                )),
      ),
      );
}
