/// 自主实践任务 2：异常兜底——文件缺失、字段缺失、类型错误三类异常全部给出可读提示。
/// 对比第 3 步的健壮版 fromJson：演示三类异常如何被捕获并转为用户可读信息。
import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';

Future<void> _demoFileMissing() async {
  try {
    await File('data/tidak_ada.json').readAsString();
  } on FileSystemException catch (e) {
    print('[文件缺失] 数据文件不存在，请检查路径 data/tidak_ada.json（${e.message}）');
  }
}

void _demoFieldMissing() {
  try {
    Book.fromJson({'id': 'B999', 'title': '缺字段的书'}); // 无 category / borrowCount
    print('[字段缺失] 解析成功');
  } catch (e) {
    print('[字段缺失] $e');
  }
  // 健壮版：缺失字段有默认值，不会抛错
  final b = Book.fromJson({'id': 'B999', 'title': '缺字段的书'});
  print('[字段缺失·健壮版] category=${b.category}, borrowCount=${b.borrowCount}');
}

void _demoTypeError() {
  try {
    Book.fromJson({'id': 'B999', 'title': 'x', 'borrowCount': 'abc'});
  } on FormatException catch (e) {
    print('[类型错误] 已捕获并提示：${e.message}');
  } catch (e) {
    print('[类型错误·兜底] $e');
  }
}

void main() {
  print('===== 异常兜底演示（三类异常均可读提示）=====');
  _demoFileMissing();
  _demoFieldMissing();
  _demoTypeError();
  print('三类异常均未导致程序崩溃退出，均有用户可读提示。');
}
