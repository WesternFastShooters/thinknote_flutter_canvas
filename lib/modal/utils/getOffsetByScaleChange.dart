import 'dart:ui';

Offset getOffsetByScaleChange({
  required Offset center,
  required Offset curCanvasOffset,
  required double curCanvasScale,
  required double preCanvasScale,
}) {
  double thisTimeCanvasOffsetX = -(center.dx - curCanvasOffset.dx) *
      (curCanvasScale - preCanvasScale) /
      preCanvasScale;
  double thisTimeCanvasOffsetY = -(center.dy - curCanvasOffset.dy) *
      (curCanvasScale - preCanvasScale) /
      preCanvasScale;
  Offset thisTimeCanvasOffset =
      Offset(thisTimeCanvasOffsetX, thisTimeCanvasOffsetY);
  return thisTimeCanvasOffset;
}
