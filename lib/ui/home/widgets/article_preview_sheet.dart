import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c20_dokki/core/providers/app_config_provider.dart';
import 'package:news_c20_dokki/core/utils/context_extention.dart';
import 'package:news_c20_dokki/core/utils/widget_extension.dart';
import 'package:news_c20_dokki/models/articles_response.dart';
import 'package:news_c20_dokki/ui/web_view/news_web.dart';
import 'package:provider/provider.dart';

class ArticlePreviewSheet extends StatelessWidget {
  final Article article;

  const ArticlePreviewSheet({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppConfigProvider>();
    final fallbackImage =
        'assets/images/news_logo_${provider.isDarkMode ? 'dark' : 'light'}.png';

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 440,
            maxHeight: MediaQuery.sizeOf(context).height * .62,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _articleImage(
                  article.urlToImage,
                  fallbackImage,
                  height: (MediaQuery.sizeOf(context).width * .58)
                      .clamp(120.0, 230.0)
                      .toDouble(),
                ),
                const SizedBox(height: 6),
                Text(
                  article.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.description ?? article.content ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: provider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      foregroundColor: provider.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: article.url?.isNotEmpty == true
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    NewsWebView(url: article.url!),
                              ),
                            )
                        : null,
                    child: const Text('View Full Article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _articleImage(String? imageUrl, String fallbackImage, {double? height}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Image.asset(
      fallbackImage,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    ).clip(12);
  }
  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: double.infinity,
    height: height,
    fit: BoxFit.cover,
    placeholder: (_, _) => Image.asset(
      fallbackImage,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    ),
    errorWidget: (_, _, _) => Image.asset(
      fallbackImage,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
    ),
  ).clip(12);
}
