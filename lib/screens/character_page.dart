import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/character.dart';
import 'detail_character_page.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  List<Character> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  void _showTopSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    final availableHeight =
        screenHeight -
        topPadding -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        bottomPadding -
        keyboardHeight;

    final bottomMargin = availableHeight > 100 ? (availableHeight - 85) : 16.0;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: 16,
          right: 16,
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCharacters() async {
    try {
      final data = await ApiService.getCharacters();
      if (mounted) {
        setState(() {
          characters = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showTopSnackBar(
          title: 'Error!',
          message: 'Gagal memuat data, cek internet',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (characters.isEmpty) {
      return const Center(
        child: Text('Data karakter tidak ditemukan'),
      );
    }

    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        final subtitleText = character.title.isNotEmpty
            ? '${character.title} - ${character.releaseDate}'
            : character.releaseDate;

        return ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRect(
              child: Image.network(
                character.cover,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 50);
                },
              ),
            ),
          ),
          title: Text(character.title),
          subtitle: Text(subtitleText),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailCharacterPage(character: character),
              ),
            );
          },
        );
      },
    );

    // ============================================================
    // [PILIHAN 1: TAMPILAN GRID 2 KOLOM] - AKTIF
    // Untuk beralih ke LIST: berikan komentar (/* ... */) pada blok ini,
    // lalu buka komentar (hapus /* dan */) pada PILIHAN 2 di bawah.
    // ============================================================
    // ============================================================
    // [AKHIR PILIHAN 1: GRID]
    // ============================================================

    /*
    // ============================================================
    // [PILIHAN 2: TAMPILAN LIST 1 KOLOM] - NON-AKTIF
    // Untuk mengaktifkan: hapus tanda /* di atas judul ini dan */ di bagian akhir.

    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        final subtitleText = character.nickname.isNotEmpty
            ? '${character.nickname} - ${character.hogwartsHouse}'
            : character.hogwartsHouse;

        return ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRect(
              child: Image.network(
                character.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 50);
                },
              ),
            ),
          ),
          title: Text(character.fullName),
          subtitle: Text(subtitleText),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailCharacterPage(character: character),
              ),
            );
          },
        );
      },
    );
    // ============================================================
    // [AKHIR PILIHAN 2: LIST]
    // ============================================================
    */
  }
}
