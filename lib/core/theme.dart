/// Koyu, sakin arayüz: mavi vurgu, yeşil = kasılıyor.
library;

import 'package:flutter/material.dart';

abstract final class C {
  static const bg = Color(0xFF0A0E14);
  static const panel = Color(0xFF0F151D);
  static const surface = Color(0xFF131B25);
  static const surface2 = Color(0xFF1A2431);
  static const line = Color(0xFF222E3D);
  static const text = Color(0xFFEAF0F7);
  static const text2 = Color(0xFF9AA8BA);
  static const text3 = Color(0xFF5F6E82);
  static const blue = Color(0xFF4DA3FF);
  static const green = Color(0xFF3DDC97);
  static const amber = Color(0xFFF6B73C);
  static const red = Color(0xFFFF5D6C);
  static const heart = Color(0xFFFF6B9A);
}

const kFont = 'Poppins';
const kMono = 'PlexMono';

TextStyle mono(double size, {Color color = C.text, FontWeight w = FontWeight.w500}) =>
    TextStyle(fontFamily: kMono, fontSize: size, color: color, fontWeight: w, height: 1.1);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: kFont,
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(
      primary: C.blue,
      onPrimary: Colors.black,
      surface: C.surface,
      onSurface: C.text,
      error: C.red,
    ),
  );
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c, width: w));
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: C.text, displayColor: C.text, fontFamily: kFont),
    dividerColor: C.line,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.surface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: border(C.line),
      enabledBorder: border(C.line),
      focusedBorder: border(C.blue, 1.6),
      hintStyle: const TextStyle(color: C.text3, fontSize: 13.5),
      labelStyle: const TextStyle(color: C.text2, fontSize: 13.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: C.blue,
        foregroundColor: Colors.black,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: kFont, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.text,
        side: const BorderSide(color: C.line),
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: kFont, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: C.text2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontFamily: kFont, fontWeight: FontWeight.w600, fontSize: 13.5),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: C.panel,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: C.line)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.black : C.text2),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? C.blue : C.surface2),
      trackOutlineColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? C.blue : C.line),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        side: const WidgetStatePropertyAll(BorderSide(color: C.line)),
        backgroundColor:
            WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? C.blue.withValues(alpha: 0.18) : C.surface),
        foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? C.blue : C.text2),
        textStyle: const WidgetStatePropertyAll(TextStyle(fontFamily: kFont, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: C.surface2, borderRadius: BorderRadius.circular(8), border: Border.all(color: C.line)),
      textStyle: const TextStyle(fontFamily: kFont, color: C.text, fontSize: 12),
      waitDuration: const Duration(milliseconds: 400),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.surface2,
      contentTextStyle: const TextStyle(color: C.text, fontFamily: kFont, fontSize: 13.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: C.line)),
      width: 460,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(C.text3.withValues(alpha: 0.5)),
      thickness: const WidgetStatePropertyAll(6),
      radius: const Radius.circular(8),
    ),
  );
}
