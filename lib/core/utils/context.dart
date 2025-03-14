import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Helper on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall?.copyWith();

  TextStyle? get labelSmallBold => labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get labelMedium =>
      Theme.of(this).textTheme.labelMedium?.copyWith();
  TextStyle? get labelMediumBold => labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge?.copyWith();

  TextStyle? get labelLargeBold => labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall?.copyWith(
        fontSize: 14.sp,
      );
  TextStyle? get bodySmallBold => bodySmall?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
      );
  TextStyle? get bodySmallSemiBold => bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
      );
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium?.copyWith(
        fontSize: 16.sp,
      );
  TextStyle? get bodyMediumBold => bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16.sp,
      );

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge?.copyWith(
        fontSize: 18.sp,
      );
  TextStyle? get bodyLargeBold => bodyLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      );
  TextStyle? get headlineLarge =>
      Theme.of(this).textTheme.headlineLarge?.copyWith(
            fontSize: 24.sp,
          );
  TextStyle? get headlineLargeBold => headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get headlineMedium =>
      Theme.of(this).textTheme.headlineMedium?.copyWith(
            fontSize: 22.sp,
          );
  TextStyle? get headlineMediumBold => headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get headlineSmall =>
      Theme.of(this).textTheme.headlineSmall?.copyWith(
            fontSize: 20.sp,
          );
  TextStyle? get headlineSmallBold => headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get displayLarge =>
      Theme.of(this).textTheme.displayLarge?.copyWith();

  TextStyle? get displayLargeBold => displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get displayMedium =>
      Theme.of(this).textTheme.displayMedium?.copyWith();
  TextStyle? get displayMediumBold => displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get displaySmall =>
      Theme.of(this).textTheme.displaySmall?.copyWith();
  TextStyle? get displaySmallBold => displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge?.copyWith();
  TextStyle? get titleLargeBold => titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get titleMedium =>
      Theme.of(this).textTheme.titleMedium?.copyWith();
  TextStyle? get titleMediumBold => titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      );
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall?.copyWith();

  TextStyle? get titleSmallBold => titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      );

  //Desktop or Mobile or tablet

  bool get isDesktop => MediaQuery.of(this).size.width > 800;
  bool get isMobile => MediaQuery.of(this).size.width < 800;
  bool get isTablet =>
      MediaQuery.of(this).size.width > 800 &&
      MediaQuery.of(this).size.width < 1200;

  double get width => MediaQuery.of(this).size.width;
}

extension TextThemeHelper on TextTheme {
  TextStyle? get tableBody => bodyMedium?.copyWith(fontSize: 12);
}
