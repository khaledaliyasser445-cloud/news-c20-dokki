import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  const NewsWebView({super.key, required this.url});

  final String url;

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late final WebViewController controller;
  int loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.url);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => loadingProgress = progress);
          },
        ),
      );

    if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
      controller.loadRequest(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(widget.url);
    final validUrl =
        uri != null && (uri.scheme == 'https' || uri.scheme == 'http');

    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: validUrl
          ? Column(
              children: [
                if (loadingProgress < 100)
                  LinearProgressIndicator(value: loadingProgress / 100),
                Expanded(child: WebViewWidget(controller: controller)),
              ],
            )
          : const Center(child: Text('Invalid article URL')),
    );
  }
}
