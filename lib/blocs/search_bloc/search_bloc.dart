

import 'package:blog_app/blocs/search_bloc/search_event.dart';
import 'package:blog_app/blocs/search_bloc/search_state.dart';
import 'package:blog_app/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchBlogState> {
  final SearchRepository _searchRepository;
  SearchBloc({required SearchRepository searchRepository})
      :_searchRepository = searchRepository,
        super(SearchBlogInitial()) {
    on<SearchEvent>(_getSearchBlogs);
    on<DeleteAllBlog>(_deleteAllBlog);
    
  }

  void _getSearchBlogs(SearchEvent event, Emitter<SearchBlogState> emit) async {
    if (event is SearchBlog) {
      emit(SearchBlogLoading());
      try {
        final res = await _searchRepository.searchBlogs(event.title!);
        emit(SearchBlogSuccess(blogs: res));
      } catch (e) {
        emit(SearchBlogFailure());
      }
    }
  }

  void _deleteAllBlog(DeleteAllBlog event, Emitter<SearchBlogState> emit)  {
    emit(SearchBlogSuccess(blogs: const[]));
  }
}