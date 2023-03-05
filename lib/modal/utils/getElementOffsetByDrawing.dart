import 'dart:ui';

Offset getElementPointByDrawing({
  required Offset screenPoint,
  required Offset curCanvasOffset,
  required double curCanvasScale,
}) {
  return (screenPoint - curCanvasOffset) / curCanvasScale;
}
