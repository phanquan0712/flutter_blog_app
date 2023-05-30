
import 'package:equatable/equatable.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();
  @override
  List<Object> get props => [];
}


class FetchBlog extends BlogEvent {}

class FecthBlogUSer extends BlogEvent{
  final String userId;
  const FecthBlogUSer({required this.userId});
  @override
  List<Object> get props => [userId];
}