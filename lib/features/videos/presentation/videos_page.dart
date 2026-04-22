import 'package:flutter/material.dart';
import '../data/videos_service.dart';
import '../models/video_model.dart';
import 'video_player_page.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final VideosService service = VideosService();
  late Future<List<VideoModel>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = service.getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos Educativos'),
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final videos = snapshot.data ?? [];

          if (videos.isEmpty) {
            return const Center(
              child: Text('No hay videos disponibles'),
            );
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: video.thumbnail.isNotEmpty
                      ? Image.network(
                          video.thumbnail,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.video_library),
                        )
                      : const Icon(Icons.video_library),
                  title: Text(video.titulo),
                  subtitle: Text(video.categoria),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(video: video),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}