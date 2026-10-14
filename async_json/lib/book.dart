import 'dart:convert';

/// 图书模型类：手写 fromJson/toJson（不依赖代码生成，第 11 课网络解析直接复用此模式）。
class Book {
  final String id, title, category;
  final int borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.borrowCount,
  });

  /// 从 JSON Map 构造 Book。
  /// 缺失/非法字段策略（步骤三·健壮版）：
  /// - borrowCount 缺失或 null → 默认 0（修复步骤二的 null 断言崩溃）
  /// - borrowCount 为字符串数字 → 类型兜底转换
  /// - borrowCount 为其他非法类型 → 抛 FormatException（类型错误明确报错）
  factory Book.fromJson(Map<String, dynamic> j) => Book(
    id: _asString(j['id'], ''),
    title: _asString(j['title'], ''),
    category: _asString(j['category'], '未分类'),
    borrowCount: _asInt(j['borrowCount']),
  );

  static String _asString(dynamic v, String fallback) =>
      v == null ? fallback : v.toString();

  static int _asInt(dynamic v) {
    if (v == null) return 0; // 字段缺失：默认 0
    if (v is num) return v.toInt(); // int/double 安全转换
    if (v is String && v.trim().isNotEmpty) {
      final n = num.tryParse(v.trim()); // 字符串数字兜底
      if (n != null) return n.toInt();
    }
    throw FormatException('borrowCount 类型不合法: $v');
  }

  /// 序列化回 JSON Map（roundtrip 反向验证用）。
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'borrowCount': borrowCount,
  };

  /// 规范 JSON 字符串，便于 roundtrip 比较。
  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => 'Book($id, $title, $category, $borrowCount)';
}
