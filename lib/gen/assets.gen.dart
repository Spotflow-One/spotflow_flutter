/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/check-icon.svg
  SvgGenImage get checkIcon => const SvgGenImage('assets/svg/check-icon.svg');

  /// File path: assets/svg/copy-icon.svg
  SvgGenImage get copyIcon => const SvgGenImage('assets/svg/copy-icon.svg');

  /// File path: assets/svg/dotted-circle.svg
  SvgGenImage get dottedCircle =>
      const SvgGenImage('assets/svg/dotted-circle.svg');

  /// File path: assets/svg/info-circle.svg
  SvgGenImage get infoCircle => const SvgGenImage('assets/svg/info-circle.svg');

  /// File path: assets/svg/pay-with-card-icon.svg
  SvgGenImage get payWithCardIcon =>
      const SvgGenImage('assets/svg/pay-with-card-icon.svg');

  /// File path: assets/svg/pay-with-transfer-icon.svg
  SvgGenImage get payWithTransferIcon =>
      const SvgGenImage('assets/svg/pay-with-transfer-icon.svg');

  /// File path: assets/svg/pay-with-usd-icon.svg
  SvgGenImage get payWithUsdIcon =>
      const SvgGenImage('assets/svg/pay-with-usd-icon.svg');

  /// File path: assets/svg/shield.svg
  SvgGenImage get shield => const SvgGenImage('assets/svg/shield.svg');

  /// File path: assets/svg/ussd-icon.svg
  SvgGenImage get ussdIcon => const SvgGenImage('assets/svg/ussd-icon.svg');

  /// File path: assets/svg/warning.svg
  SvgGenImage get warning => const SvgGenImage('assets/svg/warning.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        checkIcon,
        copyIcon,
        dottedCircle,
        infoCircle,
        payWithCardIcon,
        payWithTransferIcon,
        payWithUsdIcon,
        shield,
        ussdIcon,
        warning
      ];
}

class Assets {
  Assets._();

  static const String package = 'spotflow';

  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  static const String package = 'spotflow';

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/spotflow/$_assetName';
}
