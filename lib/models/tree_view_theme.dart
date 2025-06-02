// lib/models/tree_view_theme.dart
import 'package:flutter/material.dart';

/// TreeView의 스크롤바 테마 설정
class TreeViewScrollbarTheme {
  final bool showVertical;
  final bool showHorizontal;
  final double width;
  final Color color;
  final Color trackColor;
  final double opacity;
  final bool hoverOnly;
  final Duration animationDuration;

  const TreeViewScrollbarTheme({
    this.showVertical = true,
    this.showHorizontal = true,
    this.width = 12.0,
    this.color = const Color(0xFF757575),
    this.trackColor = const Color(0x1A000000),
    this.opacity = 0.7,
    this.hoverOnly = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  TreeViewScrollbarTheme copyWith({
    bool? showVertical,
    bool? showHorizontal,
    double? width,
    Color? color,
    Color? trackColor,
    double? opacity,
    bool? hoverOnly,
    Duration? animationDuration,
  }) {
    return TreeViewScrollbarTheme(
      showVertical: showVertical ?? this.showVertical,
      showHorizontal: showHorizontal ?? this.showHorizontal,
      width: width ?? this.width,
      color: color ?? this.color,
      trackColor: trackColor ?? this.trackColor,
      opacity: opacity ?? this.opacity,
      hoverOnly: hoverOnly ?? this.hoverOnly,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }
}

/// TreeView 노드의 테마 설정
class TreeViewNodeTheme {
  final double verticalPadding;
  final double horizontalPadding;
  final double iconSize;
  final double iconSpacing;
  final double arrowIconWidth;
  final double contentHorizontalPadding;
  final BorderRadius borderRadius;
  final Color? hoverColor;
  final Color? splashColor;

  const TreeViewNodeTheme({
    this.verticalPadding = 4.0,
    this.horizontalPadding = 8.0,
    this.iconSize = 20.0,
    this.iconSpacing = 8.0,
    this.arrowIconWidth = 20.0,
    this.contentHorizontalPadding = 8.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.hoverColor,
    this.splashColor,
  });

  TreeViewNodeTheme copyWith({
    double? verticalPadding,
    double? horizontalPadding,
    double? iconSize,
    double? iconSpacing,
    double? arrowIconWidth,
    double? contentHorizontalPadding,
    BorderRadius? borderRadius,
    Color? hoverColor,
    Color? splashColor,
  }) {
    return TreeViewNodeTheme(
      verticalPadding: verticalPadding ?? this.verticalPadding,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      arrowIconWidth: arrowIconWidth ?? this.arrowIconWidth,
      contentHorizontalPadding:
          contentHorizontalPadding ?? this.contentHorizontalPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      hoverColor: hoverColor ?? this.hoverColor,
      splashColor: splashColor ?? this.splashColor,
    );
  }
}

/// TreeView 아이콘들의 테마 설정
class TreeViewIconTheme {
  final IconData folderIcon;
  final IconData folderOpenIcon;
  final IconData nodeIcon;
  final IconData nodeExpandedIcon;
  final IconData accountIcon;
  final IconData arrowIcon;

  final Color folderColor;
  final Color nodeColor;
  final Color accountColor;
  final Color arrowColor;

  const TreeViewIconTheme({
    this.folderIcon = Icons.folder,
    this.folderOpenIcon = Icons.folder_open,
    this.nodeIcon = Icons.storage,
    this.nodeExpandedIcon = Icons.dns,
    this.accountIcon = Icons.account_circle,
    this.arrowIcon = Icons.keyboard_arrow_right,
    this.folderColor = const Color(0xFFFFB300), // amber.shade700
    this.nodeColor = const Color(0xFF1976D2), // blue.shade600
    this.accountColor = const Color(0xFF388E3C), // green.shade600
    this.arrowColor = const Color(0xFF757575), // grey.shade600
  });

  TreeViewIconTheme copyWith({
    IconData? folderIcon,
    IconData? folderOpenIcon,
    IconData? nodeIcon,
    IconData? nodeExpandedIcon,
    IconData? accountIcon,
    IconData? arrowIcon,
    Color? folderColor,
    Color? nodeColor,
    Color? accountColor,
    Color? arrowColor,
  }) {
    return TreeViewIconTheme(
      folderIcon: folderIcon ?? this.folderIcon,
      folderOpenIcon: folderOpenIcon ?? this.folderOpenIcon,
      nodeIcon: nodeIcon ?? this.nodeIcon,
      nodeExpandedIcon: nodeExpandedIcon ?? this.nodeExpandedIcon,
      accountIcon: accountIcon ?? this.accountIcon,
      arrowIcon: arrowIcon ?? this.arrowIcon,
      folderColor: folderColor ?? this.folderColor,
      nodeColor: nodeColor ?? this.nodeColor,
      accountColor: accountColor ?? this.accountColor,
      arrowColor: arrowColor ?? this.arrowColor,
    );
  }
}

/// TreeView 텍스트 스타일 테마
class TreeViewTextTheme {
  final TextStyle folderTextStyle;
  final TextStyle nodeTextStyle;
  final TextStyle accountTextStyle;

  const TreeViewTextTheme({
    this.folderTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    this.nodeTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    this.accountTextStyle = const TextStyle(
      fontSize: 14,
    ),
  });

  TreeViewTextTheme copyWith({
    TextStyle? folderTextStyle,
    TextStyle? nodeTextStyle,
    TextStyle? accountTextStyle,
  }) {
    return TreeViewTextTheme(
      folderTextStyle: folderTextStyle ?? this.folderTextStyle,
      nodeTextStyle: nodeTextStyle ?? this.nodeTextStyle,
      accountTextStyle: accountTextStyle ?? this.accountTextStyle,
    );
  }
}

/// TreeView 전체 테마 데이터
class TreeViewThemeData {
  final TreeViewScrollbarTheme scrollbarTheme;
  final TreeViewNodeTheme nodeTheme;
  final TreeViewIconTheme iconTheme;
  final TreeViewTextTheme textTheme;
  final double indentSize;
  final double nodeSpacing;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  const TreeViewThemeData({
    this.scrollbarTheme = const TreeViewScrollbarTheme(),
    this.nodeTheme = const TreeViewNodeTheme(),
    this.iconTheme = const TreeViewIconTheme(),
    this.textTheme = const TreeViewTextTheme(),
    this.indentSize = 24.0,
    this.nodeSpacing = 4.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  /// 기본 테마 생성
  factory TreeViewThemeData.defaultTheme() {
    return const TreeViewThemeData();
  }

  /// Material 3 스타일 테마 생성
  factory TreeViewThemeData.material3() {
    return TreeViewThemeData(
      scrollbarTheme: const TreeViewScrollbarTheme(
        color: Color(0xFF6750A4),
        trackColor: Color(0x1A6750A4),
        width: 14.0,
      ),
      nodeTheme: const TreeViewNodeTheme(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        verticalPadding: 6.0,
        horizontalPadding: 12.0,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    );
  }

  /// 다크 테마 생성
  factory TreeViewThemeData.dark() {
    return TreeViewThemeData(
      scrollbarTheme: const TreeViewScrollbarTheme(
        color: Color(0xFFBBBBBB),
        trackColor: Color(0x1AFFFFFF),
      ),
      iconTheme: const TreeViewIconTheme(
        folderColor: Color(0xFFFFCA28),
        nodeColor: Color(0xFF42A5F5),
        accountColor: Color(0xFF66BB6A),
        arrowColor: Color(0xFFBBBBBB),
      ),
      backgroundColor: const Color(0xFF121212),
      borderColor: const Color(0xFF333333),
    );
  }

  TreeViewThemeData copyWith({
    TreeViewScrollbarTheme? scrollbarTheme,
    TreeViewNodeTheme? nodeTheme,
    TreeViewIconTheme? iconTheme,
    TreeViewTextTheme? textTheme,
    double? indentSize,
    double? nodeSpacing,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
  }) {
    return TreeViewThemeData(
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      nodeTheme: nodeTheme ?? this.nodeTheme,
      iconTheme: iconTheme ?? this.iconTheme,
      textTheme: textTheme ?? this.textTheme,
      indentSize: indentSize ?? this.indentSize,
      nodeSpacing: nodeSpacing ?? this.nodeSpacing,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
