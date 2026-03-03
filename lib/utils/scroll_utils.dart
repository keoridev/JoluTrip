class ScrollUtils {
  static double calculateCollapseProgress(
      double scrollOffset, double expandedHeight, double toolbarHeight) {
    return (scrollOffset / (expandedHeight - toolbarHeight)).clamp(0.0, 1.0);
  }

  static double calculateParallaxOffset(
      double scrollOffset, double factor, double maxOffset) {
    return (scrollOffset * factor).clamp(0.0, maxOffset);
  }

  static double calculateGradientOpacity(
      double progress, double baseOpacity, double progressFactor) {
    return (baseOpacity + progress * progressFactor).clamp(0.0, 0.9);
  }

  static double calculateHeaderOpacity(double progress, double factor) {
    return (1.0 - progress * factor).clamp(0.0, 1.0);
  }

  static double calculateTitleOpacity(
      double progress, double threshold, double factor) {
    return ((progress - threshold) / factor).clamp(0.0, 1.0);
  }

  static double calculateButtonOpacity(double progress, double factor) {
    return (1.0 - progress * factor).clamp(0.0, 1.0);
  }
}
