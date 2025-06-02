import 'package:flutter/material.dart';

import '../models/tree_position.dart';

class TreeGuidePainter extends CustomPainter {
  final TreePosition position;
  final double indentSize;
  final Color lineColor;
  final double lineWidth;

  TreeGuidePainter({
    required this.position,
    required this.indentSize,
    this.lineColor = const Color(0xFFCCCCCC),
    this.lineWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // 부모 레벨들의 세로선 그리기
    for (int i = 0; i < position.parentLines.length; i++) {
      if (position.parentLines[i]) {
        final x = (i + 1) * indentSize + 8; // 세로선 위치 (확장 아이콘 중앙)
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
    }

    // 현재 노드의 연결선 그리기 (depth가 0보다 큰 경우에만)
    if (position.depth > 0) {
      final x = position.depth * indentSize + 8; // 현재 레벨의 세로선 위치
      final y = size.height / 2; // 가로선의 세로 중앙 위치

      // 세로선 그리기
      if (position.isLast) {
        // 마지막 아이템이면 중앙까지만 세로선
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, y),
          paint,
        );
      } else {
        // 마지막이 아니면 전체 높이로 세로선
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }

      // 가로선 그리기 (세로선에서 아이콘까지)
      canvas.drawLine(
        Offset(x, y),
        Offset(x + 16, y), // 아이콘 앞까지 16픽셀
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TreeGuidePainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.indentSize != indentSize ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth;
  }
}
