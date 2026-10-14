/// 自主实践任务 1：async/await 改写回调版程序。
/// 「嵌套回调版」模拟三步异步：取用户 → 取该用户帖子 → 取帖子评论。
/// 对比「顺序 await 版」：回调金字塔 vs 平铺顺序代码。
Future<String> fetchUser(int delayMs, [String? msg]) =>
    Future.delayed(Duration(milliseconds: delayMs), () => msg ?? '用户A');

Future<void> main() async {
  print('===== 改写前：嵌套回调版（回调地狱）=====');
  fetchUser(50).then((user) {
    print('1. 拿到用户：$user');
    fetchUser(50, '帖子[$user]-01').then((post) {
      print('2. 拿到帖子：$post');
      fetchUser(50, '评论:写得好！').then((comment) {
        print('3. 拿到评论：$comment');
        print('（回调嵌套三层，逻辑深、缩进深、难读难维护）');
      });
    });
  });
  // 等待回调链完成后再对比
  await Future.delayed(const Duration(milliseconds: 300));

  print('===== 改写后：顺序 await 版 ====');
  final user = await fetchUser(50); // 等待但不阻塞事件循环
  print('1. 拿到用户：$user');
  final post = await fetchUser(50, '帖子[$user]-01');
  print('2. 拿到帖子：$post');
  final comment = await fetchUser(50, '评论:写得好！');
  print('3. 拿到评论：$comment');
  print('（三层 await 平铺为顺序代码，逻辑自上而下，与同步代码几乎一致）');
}
