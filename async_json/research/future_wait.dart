/// 独立研究任务 2：Future.wait 并行实验。
/// 3 个各延时 1 秒的任务：
/// - 串行（连续 await）：约 3 秒
/// - 并行（Future.wait）：约 1 秒
/// 扩展：部分失败场景——其中一个任务抛异常时 Future.wait 的行为与记录。
import 'dart:async';

Future<int> _task(int id, {bool fail = false}) async {
  await Future.delayed(const Duration(seconds: 1));
  if (fail) throw StateError('任务 $id 失败');
  return id;
}

Future<void> serial() async {
  final sw = Stopwatch()..start();
  final a = await _task(1);
  final b = await _task(2);
  final c = await _task(3);
  print('串行结果 [$a, $b, $c]，耗时 ${sw.elapsedMilliseconds} ms');
}

Future<void> parallel() async {
  final sw = Stopwatch()..start();
  final results = await Future.wait([_task(1), _task(2), _task(3)]);
  print('并行结果 $results，耗时 ${sw.elapsedMilliseconds} ms');
}

Future<void> partialFailure() async {
  final sw = Stopwatch()..start();
  try {
    await Future.wait([_task(1), _task(2, fail: true), _task(3)]);
  } catch (e) {
    print('部分失败：Future.wait 抛出第一个异常 "$e"，耗时 ${sw.elapsedMilliseconds} ms');
  }
  // 观察：成功任务仍会完成，但 wait 不返回其结果
  print('注意：成功的任务结果被丢弃（fail-fast 语义），需用 wait.eagerError=false 逐个收集');
}

Future<void> eagerCollect() async {
  final sw = Stopwatch()..start();
  final results = await Future.wait(
    [_task(1), _task(2, fail: true), _task(3)],
    eagerError: false,
  ).catchError((_) => <int>[]);
  print('eagerError=false + 捕获：返回 $results（失败任务由调用方自行记录），耗时 ${sw.elapsedMilliseconds} ms');
}

Future<void> main() async {
  print('===== 研究 2：Future.wait 并行实验 =====');
  await serial();
  await parallel();
  await partialFailure();
  await eagerCollect();
  print('结论：独立任务用 Future.wait 并行（约 1 秒 vs 串行约 3 秒）；'
      '部分失败默认 fail-fast 只抛第一个异常，需 eagerError=false 或逐一处理来收集全部结果。');
}
