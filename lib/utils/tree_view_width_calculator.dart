// lib/utils/tree_view_width_calculator.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/tree_node.dart';
import '../models/tree_view_theme.dart';

/// TreeView의 너비 계산을 담당하는 유틸리티 클래스
class TreeViewWidthCalculator {
  final TreeViewThemeData theme;
  final TextDirection textDirection;

  TreeViewWidthCalculator({
    required this.theme,
    this.textDirection = TextDirection.ltr,
  });

  /// 주어된 트리 노드들의 최대 너비를 계산
  double calculateContentWidth(List<TreeNode> rootNodes) {
    double maxWidth = 0.0;

    void traverseNodes(List<TreeNode> nodes, int depth) {
      for (final node in nodes) {
        final nodeWidth = _calculateNodeWidth(node, depth);
        maxWidth = math.max(maxWidth, nodeWidth);

        // 자식 노드들도 순회 (확장 상태와 관계없이 최대 너비 계산)
        if (node.children.isNotEmpty) {
          traverseNodes(node.children.cast<TreeNode>(), depth + 1);
        }
      }
    }

    traverseNodes(rootNodes, 0);

    // 최소 너비 보장 및 여유 공간 추가
    return math.max(maxWidth + _getRightMargin(), _getMinimumWidth());
  }

  /// 개별 노드의 너비를 계산
  double _calculateNodeWidth(TreeNode node, int depth) {
    // 기본 구성 요소들의 너비
    final indentWidth = theme.indentSize * depth;
    final arrowWidth = theme.nodeTheme.arrowIconWidth;
    final iconWidth = theme.nodeTheme.iconSize;
    final iconSpacing = theme.nodeTheme.iconSpacing;
    final horizontalPadding = theme.nodeTheme.horizontalPadding * 2;
    final contentPadding = theme.nodeTheme.contentHorizontalPadding * 2;

    // 텍스트 너비 계산
    final textWidth = _calculateTextWidth(node);

    return indentWidth +
        arrowWidth +
        contentPadding +
        iconWidth +
        iconSpacing +
        textWidth +
        horizontalPadding;
  }

  /// 텍스트의 실제 렌더링 너비를 계산
  double _calculateTextWidth(TreeNode node) {
    final TextStyle textStyle = _getTextStyleForNode(node);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: node.name,
        style: textStyle,
      ),
      maxLines: 1,
      textDirection: textDirection,
    );

    textPainter.layout();
    final width = textPainter.size.width;
    textPainter.dispose();

    return width;
  }

  /// 노드 타입에 따른 텍스트 스타일 반환
  TextStyle _getTextStyleForNode(TreeNode node) {
    if (node is Folder) {
      return theme.textTheme.folderTextStyle;
    } else if (node is Node) {
      return theme.textTheme.nodeTextStyle;
    } else if (node is Account) {
      return theme.textTheme.accountTextStyle;
    }
    return theme.textTheme.accountTextStyle; // 기본값
  }

  /// 확장된 노드들만 고려한 현재 표시 너비 계산
  double calculateVisibleContentWidth(
    List<TreeNode> rootNodes,
    Map<String, bool> expandedNodes,
  ) {
    double maxWidth = 0.0;

    void traverseVisibleNodes(List<TreeNode> nodes, int depth) {
      for (final node in nodes) {
        final nodeWidth = _calculateNodeWidth(node, depth);
        maxWidth = math.max(maxWidth, nodeWidth);

        // 확장된 노드의 자식들만 순회
        if (node.children.isNotEmpty && (expandedNodes[node.id] ?? false)) {
          traverseVisibleNodes(node.children.cast<TreeNode>(), depth + 1);
        }
      }
    }

    traverseVisibleNodes(rootNodes, 0);

    return math.max(maxWidth + _getRightMargin(), _getMinimumWidth());
  }

  /// 특정 깊이에서의 최대 텍스트 너비 계산 (성능 최적화용)
  double calculateMaxTextWidthAtDepth(List<TreeNode> nodes, int targetDepth,
      [int currentDepth = 0]) {
    double maxTextWidth = 0.0;

    for (final node in nodes) {
      if (currentDepth == targetDepth) {
        final textWidth = _calculateTextWidth(node);
        maxTextWidth = math.max(maxTextWidth, textWidth);
      }

      if (node.children.isNotEmpty && currentDepth < targetDepth) {
        final childMaxWidth = calculateMaxTextWidthAtDepth(
          node.children.cast<TreeNode>(),
          targetDepth,
          currentDepth + 1,
        );
        maxTextWidth = math.max(maxTextWidth, childMaxWidth);
      }
    }

    return maxTextWidth;
  }

  /// 트리의 최대 깊이 계산
  int calculateMaxDepth(List<TreeNode> rootNodes) {
    int maxDepth = 0;

    void traverseForDepth(List<TreeNode> nodes, int currentDepth) {
      maxDepth = math.max(maxDepth, currentDepth);

      for (final node in nodes) {
        if (node.children.isNotEmpty) {
          traverseForDepth(node.children.cast<TreeNode>(), currentDepth + 1);
        }
      }
    }

    traverseForDepth(rootNodes, 0);
    return maxDepth;
  }

  /// 노드별 너비 정보를 담은 맵 반환 (디버깅용)
  Map<String, double> calculateNodeWidths(List<TreeNode> rootNodes) {
    final Map<String, double> nodeWidths = {};

    void traverseNodes(List<TreeNode> nodes, int depth) {
      for (final node in nodes) {
        nodeWidths[node.id] = _calculateNodeWidth(node, depth);

        if (node.children.isNotEmpty) {
          traverseNodes(node.children.cast<TreeNode>(), depth + 1);
        }
      }
    }

    traverseNodes(rootNodes, 0);
    return nodeWidths;
  }

  /// 우측 여유 공간
  double _getRightMargin() => 16.0;

  /// 최소 너비 보장
  double _getMinimumWidth() => 200.0;
}

/// TreeView 너비 계산 관련 확장 메서드
extension TreeViewWidthExtensions on List<TreeNode> {
  /// 간편한 너비 계산 메서드
  double calculateContentWidth(TreeViewThemeData theme) {
    final calculator = TreeViewWidthCalculator(theme: theme);
    return calculator.calculateContentWidth(this);
  }

  /// 현재 표시되는 너비만 계산
  double calculateVisibleWidth(
    TreeViewThemeData theme,
    Map<String, bool> expandedNodes,
  ) {
    final calculator = TreeViewWidthCalculator(theme: theme);
    return calculator.calculateVisibleContentWidth(this, expandedNodes);
  }
}
