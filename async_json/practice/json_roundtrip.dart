/// 自主实践任务 3：JSON 解析为模型类 + toJson 反向验证（roundtrip 一致）。
/// 完整字段模型化：Book（id/title/category/borrowCount）+ fromJson/toJson。
/// 验证：对象 → toJson → jsonEncode → jsonDecode → fromJson → 对象，逐字段比对一致。
import 'dart:convert';

import 'package:async_json/book.dart';

bool _same(Book a, Book b) =>
    a.id == b.id &&
    a.title == b.title &&
    a.category == b.category &&
    a.borrowCount == b.borrowCount;

void main() {
  print('===== JSON 模型 roundtrip 验证 =====');
  final src = Book(
      id: 'B010',
      title: '深入理解 Flutter',
      category: '技术',
      borrowCount: 66);

  // 正向：对象 → JSON 字符串
  final jsonStr = jsonEncode(src.toJson());
  print('toJson + jsonEncode => $jsonStr');

  // 反向：JSON 字符串 → Map → 对象
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  final restored = Book.fromJson(decoded);
  print('jsonDecode + fromJson => $restored');

  // 逐字段比对
  final ok = _same(src, restored);
  print('逐字段比对一致（roundtrip 一致）: $ok');

  // 反向验证独立于原始对象：修改 JSON 字符串后能还原出不同对象
  final edited = jsonDecode(jsonStr.replaceFirst('66', '99')) as Map<String, dynamic>;
  print('修改 borrowCount 后重新解析：${Book.fromJson(edited)}');
  print('roundtrip 验证完成。');
}
