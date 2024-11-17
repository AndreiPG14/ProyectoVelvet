import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';

var colorList = <Color>[Color.fromARGB(255, 168, 76, 175), Colors.white];
const scaffoldBackgroundColor = Color(0xFFFFFFFF);
const scaffoldBackgroundColorDark = Color.fromARGB(255, 37, 36, 36);
final themeProvider = Provider<ThemeData>((ref) {
  final user = ref.watch(authProvider).user;

  if (user != null) {
    return AppTheme(selectedColor: 1).getTheme();
  } else {
    return AppTheme(selectedColor: 0).getTheme();
  }
});

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < colorList.length);

  ThemeData getTheme() => ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
      primaryColorLight: colorList[selectedColor],
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorList[selectedColor],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
              backgroundColor:
                  MaterialStateProperty.all(colorList[selectedColor]))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
        foregroundColor: MaterialStateProperty.all(colorList[selectedColor]),
      )),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontSize: 14.4,
          color: Colors.black54,
          fontWeight: FontWeight.w300,
        ),
        labelMedium: TextStyle(
          fontSize: 17.1,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ));
}
