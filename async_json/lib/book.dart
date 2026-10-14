import 'dart:convert';

/// 图书模型类（步骤二基础版）：手写 fromJson/toJson。
class Book {
  final String id, title, category;
  final int borrowCount;

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.borrowCount,
  });

  factory Book.fromJson(Map<String, dynamic> j) => Book(
    id: j['id'] as String,
    title: j['title'] as String,
    category: j['category'] as String,
    borrowCount: (j['borrowCount'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'borrowCount': borrowCount,
  };

  @override
  String toString() => 'Book($id, $title, $category, $borrowCount)';
}
