class TreePosition {
  final int depth; // 현재 노드의 깊이 (0부터 시작)
  final bool isLast; // 현재 레벨에서 마지막 아이템인지
  final List<bool> parentLines; // 각 부모 레벨에서 세로선이 계속 이어져야 하는지

  TreePosition({
    required this.depth,
    required this.isLast,
    required this.parentLines,
  });

  // 복사 생성자
  TreePosition copyWith({
    int? depth,
    bool? isLast,
    List<bool>? parentLines,
  }) {
    return TreePosition(
      depth: depth ?? this.depth,
      isLast: isLast ?? this.isLast,
      parentLines: parentLines ?? List<bool>.from(this.parentLines),
    );
  }

  @override
  String toString() {
    return 'TreePosition(depth: $depth, isLast: $isLast, parentLines: $parentLines)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TreePosition &&
        other.depth == depth &&
        other.isLast == isLast &&
        _listEquals(other.parentLines, parentLines);
  }

  @override
  int get hashCode {
    return depth.hashCode ^ isLast.hashCode ^ parentLines.hashCode;
  }

  // 리스트 비교 헬퍼 메서드
  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
