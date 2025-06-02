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

  // 재귀적으로 트리 노드를 빌드
  Widget _buildTreeNode(TreeNode node, int depth) {
    final isExpanded = _expandedNodes[node.id] ?? false;
    final indent = widget.indentSize * depth;

    if (node is Folder) {
      return _buildFolderNode(node, depth, isExpanded, indent);
    } else if (node is Node) {
      return _buildNodeItem(node, depth, isExpanded, indent);
    } else if (node is Account) {
      return _buildAccountItem(node, depth, indent);
    }

    return const SizedBox.shrink();
  }

  // 폴더 노드 빌드
  Widget _buildFolderNode(
      Folder folder, int depth, bool isExpanded, double indent) {
    final children = folder.children.isEmpty
        ? <Widget>[]
        : folder.children
            .cast<TreeNode>()
            .map((child) => _buildTreeNode(child, depth + 1))
            .toList();

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 폴더 헤더를 Container로 감싸서 content-sized width 적용
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.transparent,
            ),
            child: InkWell(
              onTap: () => _toggleExpansion(folder.id),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: widget.nodeSpacing),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 핵심: 컨텐츠 크기에 맞춤
                  children: [
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(isExpanded ? 0.25 : 0.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
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
                    const SizedBox(width: 8), // 오른쪽 여백
                  ],
                ),
              ),
            ),
          ),
          // 자식 노드들
          if (isExpanded) ...children,
        ],
      ),
    );
  }

  // 노드 아이템 빌드
  Widget _buildNodeItem(Node node, int depth, bool isExpanded, double indent) {
    final children = node.children.isEmpty
        ? <Widget>[]
        : node.children
            .cast<TreeNode>()
            .map((child) => _buildTreeNode(child, depth + 1))
            .toList();

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 노드 헤더를 Container로 감싸서 content-sized width 적용
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.transparent,
            ),
            child: InkWell(
              onTap: () => _toggleExpansion(node.id),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: widget.nodeSpacing),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 핵심: 컨텐츠 크기에 맞춤
                  children: [
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(isExpanded ? 0.25 : 0.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 4),
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
                    const SizedBox(width: 8), // 오른쪽 여백
                  ],
                ),
              ),
            ),
          ),
          // 자식 노드들
          if (isExpanded) ...children,
        ],
      ),
    );
  }

  // 계정 아이템 빌드 (리프 노드, 클릭 이벤트 있음)
  Widget _buildAccountItem(Account account, int depth, double indent) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: CustomInkwell(
          onDoubleTap: () => widget.onAccountDoubleClick?.call(account),
          onRightClick: () => widget.onAccountRightClick?.call(account),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: widget.nodeSpacing),
            child: Row(
              mainAxisSize: MainAxisSize.min, // 핵심: 컨텐츠 크기에 맞춤
              children: [
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
                const SizedBox(width: 8), // 오른쪽 여백
              ],
            ),
          ),
        ),
      ),
    );
  }
}
