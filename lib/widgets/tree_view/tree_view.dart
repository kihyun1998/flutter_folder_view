import 'package:flutter/material.dart';

import '../../models/tree_node.dart';
import '../custom_inkwell.dart';

class TreeView extends StatefulWidget {
  final List<TreeNode> rootNodes;
  final Function(Account)? onAccountDoubleClick;
  final Function(Account)? onAccountRightClick;
  final double indentSize;
  final double nodeSpacing;

  const TreeView({
    super.key,
    required this.rootNodes,
    this.onAccountDoubleClick,
    this.onAccountRightClick,
    this.indentSize = 24.0,
    this.nodeSpacing = 4.0,
  });

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  final Map<String, bool> _expandedNodes = {};

  static const double _arrowIconWidth = 20.0;
  static const double _iconSize = 20.0;
  static const double _iconSpacing = 8.0;
  static const double _horizontalPadding = 8.0;
  static const double _verticalPadding = 4.0;
  static const double _rightMargin = 8.0;
  static const double _contentHorizontalPadding = 8.0; // 추가: 컨텐츠 내부 여유 공간

  @override
  void initState() {
    super.initState();
    _initializeExpandedStates(widget.rootNodes);
  }

  void _initializeExpandedStates(List<TreeNode> nodes) {
    for (var node in nodes) {
      if (node is Folder || node is Node) {
        _expandedNodes[node.id] = false;
        if (node.children.isNotEmpty) {
          _initializeExpandedStates(node.children.cast<TreeNode>());
        }
      }
    }
  }

  void _toggleExpansion(String nodeId) {
    setState(() {
      _expandedNodes[nodeId] = !(_expandedNodes[nodeId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: widget.rootNodes.length,
        itemBuilder: (context, index) {
          return _buildTreeNode(widget.rootNodes[index], 0);
        },
      ),
    );
  }

  Widget _buildTreeNode(TreeNode node, int depth) {
    if (node is Folder) {
      return _buildFolderNode(node, depth);
    } else if (node is Node) {
      return _buildNodeItem(node, depth);
    } else if (node is Account) {
      return _buildAccountItem(node, depth);
    }
    return const SizedBox.shrink();
  }

  Widget _buildExpandableItemLayout({
    required int depth,
    required Widget arrowIcon,
    required Widget mainIcon,
    required String text,
    required TextStyle textStyle,
    VoidCallback? onTap,
  }) {
    final indent = widget.indentSize * depth;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _arrowIconWidth,
              child: arrowIcon,
            ),
            CustomInkwell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.nodeSpacing,
                  horizontal: _contentHorizontalPadding, // 수정: 추가 패딩
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    mainIcon,
                    SizedBox(width: _iconSpacing),
                    Text(text, style: textStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItemLayout({
    required int depth,
    required Widget mainIcon,
    required String text,
    required TextStyle textStyle,
    VoidCallback? onDoubleTap,
    VoidCallback? onRightClick,
  }) {
    final indent = widget.indentSize * depth;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: _arrowIconWidth),
            CustomInkwell(
              onDoubleTap: onDoubleTap,
              onRightClick: onRightClick,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.nodeSpacing,
                  horizontal: _contentHorizontalPadding, // 수정: 추가 패딩
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    mainIcon,
                    SizedBox(width: _iconSpacing),
                    Text(text, style: textStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderNode(Folder folder, int depth) {
    final isExpanded = _expandedNodes[folder.id] ?? false;
    final children = folder.children.isEmpty
        ? <Widget>[]
        : folder.children
            .cast<TreeNode>()
            .map((child) => _buildTreeNode(child, depth + 1))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpandableItemLayout(
          depth: depth,
          arrowIcon: RotationTransition(
            turns: AlwaysStoppedAnimation(isExpanded ? 0.25 : 0.0),
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
          mainIcon: Icon(
            isExpanded ? Icons.folder_open : Icons.folder,
            color: Colors.amber.shade700,
            size: _iconSize,
          ),
          text: folder.name,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          onTap: () => _toggleExpansion(folder.id),
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _buildNodeItem(Node node, int depth) {
    final isExpanded = _expandedNodes[node.id] ?? false;
    final children = node.children.isEmpty
        ? <Widget>[]
        : node.children
            .cast<TreeNode>()
            .map((child) => _buildTreeNode(child, depth + 1))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpandableItemLayout(
          depth: depth,
          arrowIcon: RotationTransition(
            turns: AlwaysStoppedAnimation(isExpanded ? 0.25 : 0.0),
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
          mainIcon: Icon(
            isExpanded ? Icons.dns : Icons.storage,
            color: Colors.blue.shade600,
            size: _iconSize,
          ),
          text: node.name,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          onTap: () => _toggleExpansion(node.id),
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _buildAccountItem(Account account, int depth) {
    return _buildAccountItemLayout(
      depth: depth,
      mainIcon: Icon(
        Icons.account_circle,
        color: Colors.green.shade600,
        size: _iconSize,
      ),
      text: account.name,
      textStyle: const TextStyle(fontSize: 14),
      onDoubleTap: () => widget.onAccountDoubleClick?.call(account),
      onRightClick: () => widget.onAccountRightClick?.call(account),
    );
  }
}
