/// 独立研究任务 3：isolate 演示——主隔离区卡顿对比。
/// 同步计算：在主隔离区做重计算，事件循环被阻塞约 1 秒；
/// 计算前先打印时间戳，重计算后 tick 才姗姗来迟，说明主隔离区被卡住。
/// 对比 compute/Isolate.run：计算放到另一个隔离区，主隔离区保持响应。
import 'dart:async';
import 'dart:isolate';

int _heavy(int n) {
  var sum = 0;
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      sum += (i * j) % 7;
    }
  }
  return sum;
}

Future<void> syncBlocking() async {
  print('--- 同步计算（主隔离区阻塞）---');
  // 先预定一个 10ms 的 tick，观察它是否被同步重计算推迟
  unawaited(
    Future.delayed(const Duration(milliseconds: 10), () {
      print(
        '  预定 10ms 的 tick 实际触发 @${DateTime.now().second}.${DateTime.now().millisecond}s'
        '（应晚于计算结束 → 证明主隔离区被卡住）',
      );
    }),
  );
  final t0 = DateTime.now();
  print('  计算开始前 @${t0.second}.${t0.millisecond}s');
  _heavy(20000); // 约 1 秒的同步重计算
  print('  同步计算结束 @${DateTime.now().second}.${DateTime.now().millisecond}s');
  await Future.delayed(const Duration(milliseconds: 50));
}

Future<void> isolateRun() async {
  print('--- Isolate.run（计算移到独立隔离区）---');
  final sw = Stopwatch()..start();
  // 等待重计算期间，主隔离区仍能准时响应预定 tick
  unawaited(
    Future.delayed(const Duration(milliseconds: 100), () {
      print(
        '  预定 100ms 的 tick 准时触发 @${DateTime.now().second}.${DateTime.now().millisecond}s'
        '（主隔离区未被阻塞）',
      );
    }),
  );
  final r = await Isolate.run(() => _heavy(20000));
  print('  Isolate.run 返回 $r，耗时 ${sw.elapsedMilliseconds} ms');
  await Future.delayed(const Duration(milliseconds: 200));
}

Future<void> main() async {
  print('===== 研究 3：isolate 重计算演示 =====');
  await syncBlocking();
  await isolateRun();
  print(
    '结论：同步重计算会卡住主隔离区（事件循环延迟响应）；'
    'Isolate.run 把重计算放到独立隔离区，主隔离区保持流畅，适合 CPU 密集任务。',
  );
}
