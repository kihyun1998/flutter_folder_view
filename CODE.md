# flutter_folder_view
## Project Structure

```
flutter_folder_view/
└── lib/
    ├── models/
        ├── tree_node.dart
        └── tree_node_state.dart
    ├── test_data/
        └── mock_data.dart
    ├── widgets/
        ├── tree_view/
        │   └── tree_view.dart
        ├── custom_expansion_tile.dart
        └── custom_inkwell.dart
    └── main.dart
```

## lib/main.dart
```dart
import 'package:flutter/material.dart';

import 'models/tree_node.dart';
import 'test_data/mock_data.dart';
import 'widgets/tree_view/tree_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TreeView Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TreeViewPage(),
    );
  }
}

class TreeViewPage extends StatefulWidget {
  const TreeViewPage({super.key});

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  late List<TreeNode> rootNodes;

  @override
  void initState() {
    super.initState();
    // 테스트 데이터 생성
    rootNodes = MockData.createTestData();
  }

  void _onAccountDoubleClick(Account account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Double Clicked'),
        content: Text('Account: ${account.name}\nID: ${account.id}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onAccountRightClick(Account account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Right Clicked'),
        content: Text('Account: ${account.name}\nID: ${account.id}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Desktop TreeView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: TreeView(
          rootNodes: rootNodes,
          onAccountDoubleClick: _onAccountDoubleClick,
          onAccountRightClick: _onAccountRightClick,
        ),
      ),
    );
  }
}

```
## lib/models/tree_node.dart
```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'tree_node_state.dart';

abstract class TreeNode<T> {
  final String id;
  final String name;
  final List<dynamic> children;
  final T data;

  TreeNode({
    required this.id,
    required this.name,
    List<dynamic>? children,
    required this.data,
  }) : children = children ?? [];

  TreeNode<T> copyWith({
    String? id,
    String? name,
    List<dynamic>? children,
    T? data,
  });
}

class Node extends TreeNode<TreeNodeState> {
  Node({
    required super.id,
    required super.name,
    super.children,
    required super.data,
  });

  @override
  Node copyWith({
    String? id,
    String? name,
    List<dynamic>? children,
    TreeNodeState? data,
  }) {
    return Node(
      id: id ?? this.id,
      name: name ?? this.name,
      children: children ?? this.children,
      data: data ?? this.data,
    );
  }
}

class Account extends TreeNode<TreeNodeState> {
  Account({
    required super.id,
    required super.name,
    super.children,
    required super.data,
  });

  factory Account.init() => Account(
        id: "",
        name: "",
        data: TreeNodeState.init(),
      );

  @override
  Account copyWith({
    String? id,
    String? name,
    List<dynamic>? children,
    TreeNodeState? data,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      children: children ?? this.children,
      data: data ?? this.data,
    );
  }
}

class Folder extends TreeNode<bool> {
  Folder({
    required super.id,
    required super.name,
    super.children,
    super.data = false,
  });

  factory Folder.init() => Folder(id: "", name: "");

  @override
  Folder copyWith({
    String? id,
    String? name,
    List<dynamic>? children,
    bool? data,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      children: children ?? this.children,
      data: data ?? this.data,
    );
  }
}

```
## lib/models/tree_node_state.dart
```dart
class TreeNodeState {
  final bool isSelected;
  final bool isExpanded;
  final String status;
  final Map<String, dynamic> metadata;

  TreeNodeState({
    this.isSelected = false,
    this.isExpanded = false,
    this.status = 'normal',
    Map<String, dynamic>? metadata,
  }) : metadata = metadata ?? {};

  factory TreeNodeState.init() {
    return TreeNodeState(
      isSelected: false,
      isExpanded: false,
      status: 'normal',
      metadata: {},
    );
  }

  // 사용자의 기존 코드에서 사용되는 fromPathUser 팩토리 (간단 버전)
  factory TreeNodeState.fromPathUser(dynamic pathUser) {
    return TreeNodeState(
      isSelected: false,
      isExpanded: false,
      status: 'active',
      metadata: {
        'pathUser': pathUser.toString(),
      },
    );
  }

  TreeNodeState copyWith({
    bool? isSelected,
    bool? isExpanded,
    String? status,
    Map<String, dynamic>? metadata,
  }) {
    return TreeNodeState(
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'TreeNodeState(isSelected: $isSelected, isExpanded: $isExpanded, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreeNodeState &&
        other.isSelected == isSelected &&
        other.isExpanded == isExpanded &&
        other.status == status;
  }

  @override
  int get hashCode {
    return isSelected.hashCode ^ isExpanded.hashCode ^ status.hashCode;
  }
}

```
## lib/test_data/mock_data.dart
```dart
import '../models/tree_node.dart';
import '../models/tree_node_state.dart';

class MockData {
  static List<TreeNode> createTestData() {
    // 테스트용 TreeNodeState 생성
    final nodeState1 = TreeNodeState.init();
    final nodeState2 = TreeNodeState.init();
    final nodeState3 = TreeNodeState.init();
    final nodeState4 = TreeNodeState.init();

    // Account들 생성
    final account1 = Account(
      id: 'acc_1',
      name: 'admin@example.com',
      data: nodeState1,
    );

    final account2 = Account(
      id: 'acc_2',
      name: 'user@example.com',
      data: nodeState1,
    );

    final account3 = Account(
      id: 'acc_3',
      name: 'guest@domain.com',
      data: nodeState2,
    );

    final account4 = Account(
      id: 'acc_4',
      name: 'test@domain.com',
      data: nodeState3,
    );

    final account5 = Account(
      id: 'acc_5',
      name: 'test@domain.com',
      data: nodeState4,
    );
    final account6 = Account(
      id: 'acc_6',
      name: 'test@domain.com',
      data: nodeState4,
    );

    // Node들 생성
    final node1 = Node(
      id: 'node_1',
      name: 'Web Server',
      children: [account1, account2],
      data: nodeState1,
    );

    final node2 = Node(
      id: 'node_2',
      name: 'Database Server',
      children: [account3],
      data: nodeState2,
    );

    final node3 = Node(
      id: 'node_3',
      name: 'API Server',
      children: [account4],
      data: nodeState3,
    );

    final node4 = Node(
      id: 'node_4',
      name: 'API Server',
      children: [account5, account6],
      data: nodeState3,
    );

    // 서브 폴더 생성
    final subFolder = Folder(
      id: 'folder_sub',
      name: 'Development',
      children: [node3],
      data: false,
    );

    // 루트 폴더들 생성
    final folder1 = Folder(
      id: 'folder_1',
      name: 'Production',
      children: [node1, node2],
      data: false,
    );

    final folder2 = Folder(
      id: 'folder_2',
      name: 'Staging',
      children: [subFolder],
      data: false,
    );

    // 혼합된 루트 노드들 반환 (Folder와 Node 모두 루트에 올 수 있다고 가정)
    return [folder1, folder2, node4];
  }

  // 더 복잡한 테스트 데이터
  static List<TreeNode> createComplexTestData() {
    final List<TreeNode> nodes = [];

    // 대용량 테스트를 위한 데이터
    for (int i = 0; i < 3; i++) {
      final folder = Folder(
        id: 'root_folder_$i',
        name: 'Root Folder $i',
        data: false,
      );

      for (int j = 0; j < 2; j++) {
        final subFolder = Folder(
          id: 'sub_folder_${i}_$j',
          name: 'Sub Folder $j',
          data: false,
        );

        for (int k = 0; k < 3; k++) {
          final node = Node(
            id: 'node_${i}_${j}_$k',
            name: 'Server $i-$j-$k',
            data: TreeNodeState.init(),
          );

          for (int l = 0; l < 2; l++) {
            final account = Account(
              id: 'acc_${i}_${j}_${k}_$l',
              name: 'user$l@server$k.com',
              data: TreeNodeState.init(),
            );
            node.children.add(account);
          }

          subFolder.children.add(node);
        }

        folder.children.add(subFolder);
      }

      nodes.add(folder);
    }

    return nodes;
  }
}

```
## lib/widgets/custom_expansion_tile.dart
```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget leading;
  final List<Widget> children;
  final bool isExpanded;
  final double spacing;
  final ValueChanged<bool>? onExpansionChanged;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.leading,
    required this.children,
    required this.isExpanded,
    required this.spacing,
    this.onExpansionChanged,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      _isExpanded = widget.isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _handleTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: widget.spacing),
            child: Row(
              children: [
                RotationTransition(
                  turns: _iconTurns,
                  child: widget.leading,
                ),
                const SizedBox(width: 4),
                widget.title,
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(), // 빈값
          secondChild: Column(children: widget.children),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 150),
        ),
      ],
    );
  }
}

```
## lib/widgets/custom_inkwell.dart
```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomInkwell extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onRightClick;
  final BorderRadius? borderRadius;
  final Color? hoverColor;
  final Color? splashColor;

  const CustomInkwell({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onRightClick,
    this.borderRadius,
    this.hoverColor,
    this.splashColor,
  });

  @override
  State<CustomInkwell> createState() => _CustomInkwellState();
}

class _CustomInkwellState extends State<CustomInkwell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          // 우클릭 처리
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            widget.onRightClick?.call();
          }
        },
        child: InkWell(
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
          hoverColor: widget.hoverColor ?? Theme.of(context).hoverColor,
          splashColor: widget.splashColor ?? Theme.of(context).splashColor,
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered
                  ? (widget.hoverColor ??
                      Theme.of(context).hoverColor.withOpacity(0.1))
                  : Colors.transparent,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

```
## lib/widgets/tree_view/tree_view.dart
```dart
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

  // 레이아웃 상수들
  static const double _arrowIconWidth = 20.0; // arrow icon의 고정 너비
  static const double _iconSize = 20.0;
  static const double _iconSpacing = 8.0;
  static const double _horizontalPadding = 8.0;
  static const double _verticalPadding = 4.0;
  static const double _rightMargin = 8.0;

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

  // 확장 가능한 노드들을 위한 공통 레이아웃 빌더 (Folder, Node)
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
            // Arrow icon 영역 - hover/splash 효과 없음
            SizedBox(
              width: _arrowIconWidth,
              child: arrowIcon,
            ),
            // 실제 컨텐츠 영역만 CustomInkwell로 감싸기
            CustomInkwell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.nodeSpacing,
                  horizontal: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main icon
                    mainIcon,
                    SizedBox(width: _iconSpacing),
                    // Text
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

  // Account 전용 레이아웃 빌더
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
            // Arrow icon 영역 - 빈 공간, hover/splash 효과 없음
            const SizedBox(width: _arrowIconWidth),
            // 실제 컨텐츠 영역만 CustomInkwell로 감싸기
            CustomInkwell(
              onDoubleTap: onDoubleTap,
              onRightClick: onRightClick,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.nodeSpacing,
                  horizontal: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main icon
                    mainIcon,
                    SizedBox(width: _iconSpacing),
                    // Text
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

```
