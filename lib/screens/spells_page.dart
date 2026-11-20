import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../api/api_service.dart';
import '../models/spell.dart';
import '../services/notification_service.dart';
import 'favorite_spells_page.dart';

class SpellsPage extends StatefulWidget {
  const SpellsPage({super.key});

  @override
  State<SpellsPage> createState() => _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  List<Spell> spells = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSpells();
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

    // Hitung tinggi area body di dalam Scaffold (antara AppBar dan BottomNavigationBar)
    final availableHeight = screenHeight -
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

  Future<void> fetchSpells() async {
    try {
      final data = await ApiService.getSpells();
      if (mounted) {
        setState(() {
          spells = data;
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

  void _toggleFavorite(Spell spell) {
    final box = Hive.box<Spell>('favorite_spells');
    final isFav = box.containsKey(spell.index);

    if (isFav) {
      box.delete(spell.index);
      NotificationService().showInstantNotification(
        title: 'Delete notification',
        body: 'You deleted ${spell.spell} from your fav list!',
      );
      _showTopSnackBar(
        title: 'Remove!',
        message: 'Dihapus dari favorit',
        backgroundColor: Colors.red,
      );
    } else {
      box.put(spell.index, spell);
      _showTopSnackBar(
        title: 'Add!',
        message: 'Ditambahkan ke favorit',
        backgroundColor: Colors.green,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final box = Hive.box<Spell>('favorite_spells');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoriteSpellsPage(),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.favorite),
              label: const Text('Lihat Favorite'),
            ),
          ),
        ),
        Expanded(
          child: spells.isEmpty
              ? const Center(
                  child: Text('Data sihir tidak ditemukan'),
                )
              : ListView.builder(
                  itemCount: spells.length,
                  itemBuilder: (context, index) {
                    final spell = spells[index];
                    final isFavorite = box.containsKey(spell.index);

                    return ListTile(
                      title: Text(
                        spell.spell,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(spell.use),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.yellow,
                        ),
                        onPressed: () => _toggleFavorite(spell),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
