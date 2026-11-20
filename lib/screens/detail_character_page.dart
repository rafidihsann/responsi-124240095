import 'package:flutter/material.dart';

import '../models/character.dart';

class DetailCharacterPage extends StatelessWidget {
  final Character character;

  const DetailCharacterPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // final childrenText = character.children.isNotEmpty
    //     ? character.children.join(', ')
    //     : 'Tidak ada';

    // final interpretedByText = character.interpretedBy.isNotEmpty
    //     ? character.interpretedBy
    //     : '-';

    // final nicknameText = character.nickname.isNotEmpty
    //     ? character.nickname
    //     : '-';

    final birthdateText = character.releaseDate.isNotEmpty
        ? character.releaseDate
        : '-';

    final houseText = character.description.isNotEmpty
        ? character.description
        : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(character.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              character.cover,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(Icons.person, size: 100),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Lengkap: ${character.title}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   'Nama Panggilan: $nicknameText',
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    'Asrama: $houseText',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Diperankan oleh: $interpretedByText',
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    'Tanggal Lahir: $birthdateText',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'Anak: $childrenText',
                  //   style: const TextStyle(fontSize: 16),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    'Index: ${character.index}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
