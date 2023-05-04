import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Definition {
  String definition;
  List<String> syn;
  Definition(this.definition, this.syn);
}

class WordDefinition {
  List<Definition> definition;
  String lexicalCategory;

  WordDefinition(this.lexicalCategory, this.definition);
}

class DictionaryProvider with ChangeNotifier {
  String? _phoneticSpelling;
  bool? _isEmpty = false;

  bool? get isEmpty {
    return _isEmpty;
  }

  Map<String, WordDefinition> _data = {};

  String? get phoneticSpelling {
    return _phoneticSpelling;
  }

  Map<String, WordDefinition>? get data {
    return _data;
  }

  Future<void> getDefinitions(String text) async {
    final url = Uri.parse(
        "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20221114T111217Z.5b126bab68e62d3d.d885bc531d8eb3a2d5bb67f4574b122dedbc017d&lang=en-en&text=${text.trim()}");

    try {
      final response = await http.get(url);
      print(response.body);

      final Map<String, dynamic>? dictionary = await json.decode(response.body);
      if (!dictionary!["def"].isEmpty) {
        _phoneticSpelling = dictionary["def"]![0]["ts"];

        Map<String, WordDefinition> loadedWord = {};
        List<Definition> definitions = [];

        for (int i = 0; i < dictionary['def'][0]['tr'].length; i++) {
          List<String> examples = [];
          if (dictionary['def'][0]['tr'][i].containsKey('syn')) {
            for (int j = 0;
                j < dictionary['def'][0]['tr'][i]['syn'].length;
                j++) {
              examples.add(dictionary['def'][0]['tr'][i]['syn'][j]['text']);
            }
          }
          definitions
              .add(Definition(dictionary['def'][0]['tr'][i]['text'], examples));
        }
        loadedWord = {
          '0': WordDefinition(dictionary['def'][0]['pos'], definitions)
        };
        _data = loadedWord;
      } else {
        _isEmpty = true;
      }
    } catch (error) {
      rethrow;
    }
  }
}
