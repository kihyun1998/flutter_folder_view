import 'package:flutter/material.dart';

import 'models/tree_node.dart';
import 'models/tree_view_theme.dart'; // 새로 추가!
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
  TreeViewThemeData? selectedTheme;

  @override
  void initState() {
    super.initState();
    // 테스트 데이터 생성
    rootNodes = MockData.createTestData();

    // 기본 테마로 시작
    selectedTheme = TreeViewThemeData.defaultTheme();
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

  void _changeTheme(TreeViewThemeData newTheme) {
    setState(() {
      selectedTheme = newTheme;
    });
  }

  void _switchToComplexData() {
    setState(() {
      rootNodes = MockData.createComplexTestData();
    });
  }

  void _switchToSimpleData() {
    setState(() {
      rootNodes = MockData.createTestData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Flutter TreeView Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 테마 선택 드롭다운
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette),
            tooltip: 'Change Theme',
            onSelected: (String value) {
              switch (value) {
                case 'default':
                  _changeTheme(TreeViewThemeData.defaultTheme());
                  break;
                case 'material3':
                  _changeTheme(TreeViewThemeData.material3());
                  break;
                case 'dark':
                  _changeTheme(TreeViewThemeData.dark());
                  break;
                case 'custom':
                  _changeTheme(_createCustomTheme());
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'default',
                child: Text('Default Theme'),
              ),
              const PopupMenuItem<String>(
                value: 'material3',
                child: Text('Material 3 Theme'),
              ),
              const PopupMenuItem<String>(
                value: 'dark',
                child: Text('Dark Theme'),
              ),
              const PopupMenuItem<String>(
                value: 'custom',
                child: Text('Custom Theme'),
              ),
            ],
          ),

          // 데이터 변경 버튼
          PopupMenuButton<String>(
            icon: const Icon(Icons.data_object),
            tooltip: 'Change Data',
            onSelected: (String value) {
              switch (value) {
                case 'simple':
                  _switchToSimpleData();
                  break;
                case 'complex':
                  _switchToComplexData();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'simple',
                child: Text('Simple Test Data'),
              ),
              const PopupMenuItem<String>(
                value: 'complex',
                child: Text('Complex Test Data'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // TreeView 영역
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TreeView(
                rootNodes: rootNodes,
                onAccountDoubleClick: _onAccountDoubleClick,
                onAccountRightClick: _onAccountRightClick,
                theme: selectedTheme, // 새로운 테마 적용!
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 커스텀 테마 생성 예제
  TreeViewThemeData _createCustomTheme() {
    return TreeViewThemeData(
      // 스크롤바 커스터마이징
      scrollbarTheme: const TreeViewScrollbarTheme(
        color: Color(0xFFE91E63), // 핑크
        trackColor: Color(0x1AE91E63),
        width: 16.0,
        hoverOnly: true,
        opacity: 0.8,
      ),

      // 노드 스타일링
      nodeTheme: const TreeViewNodeTheme(
        verticalPadding: 8.0,
        horizontalPadding: 12.0,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        hoverColor: Color(0x0AE91E63),
      ),

      // 아이콘 색상 변경
      iconTheme: const TreeViewIconTheme(
        folderColor: Color(0xFFFF9800), // 오렌지
        nodeColor: Color(0xFF9C27B0), // 퍼플
        accountColor: Color(0xFF4CAF50), // 그린
        arrowColor: Color(0xFF757575),
      ),

      // 전체 스타일
      indentSize: 28.0,
      nodeSpacing: 6.0,
      backgroundColor: const Color(0xFFFAFAFA),
      borderColor: const Color(0xFFE91E63),
      borderWidth: 2.0,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    );
  }

  String _getThemeName() {
    if (selectedTheme == null) return 'Default';

    // 간단한 테마 식별 (실제로는 더 정교한 방법 필요)
    if (selectedTheme!.scrollbarTheme.color == const Color(0xFFE91E63)) {
      return 'Custom Pink';
    } else if (selectedTheme!.scrollbarTheme.color == const Color(0xFF6750A4)) {
      return 'Material 3';
    } else if (selectedTheme!.backgroundColor == const Color(0xFF121212)) {
      return 'Dark';
    }
    return 'Default';
  }

  int _getTotalNodeCount() {
    int count = 0;
    void countNodes(List<TreeNode> nodes) {
      count += nodes.length;
      for (var node in nodes) {
        if (node.children.isNotEmpty) {
          countNodes(node.children.cast<TreeNode>());
        }
      }
    }

    countNodes(rootNodes);
    return count;
  }
}
