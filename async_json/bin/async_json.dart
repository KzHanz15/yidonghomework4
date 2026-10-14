import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';

/// 课堂案例 async_json（步骤三·健壮版）：
/// 异步读取本地 books.json，解析为 List<Book> 并输出统计
/// （总数、各类目数量 Map 统计、借阅量 Top3）。
///
/// 用法：
///   dart run                 # 读取 data/books.json（正常路径）
///   dart run data/books_missing_field.json   # 故意实验：字段缺失容错（默认 0）
///   dart run data/books_type_error.json      # 故意实验：类型错误明确报错
///   dart run data/none.json                  # 异常路径：文件缺失友好报错
Future<void> main(List<String> args) async {
  final file = args.isNotEmpty ? args.first : 'data/books.json';
  final stopwatch = Stopwatch()..start();
  try {
    final text = await File(file).readAsString();
    final list = jsonDecode(text) as List<dynamic>;
    final books = list
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList();
    await _printStats(books, file);
  } on FileSystemException catch (e) {
    // 文件缺失/不可读：用户可读提示，禁止裸抛
    print('数据文件缺失，请检查 $file（${e.message}）');
  } on FormatException catch (e) {
    print('JSON 数据格式错误：${e.message}');
  } catch (e) {
    print('未知错误：$e');
  } finally {
    print('耗时：${stopwatch.elapsedMilliseconds} ms');
    print('程序结束。');
  }
}

Future<void> _printStats(List<Book> books, String file) async {
  print('===== 图书借阅统计（$file）=====');
  print('图书总数：${books.length}');

  // 各类目数量：Map 统计
  final byCategory = <String, int>{};
  for (final b in books) {
    byCategory[b.category] = (byCategory[b.category] ?? 0) + 1;
  }
  final sortedCats = byCategory.keys.toList()
    ..sort((a, b) {
      final c = byCategory[b]!.compareTo(byCategory[a]!); // 数量降序
      return c != 0 ? c : a.compareTo(b);
    });
  print('各类目数量：');
  for (final c in sortedCats) {
    print('  $c：${byCategory[c]} 本');
  }

  // 借阅量 Top3
  final top = books.toList()
    ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount));
  print('借阅量 Top3：');
  for (var i = 0; i < top.length && i < 3; i++) {
    print('  ${i + 1}. ${top[i].title}（${top[i].borrowCount}）');
  }
  print(
    '（await 在此处的作用：等待 File.readAsString 异步完成拿到文本后，'
    '再进入解析与统计，期间不阻塞事件循环。）',
  );
}
