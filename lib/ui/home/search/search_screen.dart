import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_c20_dokki/api/api_manger.dart';
import 'package:news_c20_dokki/core/utils/context_extention.dart';
import 'package:news_c20_dokki/core/utils/numbers_extension.dart';
import 'package:news_c20_dokki/models/articles_response.dart';
import 'package:news_c20_dokki/ui/home/widgets/article_card.dart';
import 'package:news_c20_dokki/ui/home/widgets/article_preview_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiManger _apiManger = ApiManger();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Article> _articles = [];
  String? _error;
  bool _loading = false;
  bool _hasSearched = false;
  int _requestId = 0;

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _requestId++;
    if (value.trim().isEmpty) {
      setState(() {
        _articles = [];
        _error = null;
        _loading = false;
        _hasSearched = false;
      });
      return;
    }
    setState(() {
      _articles = [];
      _error = null;
      _loading = true;
      _hasSearched = true;
    });
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(value);
    });
  }

  Future<void> _search(String value) async {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) return;

    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final response = await _apiManger.searchArticles(query);
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _articles = response.articles ?? [];
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _articles = [];
        _loading = false;
        _error = _errorMessage(error);
      });
    }
  }

  String _errorMessage(Object error) {
    final responseData = error is DioException ? error.response?.data : null;
    if (responseData is Map && responseData['message'] is String) {
      return responseData['message'] as String;
    }
    return 'Could not load search results. Check your connection and API key.';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Search news',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _controller.clear();
                          _onQueryChanged('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_loading && _articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_hasSearched && !_loading && _articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }
    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Search for news by title, description, or content.',
            textAlign: TextAlign.center,
            style: context.text.titleMedium,
          ),
        ),
      );
    }

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _articles.length,
          separatorBuilder: (_, _) => 16.verticalSpace,
          itemBuilder: (context, index) {
            final article = _articles[index];
            return ArticleCard(
              article: article,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ArticlePreviewSheet(article: article),
              ),
            );
          },
        ),
        if (_loading)
          const Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
