class Character {
  final int number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String description;
  final int pages;
  final String cover;
  final int index;

  Character({
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.description,
    required this.cover,
    required this.pages,
    required this.index,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      number: json['number'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['originalTitle'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      description: json['description'] ?? '',
      cover: json['cover'] ?? '',
      pages: json['pages'] ?? 0,
      index: json['index'] ?? 0,
    );
  }
}

//               ?.map((e) => e.toString())
//               .toList() ??
//           [],
//       image: json['cover'] ?? '',
//       releaseDate: json['releaseDate'] ?? '',
//       index: json['index'] ?? 0,
//     );
//   }
// }
