import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';

/// 课堂案例 async_json（步骤二）：
/// 异步读取本地 data/books.json，解析为 List<Book> 并输出统计
/// （总数、各类目数量 Map 统计、借阅量 Top3）。
Future<void> main() async {
  try {
    final text = await File('data/books.json').readAsString();
    final list = jsonDecode(text) as List<dynamic>;
    final books = list
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();

    print('===== 图书借阅统计 =====');
    print('图书总数：${books.length}');

    final byCategory = <String, int>{};
    for (final b in books) {
      byCategory[b.category] = (byCategory[b.category] ?? 0) + 1;
    }
    final sortedCats = byCategory.keys.toList()
      ..sort((a, b) {
        final c = byCategory[b]!.compareTo(byCategory[a]!);
        return c != 0 ? c : a.compareTo(b);
      });
    print('各类目数量：');
    for (final c in sortedCats) {
      print('  $c：${byCategory[c]} 本');
    }

    final top = books.toList()
      ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount));
    print('借阅量 Top3：');
    for (var i = 0; i < top.length && i < 3; i++) {
      print('  ${i + 1}. ${top[i].title}（${top[i].borrowCount}）');
    }
  } on FileSystemException {
    print('数据文件缺失，请检查 data/books.json');
  } catch (e) {
    print('未知错误：$e');
  }
}
