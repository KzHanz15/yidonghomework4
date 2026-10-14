/// 独立研究任务 1：Stream 与 Future 链对比。
/// 同一组数据（0,1,2 三个 tick，各延时 1 秒）分别用两种方式产出：
/// - Future 链：Future.delayed 依次串成链条，值为「一次性」结果
/// - Stream：Stream.periodic 随时间持续发射，可 await for 逐个消费
/// 对比代码形态与输出时序。
import 'dart:async';

Future<void> futureChain() async {
  print('--- Future 链（一次性值，链式取用）---');
  final a = await Future.delayed(const Duration(seconds: 1), () => 0);
  print('  tick $a @${DateTime.now().second}s');
  final b = await Future.delayed(const Duration(seconds: 1), () => 1);
  print('  tick $b @${DateTime.now().second}s');
  final c = await Future.delayed(const Duration(seconds: 1), () => 2);
  print('  tick $c @${DateTime.now().second}s');
  print('  Future 链只能拿到「最后一个」整体值，中途无事件'); 
}

Future<void> streamVersion() async {
  print('--- Stream（异步事件序列，随时间持续到达）---');
  final stream =
      Stream.periodic(const Duration(seconds: 1), (i) => i).take(3);
  await for (final i in stream) {
    print('  tick $i @${DateTime.now().second}s');
  }
}

Future<void> main() async {
  print('===== 研究 1：Stream 与 Future 链对比 =====');
  print('两组都各花约 3 秒，输出 0/1/2 三个 tick。');
  await futureChain();
  await streamVersion();
  print('结论：Future 链是「多个一次性 Future 按序 await」；'
      'Stream 是「一个可多次发射的事件序列」。代码形态：Future 链逐段手写，'
      'Stream 用 await for 统一消费，适合需要持续/分批到达的数据源。');
}
