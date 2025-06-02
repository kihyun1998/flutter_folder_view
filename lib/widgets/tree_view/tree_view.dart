import 'package:flutter/material.dart';
import 'package:flutter_folder_view/widgets/custom_expansion_tile.dart';

import '../../models/tree_node.dart';
import '../../models/tree_position.dart';
import '../custom_inkwell.dart';
import '../tree_guide_painter.dart';

class TreeView extends StatefulWidget {
  final List<TreeNode> rootNodes;
  final Function(Account)? onAccountDoubleClick;
  final Function(Account)? onAccountRightClick;
  final double indentSize;
  final double nodeSpacing;
  final bool showGuideLines;
  final Color guideLineColor;

  const TreeView({
    super.key,
    required this.rootNodes,
    this.onAccountDoubleClick,
    this.onAccountRightClick,
    this.indentSize = 24.0,
    this.nodeSpacing = 4.0,
    this.showGuideLines = true,
    this.guideLineColor = const Color(0xFFCCCCCC),
  });

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  // 각 노드의 확장 상태를 저장하는 맵
  final Map<String, bool> _expandedNodes = {};

  @override
  void initState() {
    super.initState();
    _initializeExpandedStates(widget.rootNodes);
  }

  // 모든 노드의 초기 확장 상태를 false로 설정
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

  // 노드의 확장 상태 토글
  void _toggleExpansion(String nodeId) {
    setState(() {
      _expandedNodes[nodeId] = !(_expandedNodes[nodeId] ?? false);
    });
  }

  // 위치 정보 계산
  TreePosition _calculatePosition({
    required int depth,
    required int siblingIndex,
    required int totalSiblings,
    required List<bool> parentLines,
  }) {
    final isLast = siblingIndex == totalSiblings - 1;
    return TreePosition(
      depth: depth,
      isLast: isLast,
      parentLines: List<bool>.from(parentLines),
    );
  }

  // 자식들의 부모 라인 계산
  List<bool> _calculateChildParentLines({
    required List<bool> currentParentLines,
    required bool isLastSibling,
    required int currentDepth,
  }) {
    final newParentLines = List<bool>.from(currentParentLines);

    // 현재 depth에 해당하는 위치에 세로선 필요 여부 설정
    if (newParentLines.length <= currentDepth) {
      // 리스트 크기 확장
      while (newParentLines.length <= currentDepth) {
        newParentLines.add(false);
      }
    }

    // 현재 노드가 마지막이 아니면 세로선 필요
    newParentLines[currentDepth] = !isLastSibling;

    return newParentLines;
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
          final position = _calculatePosition(
            depth: 0,
            siblingIndex: index,
            totalSiblings: widget.rootNodes.length,
            parentLines: [],
          );
          return _buildTreeNodeWithGuide(widget.rootNodes[index], position);
        },
      ),
    );
  }

  // 가이드라인과 함께 트리 노드 빌드
  Widget _buildTreeNodeWithGuide(TreeNode node, TreePosition position) {
    return Stack(
      children: [
        // 가이드라인 레이어
        if (widget.showGuideLines)
          Positioned.fill(
            child: CustomPaint(
              painter: TreeGuidePainter(
                position: position,
                indentSize: widget.indentSize,
                lineColor: widget.guideLineColor,
              ),
            ),
          ),
        // 노드 콘텐츠
        _buildTreeNode(node, position),
      ],
    );
  }

  // 재귀적으로 트리 노드를 빌드 (위치 정보 포함)
  Widget _buildTreeNode(TreeNode node, TreePosition position) {
    final isExpanded = _expandedNodes[node.id] ?? false;
    final indent = widget.indentSize * position.depth;

    if (node is Folder) {
      return _buildFolderNode(node, position, isExpanded, indent);
    } else if (node is Node) {
      return _buildNodeItem(node, position, isExpanded, indent);
    } else if (node is Account) {
      return _buildAccountItem(node, position, indent);
    }

    return const SizedBox.shrink();
  }

  // 폴더 노드 빌드
  Widget _buildFolderNode(
      Folder folder, TreePosition position, bool isExpanded, double indent) {
    // 자식들의 부모 라인 계산
    final childParentLines = _calculateChildParentLines(
      currentParentLines: position.parentLines,
      isLastSibling: position.isLast,
      currentDepth: position.depth,
    );

    final children = folder.children.isEmpty
        ? <Widget>[]
        : folder.children.cast<TreeNode>().asMap().entries.map((entry) {
            final childIndex = entry.key;
            final child = entry.value;
            final childPosition = _calculatePosition(
              depth: position.depth + 1,
              siblingIndex: childIndex,
              totalSiblings: folder.children.length,
              parentLines: childParentLines,
            );
            return _buildTreeNodeWithGuide(child, childPosition);
          }).toList();

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: CustomExpansionTile(
        isExpanded: isExpanded,
        spacing: widget.nodeSpacing,
        leading: Icon(
          Icons.keyboard_arrow_down,
          size: 16,
          color: Colors.grey.shade600,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded ? Icons.folder_open : Icons.folder,
              color: Colors.amber.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              folder.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: children,
        onExpansionChanged: (expanded) {
          _toggleExpansion(folder.id);
        },
      ),
    );
  }

  // 노드 아이템 빌드
  Widget _buildNodeItem(
      Node node, TreePosition position, bool isExpanded, double indent) {
    // 자식들의 부모 라인 계산
    final childParentLines = _calculateChildParentLines(
      currentParentLines: position.parentLines,
      isLastSibling: position.isLast,
      currentDepth: position.depth,
    );

    final children = node.children.isEmpty
        ? <Widget>[]
        : node.children.cast<TreeNode>().asMap().entries.map((entry) {
            final childIndex = entry.key;
            final child = entry.value;
            final childPosition = _calculatePosition(
              depth: position.depth + 1,
              siblingIndex: childIndex,
              totalSiblings: node.children.length,
              parentLines: childParentLines,
            );
            return _buildTreeNodeWithGuide(child, childPosition);
          }).toList();

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: CustomExpansionTile(
        isExpanded: isExpanded,
        spacing: widget.nodeSpacing,
        leading: Icon(
          Icons.keyboard_arrow_down,
          size: 16,
          color: Colors.grey.shade600,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded ? Icons.dns : Icons.storage,
              color: Colors.blue.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              node.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: children,
        onExpansionChanged: (expanded) {
          _toggleExpansion(node.id);
        },
      ),
    );
  }

  // 계정 아이템 빌드 (리프 노드, 클릭 이벤트 있음)
  Widget _buildAccountItem(
      Account account, TreePosition position, double indent) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: CustomInkwell(
        onDoubleTap: () => widget.onAccountDoubleClick?.call(account),
        onRightClick: () => widget.onAccountRightClick?.call(account),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.nodeSpacing),
          child: Row(
            children: [
              // chevron 아이콘 자리 (Account는 확장되지 않으므로 빈 공간)
              const SizedBox(width: 16),
              const SizedBox(width: 8),
              Icon(
                Icons.account_circle,
                color: Colors.green.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                account.name,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
