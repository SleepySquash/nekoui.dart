import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application themes constants.
class Themes {
  /// Returns a light theme.
  static ThemeData light() {
    ThemeData theme = ThemeData.light();

    ColorScheme colors = theme.colorScheme.copyWith(
      primary: const Color(0xFF888888),
      onPrimary: Colors.white,
      secondary: Colors.blue,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
    );

    SystemChrome.setSystemUIOverlayStyle(colors.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);

    return theme.copyWith(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: colors.background,
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: colors.background,
          foregroundColor: colors.primary,
          iconTheme:
              theme.appBarTheme.iconTheme?.copyWith(color: colors.primary),
          actionsIconTheme:
              theme.appBarTheme.iconTheme?.copyWith(color: colors.primary),
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.blue,
            statusBarColor: Color(0xFFF8F8F8),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        tabBarTheme: theme.tabBarTheme.copyWith(
          labelColor: colors.secondary,
          unselectedLabelColor: colors.primary,
        ),
        primaryTextTheme: theme.primaryTextTheme
            .copyWith(headline6: TextStyle(color: colors.primary)),
        primaryIconTheme:
            const IconThemeData.fallback().copyWith(color: colors.primary),
        iconTheme: theme.iconTheme.copyWith(color: Colors.black),
        textTheme: GoogleFonts.balsamiqSansTextTheme(
          theme.textTheme.copyWith(
            headline3: TextStyle(color: colors.primary, fontSize: 30),
            headline4: TextStyle(color: colors.primary, fontSize: 24),
            headline5: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            caption: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 17,
            ),
            subtitle1: const TextStyle(color: Colors.black, fontSize: 15),
            subtitle2: const TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          focusColor: colors.secondary,
          hoverColor: colors.secondary,
          fillColor: colors.secondary,
          hintStyle: TextStyle(color: colors.primary),
          labelStyle: TextStyle(color: colors.primary),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
          errorMaxLines: 5,
          floatingLabelStyle: TextStyle(color: colors.primary),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: colors.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: colors.primary),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: colors.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: colors.primary),
          ),
        ),
        textSelectionTheme: theme.textSelectionTheme.copyWith(
          cursorColor: colors.secondary,
          selectionHandleColor: colors.secondary,
        ),
        floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
          backgroundColor: colors.secondary,
          foregroundColor: colors.onSecondary,
        ),
        bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
          backgroundColor: colors.background,
          selectedItemColor: colors.secondary,
          unselectedItemColor: colors.primary,
        ),
        progressIndicatorTheme:
            theme.progressIndicatorTheme.copyWith(color: colors.secondary),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          },
        ));
  }

  /// Returns a dark theme.
  static ThemeData dark() {
    /// TODO: Dark theme support.
    throw UnimplementedError();
  }
}

/// Shadow cast by a box that allows to customize its [blurStyle].
class CustomBoxShadow extends BoxShadow {
  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    BlurStyle blurStyle = BlurStyle.normal,
  })  : _blurStyle = blurStyle,
        super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
        );

  /// Style to use for blur in [MaskFilter] object.
  final BlurStyle _blurStyle;

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(_blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) {
        result.maskFilter = null;
      }
      return true;
    }());
    return result;
  }
}
