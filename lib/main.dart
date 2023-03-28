import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'network/get_images_url.dart';

final imageUrlsProvider = StateProvider<List<String>>((ref) => GetImagesUrl.picsum());

class ImageGrid extends HookConsumerWidget {
  const ImageGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urls = ref.watch(imageUrlsProvider);
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(urls.length, (index) {
        return GestureDetector(
          onTap: () async {
            final response = await http.get(Uri.parse(urls[index]));
            final bytes = response.bodyBytes;
            await ImageGallerySaver.saveImage(bytes);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved to gallery')));
          },
          child: Image.network(
            urls[index],
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }
}
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
          title: 'Random images downloader',
          home: ScaffoldMessenger(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Random images downloader with hooks_riverpod'),
              ),
              body: const ImageGrid(),
            ),
          )
      ),
    ),
  );
}