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
