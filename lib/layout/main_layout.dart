import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_bottom_nav.dart';
import '../screens/home_screen.dart';
import '../screens/add_word_screen.dart';
import '../screens/search_screen.dart';
import '../models/word.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  int _searchKey = 0;

  final List<Word> _words = [];
  final List<String> _savedFolders = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  List<String> get _folders {
    return _savedFolders.toList()..sort();
  }

  Future<void> _loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? wordsJson = prefs.getString('saved_words');
    final List<String>? foldersList = prefs.getStringList('saved_folders');
    
    bool needsSave = false;
    
    if (foldersList != null) {
      _savedFolders.clear();
      _savedFolders.addAll(foldersList);
    }
    
    if (wordsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(wordsJson);
        setState(() {
          _words.clear();
          _words.addAll(decoded.map((e) => Word.fromJson(e as Map<String, dynamic>)));
        });
        
        for (var w in _words) {
          for (var f in w.folders) {
            if (f.trim().isNotEmpty && !_savedFolders.contains(f.trim())) {
              _savedFolders.add(f.trim());
              needsSave = true;
            }
          }
        }
      } catch (e) {
        debugPrint('Error loading words: $e');
      }
    }
    
    if (needsSave) {
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_words.map((w) => w.toJson()).toList());
    await prefs.setString('saved_words', encoded);
    await prefs.setStringList('saved_folders', _savedFolders);
  }

  void _addWord(Word word) {
    setState(() {
      _words.insert(0, word);
      _currentIndex = 0;
      for (var f in word.folders) {
        if (f.trim().isNotEmpty && !_savedFolders.contains(f.trim())) {
          _savedFolders.add(f.trim());
        }
      }
    });
    _saveData();
  }

  void _removeWord(Word word) {
    setState(() {
      _words.remove(word);
    });
    _saveData();
  }

  void _editWord(Word oldWord, Word newWord) {
    setState(() {
      final index = _words.indexOf(oldWord);
      if (index != -1) {
        _words[index] = newWord;
        for (var f in newWord.folders) {
          if (f.trim().isNotEmpty && !_savedFolders.contains(f.trim())) {
            _savedFolders.add(f.trim());
          }
        }
      }
    });
    _saveData();
  }

  void _deleteFolder(String folderName, String action, String? targetFolder) {
    setState(() {
      _savedFolders.remove(folderName);
      
      if (action == 'deleteWords') {
        _words.removeWhere((w) => w.folders.contains(folderName));
      } else if (action == 'moveWords') {
        for (var w in _words) {
          if (w.folders.contains(folderName)) {
            w.folders.remove(folderName);
            if (targetFolder != null && !w.folders.contains(targetFolder)) {
              w.folders.add(targetFolder);
            }
          }
        }
      } else if (action == 'keepWords') {
        for (var w in _words) {
          w.folders.remove(folderName);
        }
      }
      _saveData();
    });
  }

  void _deleteWordsBulk(List<Word> wordsToDelete) {
    setState(() {
      _words.removeWhere((w) => wordsToDelete.contains(w));
      _saveData();
    });
  }

  void _moveWordsBulk(List<Word> wordsToMove, String sourceFolder, String targetFolder) {
    setState(() {
      for (var w in wordsToMove) {
        final index = _words.indexOf(w);
        if (index != -1) {
          _words[index].folders.remove(sourceFolder);
          if (!_words[index].folders.contains(targetFolder)) {
            _words[index].folders.add(targetFolder);
          }
        }
      }
      _saveData();
    });
  }

  void _goToAddWord() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _goToSearch() {
    setState(() {
      _searchKey++;
      _currentIndex = 2;
    });
  }

  void _goToVault() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        words: _words,
        onGiftWord: _goToAddWord,
        onViewAll: _goToSearch,
        onRemoveWord: _removeWord,
        onGoToVault: _goToVault,
      ),
      AddWordScreen(
        onAddWord: _addWord,
        isFirstWord: _words.isEmpty,
        existingFolders: _folders,
        onGoToVault: _goToVault,
      ),
      SearchScreen(
        key: ValueKey(_searchKey),
        words: _words,
        foldersList: _folders,
        onRemoveWord: _removeWord,
        onEditWord: _editWord,
        onGoToVault: _goToVault,
        onDeleteFolder: _deleteFolder,
        onDeleteWordsBulk: _deleteWordsBulk,
        onMoveWordsBulk: _moveWordsBulk,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (_currentIndex == index && index == 2) {
              _searchKey++;
            }
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
