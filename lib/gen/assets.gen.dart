/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/location.json
  String get location => 'packages/spotflow/assets/json/location.json';

  /// List of all assets
  List<String> get values => [location];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/arrow-left.svg
  SvgGenImage get arrowLeft => const SvgGenImage('assets/svg/arrow-left.svg');

  /// File path: assets/svg/bank-card-fill.svg
  SvgGenImage get bankCardFill =>
      const SvgGenImage('assets/svg/bank-card-fill.svg');

  /// File path: assets/svg/bank.svg
  SvgGenImage get bank => const SvgGenImage('assets/svg/bank.svg');

  /// File path: assets/svg/card.svg
  SvgGenImage get card => const SvgGenImage('assets/svg/card.svg');

  /// File path: assets/svg/check-icon.svg
  SvgGenImage get checkIcon => const SvgGenImage('assets/svg/check-icon.svg');

  /// File path: assets/svg/chevron-down.svg
  SvgGenImage get chevronDown =>
      const SvgGenImage('assets/svg/chevron-down.svg');

  /// File path: assets/svg/close-icon.svg
  SvgGenImage get closeIcon => const SvgGenImage('assets/svg/close-icon.svg');

  /// File path: assets/svg/copy-icon.svg
  SvgGenImage get copyIcon => const SvgGenImage('assets/svg/copy-icon.svg');

  /// File path: assets/svg/dotted-circle.svg
  SvgGenImage get dottedCircle =>
      const SvgGenImage('assets/svg/dotted-circle.svg');

  /// File path: assets/svg/green-check-icon.svg
  SvgGenImage get greenCheckIcon =>
      const SvgGenImage('assets/svg/green-check-icon.svg');

  /// File path: assets/svg/hashtag.svg
  SvgGenImage get hashtag => const SvgGenImage('assets/svg/hashtag.svg');

  /// File path: assets/svg/info-circle-black.svg
  SvgGenImage get infoCircleBlack =>
      const SvgGenImage('assets/svg/info-circle-black.svg');

  /// File path: assets/svg/info-circle.svg
  SvgGenImage get infoCircle => const SvgGenImage('assets/svg/info-circle.svg');

  /// File path: assets/svg/mc_symbol_1.svg
  SvgGenImage get mcSymbol1 => const SvgGenImage('assets/svg/mc_symbol_1.svg');

  /// File path: assets/svg/mobile.svg
  SvgGenImage get mobile => const SvgGenImage('assets/svg/mobile.svg');

  /// File path: assets/svg/pay-with-usd-icon.svg
  SvgGenImage get payWithUsdIcon =>
      const SvgGenImage('assets/svg/pay-with-usd-icon.svg');

  /// File path: assets/svg/shield.svg
  SvgGenImage get shield => const SvgGenImage('assets/svg/shield.svg');

  /// File path: assets/svg/visa_symbol_ic.svg
  SvgGenImage get visaSymbolIc =>
      const SvgGenImage('assets/svg/visa_symbol_ic.svg');

  /// File path: assets/svg/warning.svg
  SvgGenImage get warning => const SvgGenImage('assets/svg/warning.svg');

  /// File path: assets/svg/x-close.svg
  SvgGenImage get xClose => const SvgGenImage('assets/svg/x-close.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        arrowLeft,
        bankCardFill,
        bank,
        card,
        checkIcon,
        chevronDown,
        closeIcon,
        copyIcon,
        dottedCircle,
        greenCheckIcon,
        hashtag,
        infoCircleBlack,
        infoCircle,
        mcSymbol1,
        mobile,
        payWithUsdIcon,
        shield,
        visaSymbolIc,
        warning,
        xClose
      ];
}

class Assets {
  Assets._();

  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package = 'spotflow',
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package = 'spotflow',
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/spotflow/$_assetName';
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package = 'spotflow',
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/spotflow/$_assetName';
}
