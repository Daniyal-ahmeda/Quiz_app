import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/features/profile/data/character_repository.dart';
import 'package:quiz_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:quiz_app/features/profile/data/models/character_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _repository = locator<CharacterRepository>();

  @override
  void initState() {
    super.initState();
    // Fetch latest data when page opens
    _repository.fetchCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Character'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ).then((_) => _repository.fetchCharacter());
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _repository,
        builder: (context, _) {
          if (_repository.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final character = _repository.character;
          if (character == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No character found."),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EditProfilePage()),
                      ).then((_) => _repository.fetchCharacter());
                    },
                    child: const Text("Create Character"),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: character.imagePath.isNotEmpty
                      ? CachedNetworkImageProvider(character.imagePath)
                      : null,
                  child: character.imagePath.isEmpty
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 24),
                Text(
                  character.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  character.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildStatsGrid(character),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Character character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Stats",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: character.stats.length,
          itemBuilder: (context, index) {
            final key = character.stats.keys.elementAt(index);
            final value = character.stats[key];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart, color: Colors.blue),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(key,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(value.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
