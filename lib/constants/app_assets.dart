class AppAssets {
  const AppAssets._();

  /// `Folder: assets/svg`
  static const svg = _AppAssetsSvg();

  /// `Folder: assets/images`
  static const images = _AppAssetsImages();
}

class _AppAssetsSvg {
  const _AppAssetsSvg();

  /// `File: assets/svg/glyph.svg`
  final glyphSvg = "assets/svg/glyph.svg";
}

class _AppAssetsImages {
  const _AppAssetsImages();

  /// `File: assets/images/app-icon-background.png`
  final appIconBackgroundPng = "assets/images/app-icon-background.png";

  /// `File: assets/images/app-icon.png`
  final appIconPng = "assets/images/app-icon.png";

  /// `File: assets/images/app-icon-foreground.png`
  final appIconForegroundPng = "assets/images/app-icon-foreground.png";
}
