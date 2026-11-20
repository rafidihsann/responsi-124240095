import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/spell.dart';

class ApiService {
  static const String _baseUrl =
      'https://potterapi-fedeperin.vercel.app/en/books';

  static Future<List<Character>> getCharacters() async {
    final response = await http.get(Uri.parse('$_baseUrl/characters'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Character.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<List<Spell>> getSpells() async {
    final response = await http.get(Uri.parse('$_baseUrl/spells'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Spell.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }
}
