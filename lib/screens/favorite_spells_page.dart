import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell.dart';
import '../services/notification_service.dart';

class FavoriteSpellsPage extends StatefulWidget {
  const FavoriteSpellsPage({super.key});

  @override
  State<FavoriteSpellsPage> createState() => _FavoriteSpellsPageState();
}

class _FavoriteSpellsPageState extends State<FavoriteSpellsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermission();
    });
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

    // Di FavoriteSpellsPage, ada AppBar tapi tidak ada BottomNavigationBar
    final availableHeight = screenHeight - topPadding - kToolbarHeight - bottomPadding;
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

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Spell>('favorite_spells');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spell'),
      ),
      body: ValueListenableBuilder<Box<Spell>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Belum ada spell favorit'),
            );
          }

          final favoriteList = box.values.toList();

          return ListView.builder(
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final spell = favoriteList[index];

              return ListTile(
                leading: const Icon(Icons.auto_stories),
                title: Text(
                  spell.spell,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(spell.use),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final spellName = spell.spell;
                    await box.delete(spell.index);
                    await NotificationService().showInstantNotification(
                      title: 'Delete notification',
                      body: 'You deleted $spellName from your fav list!',
                    );
                    if (context.mounted) {
                      _showTopSnackBar(
                        title: 'Remove!',
                        message: '$spellName dihapus dari favorit',
                        backgroundColor: Colors.red,
                      );
                    }
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
