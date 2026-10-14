# lecture4 — 课堂作业4（第6周 · Dart语言基础三：异步、异常与包管理）

本仓库为第 6 周课堂作业的独立项目仓库，对应实践指南四：
异步模型（Future/async-await/Stream）、异常处理、包管理与 JSON 编解码。

## 目录结构

```
lecture4/
├── async_json/             # 课堂案例复现：dart create async_json
│   ├── lib/book.dart       # Book 模型：fromJson/toJson（健壮版：缺失默认0、类型可读报错）
│   ├── bin/async_json.dart # main：await 读取 + 统计（总数/类目/Top3）+ try-catch-finally
│   ├── data/
│   │   ├── books.json               # 正常数据集（8 本）
│   │   ├── books_missing_field.json # 故意实验：缺 borrowCount
│   │   └── books_type_error.json    # 故意实验：borrowCount 类型错误
│   ├── practice/           # 自主实践基本要求
│   │   ├── async_await_rewrite.dart # 任务1：嵌套回调 → 顺序 await
│   │   ├── exception_handling.dart  # 任务2：文件/字段/类型三类异常可读提示
│   │   └── json_roundtrip.dart      # 任务3：toJson 反向验证（roundtrip 一致）
│   └── research/           # 独立研究任务（选做，已全部完成）
│       ├── stream_vs_future.dart    # 任务1：Stream 与 Future 链对比
│       ├── future_wait.dart         # 任务2：串行 vs 并行计时 + 部分失败
│       └── isolate_demo.dart        # 任务3：同步计算卡顿 vs Isolate.run
├── progress.md             # 进度报告四（十节完整填写）
└── README.md
```

## 运行方式

```bash
cd async_json
dart run                                     # 正常路径统计
dart run bin/async_json.dart data/none.json  # 异常路径：文件缺失友好报错
dart run bin/async_json.dart data/books_missing_field.json  # 字段缺失默认 0
dart run bin/async_json.dart data/books_type_error.json     # 类型错误可读报错
dart run practice/async_await_rewrite.dart
dart run practice/exception_handling.dart
dart run practice/json_roundtrip.dart
dart run research/stream_vs_future.dart
dart run research/future_wait.dart
dart run research/isolate_demo.dart
```

## 环境

- Dart SDK 3.13.5（stable）
- Flutter 3.47.6（stable，仅 flutter doctor 环境检查）
- Git 2.55.0

## 提交记录

按实践指南逐步提交：数据集与依赖 → 解析与统计 → 健壮缺失字段与文件处理 → 自主实践 → 研究报告与进度报告。
