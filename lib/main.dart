import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'network/get_images_url.dart';


final imageUrlsProvider = FutureProvider<List<String>>((ref) => GetImagesUrl.unsplash());

class ImageGrid extends HookConsumerWidget {
  ImageGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlsAsync = ref.watch(imageUrlsProvider);

    return urlsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error loading images: $error')),
      data: (urls) => GridView.count(
        crossAxisCount: 2,
        children: List.generate(urls.length, (index) {
          return GestureDetector(
            onTap: () async {
              final response = await http.get(Uri.parse(urls[index]));
              final bytes = response.bodyBytes;
              await ImageGallerySaver.saveImage(bytes);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved to gallery')));
            },
            onDoubleTap: () {
              ref.refresh(imageUrlsProvider);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Regenerating images')));
            },
            child: Image.network(
              urls[index],
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
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
            body: ImageGrid(),
          ),
        ),
      ),
    ),
  );
}