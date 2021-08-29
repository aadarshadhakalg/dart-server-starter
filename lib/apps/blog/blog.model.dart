import 'dart:convert';
import 'package:dartserverstarter/apps/users/user.model.dart';

class Blog {
  int blog_id;
  String title;
  String content;
  User author;
  DateTime updated_on;
  Blog({
    required this.blog_id,
    required this.title,
    required this.content,
    required this.author,
    required this.updated_on,
  });

  Blog copyWith({
    int? blog_id,
    String? title,
    String? content,
    User? author,
    DateTime? updated_on,
  }) {
    return Blog(
      blog_id: blog_id ?? this.blog_id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      updated_on: updated_on ?? this.updated_on,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blog_id': blog_id,
      'title': title,
      'content': content,
      'author': author.toMap(),
      'updated_on': updated_on.millisecondsSinceEpoch,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      blog_id: map['blog_id'],
      title: map['title'],
      content: map['content'],
      author: User.fromMap(map['author']),
      updated_on: DateTime.fromMillisecondsSinceEpoch(map['updated_on']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) => Blog.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Blog(blog_id: $blog_id, title: $title, content: $content, author: $author, updated_on: $updated_on)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Blog &&
        other.blog_id == blog_id &&
        other.title == title &&
        other.content == content &&
        other.author == author &&
        other.updated_on == updated_on;
  }

  @override
  int get hashCode {
    return blog_id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        author.hashCode ^
        updated_on.hashCode;
  }
}
