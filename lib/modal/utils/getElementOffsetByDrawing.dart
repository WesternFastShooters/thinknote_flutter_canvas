import 'dart:ui';

Offset getElementPointByDrawing({
  required Offset position,
  required Offset curCanvasOffset,
  required double curCanvasScale,
}) {
  return (position - curCanvasOffset) / curCanvasScale;
}
