import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';
import '../models/word.dart';
import 'settings_screen.dart';
import 'add_word_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Word> words;
  final List<String> foldersList;
  final void Function(Word) onRemoveWord;
  final void Function(Word, Word) onEditWord;
  final VoidCallback? onGoToVault;
  final void Function(String folderName, String action, String? targetFolder) onDeleteFolder;
  final void Function(List<Word>) onDeleteWordsBulk;
  final void Function(List<Word>, String sourceFolder, String targetFolder) onMoveWordsBulk;

  const SearchScreen({
    super.key, 
    required this.words, 
    required this.foldersList,
    required this.onRemoveWord, 
    required this.onEditWord, 
    this.onGoToVault,
    required this.onDeleteFolder,
    required this.onDeleteWordsBulk,
    required this.onMoveWordsBulk,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchTerm = false;
  String? _selectedFilterType;
  String? _viewingFolderId;
  final List<String> _wordTypes = ['All', 'Noun', 'Verb', 'Adj', 'Adverb', 'Pronoun', 'Prep', 'Conj', 'Interj'];

  bool _isSelectionMode = false;
  final Set<Word> _selectedWords = {};

  List<String> get _folders => widget.foldersList;

  String _getLocalizedWordType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'All': return l10n.all;
      case 'Noun': return l10n.noun;
      case 'Verb': return l10n.verb;
      case 'Adj': return l10n.adjective;
      case 'Adverb': return l10n.adverb;
      case 'Pronoun': return l10n.pronoun;
      case 'Prep': return l10n.preposition;
      case 'Conj': return l10n.conjunction;
      case 'Interj': return l10n.interjection;
      default: return type;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _hasSearchTerm = _searchController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Word> get _filteredWords {
    final query = _searchController.text.trim().toLowerCase();
    
    var filtered = widget.words;
    
    if (_selectedFilterType != null && _selectedFilterType != 'All') {
      filtered = filtered.where((w) => w.types.contains(_selectedFilterType)).toList();
    }
    
    if (query.isNotEmpty) {
      filtered = filtered.where((w) {
        return w.english.toLowerCase().contains(query) ||
               w.arabic.toLowerCase().contains(query);
      }).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredWords;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.outlineVariant, height: 2),
        ),
        leading: InkWell(
          onTap: widget.onGoToVault,
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.pets, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(l10n.wordVault, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
        leadingWidth: 200,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.tertiary, width: 3),
                boxShadow: const [
                  BoxShadow(color: AppColors.tertiary, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.tertiary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTypography.bodyLarge.copyWith(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        hintStyle: AppTypography.bodyLarge.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.outline.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_hasSearchTerm)
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.outline),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      _selectedFilterType != null && _selectedFilterType != 'All' 
                          ? Icons.filter_list_alt 
                          : Icons.filter_list,
                      color: _selectedFilterType != null && _selectedFilterType != 'All' 
                          ? AppColors.primary 
                          : AppColors.outline,
                    ),
                    onSelected: (String result) {
                      setState(() {
                        _selectedFilterType = result;
                      });
                    },
                    itemBuilder: (BuildContext context) => _wordTypes.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          _getLocalizedWordType(context, choice),
                          style: AppTypography.bodyMedium.copyWith(
                            color: _selectedFilterType == choice ? AppColors.primary : AppColors.onSurfaceVariant,
                            fontWeight: _selectedFilterType == choice ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Content
            Expanded(
              child: _buildContent(context, results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Word> results) {
    if (_hasSearchTerm) {
      return results.isEmpty ? _buildEmptyState(context) : _buildResultsState(context, results);
    } else {
      if (_viewingFolderId == null) {
        return _buildFoldersState(context);
      } else {
        final folderResults = results.where((w) {
          if (_viewingFolderId == '__UNSORTED__') {
            return w.folders.isEmpty;
          }
          return w.folders.contains(_viewingFolderId);
        }).toList();

        final l10n = AppLocalizations.of(context)!;
        return Column(
          children: [
            Align(
              alignment: Directionality.of(context) == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _viewingFolderId = null;
                        _isSelectionMode = false;
                        _selectedWords.clear();
                      });
                    },
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    label: Text(l10n.backToFolders, style: AppTypography.labelBold.copyWith(color: AppColors.primary)),
                  ),
                  if (_isSelectionMode)
                    Text('${_selectedWords.length} ${l10n.selectionMode}', style: AppTypography.labelBold.copyWith(color: AppColors.tertiary)),
                ],
              ),
            ),
            if (_isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _selectedWords.isEmpty ? null : () {
                        widget.onDeleteWordsBulk(_selectedWords.toList());
                        setState(() {
                          _isSelectionMode = false;
                          _selectedWords.clear();
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(l10n.deleteSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.onError,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _selectedWords.isEmpty ? null : () {
                        _showMoveWordsDialog(context);
                      },
                      icon: const Icon(Icons.drive_file_move),
                      label: Text(l10n.moveSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiary,
                        foregroundColor: AppColors.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: folderResults.isEmpty ? _buildEmptyState(context) : _buildResultsState(context, folderResults),
            ),
          ],
        );
      }
    }
  }

  Widget _buildFoldersState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final folders = _folders;
    final unsortedCount = widget.words.where((w) => w.folders.isEmpty).length;
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: folders.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildFolderCard(l10n.unsorted, '__UNSORTED__', unsortedCount);
        }
        final folderName = folders[index - 1];
        final count = widget.words.where((w) => w.folders.contains(folderName)).length;
        return _buildFolderCard(folderName, folderName, count);
      },
    );
  }

  Color _getFolderColor(String folderName) {
    if (folderName == '__UNSORTED__') {
      return AppColors.surfaceContainer;
    }
    final int hash = folderName.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    
    // Create a pastel color
    return Color.fromARGB(255, (r + 255) ~/ 2, (g + 255) ~/ 2, (b + 255) ~/ 2);
  }

  Widget _buildFolderCard(String title, String folderId, int count) {
    final bgColor = _getFolderColor(folderId);
    
    return InkWell(
      onTap: () {
        setState(() {
          _viewingFolderId = folderId;
          _isSelectionMode = false;
          _selectedWords.clear();
        });
      },
      onLongPress: folderId == '__UNSORTED__' ? null : () {
        _showDeleteFolderDialog(context, folderId);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
          boxShadow: [
            BoxShadow(color: AppColors.outline.withOpacity(0.5), offset: const Offset(2, 4)),
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder, size: 48, color: folderId == '__UNSORTED__' ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title, 
                style: AppTypography.labelBold.copyWith(fontSize: 16, color: AppColors.onSurfaceVariant), 
                textAlign: TextAlign.center, 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis
              ),
            ),
            Text('$count', style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: Image.asset(
            _hasSearchTerm ? 'assets/images/not_found.png' : 'assets/images/empty_vault.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60, color: AppColors.outlineVariant),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _hasSearchTerm ? l10n.searchNoWordsFound : l10n.searchVaultEmpty, 
          style: AppTypography.labelBold.copyWith(color: AppColors.primary, fontSize: 18)
        ),
        const SizedBox(height: 8),
        Text(
          _hasSearchTerm ? l10n.tryDifferentSearchTerm : l10n.goToAddTab,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildResultsState(BuildContext context, List<Word> results) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _hasSearchTerm ? '${l10n.foundPrefix}${results.length}${l10n.resultsSuffix}' : '${l10n.allWordsPrefix}(${results.length})', 
              style: AppTypography.labelBold.copyWith(color: AppColors.outline, fontSize: 12)
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/Pip_1.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final word = results[index];
              return _buildResultCard(word);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Word word) {
    final isSelected = _isSelectionMode && _selectedWords.contains(word);
    
    return InkWell(
      onLongPress: () {
        if (_viewingFolderId != null) {
          setState(() {
            _isSelectionMode = true;
            _selectedWords.add(word);
          });
        }
      },
      onTap: () {
        if (_isSelectionMode) {
          setState(() {
            if (_selectedWords.contains(word)) {
              _selectedWords.remove(word);
              if (_selectedWords.isEmpty) {
                _isSelectionMode = false;
              }
            } else {
              _selectedWords.add(word);
            }
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiary.withOpacity(0.1) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.tertiary : AppColors.outline, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.outline, offset: Offset(0, 4)),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(word.english, style: AppTypography.headlineMediumMobile),
                        const SizedBox(height: 4),
                        Text(word.types.join(' / '), style: AppTypography.bodyMedium.copyWith(color: AppColors.outline, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    Text(word.arabic, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    onPressed: () {
                      _openEditScreen(context, word);
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.outline),
                    onPressed: () {
                      widget.onRemoveWord(word);
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
          if (word.sentences.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(height: 2, color: AppColors.outlineVariant.withOpacity(0.5)),
            const SizedBox(height: 12),
            ...word.sentences.map((sentenceObj) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(right: 8, top: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tertiary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  sentenceObj.type.toUpperCase(),
                                  style: AppTypography.labelBold.copyWith(fontSize: 10, color: AppColors.tertiary),
                                ),
                              ),
                              Expanded(
                                child: _buildHighlightedSentence(sentenceObj.english, word.english),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sentenceObj.arabic,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.secondary),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
      ),
    );
  }

  void _openEditScreen(BuildContext context, Word word) {
    final Set<String> folders = {};
    folders.addAll(widget.foldersList);
    for (var w in widget.words) {
      for (var folder in w.folders) {
        if (folder.trim().isNotEmpty) {
          folders.add(folder.trim());
        }
      }
    }
    final existingFolders = folders.toList()..sort();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddWordScreen(
          editWord: word,
          existingFolders: existingFolders,
          onAddWord: (updatedWord) {
            widget.onEditWord(word, updatedWord);
            Navigator.pop(context);
          },
          isFirstWord: false,
        ),
      ),
    );
  }

  Widget _buildHighlightedSentence(String sentence, String targetWord) {
    if (targetWord.isEmpty) {
      return Text(sentence, style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant));
    }

    final regex = RegExp('(${RegExp.escape(targetWord)})', caseSensitive: false);
    final spans = <TextSpan>[];

    sentence.splitMapJoin(
      regex,
      onMatch: (m) {
        spans.add(TextSpan(
          text: m.group(0),
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ));
        return '';
      },
      onNonMatch: (n) {
        spans.add(TextSpan(
          text: n,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ));
        return '';
      },
    );

    return RichText(text: TextSpan(children: spans));
  }

  void _showDeleteFolderDialog(BuildContext context, String folderName) {
    final l10n = AppLocalizations.of(context)!;
    String selectedAction = 'keepWords';
    String? selectedTargetFolder;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceBright,
              title: Text(l10n.deleteFolderTitle, style: AppTypography.headlineMediumMobile.copyWith(fontSize: 20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.deleteFolderKeepWords, style: AppTypography.bodyMedium),
                    value: 'keepWords',
                    groupValue: selectedAction,
                    onChanged: (val) => setStateSB(() => selectedAction = val!),
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.deleteFolderDeleteWords, style: AppTypography.bodyMedium),
                    value: 'deleteWords',
                    groupValue: selectedAction,
                    onChanged: (val) => setStateSB(() => selectedAction = val!),
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.deleteFolderMoveWords, style: AppTypography.bodyMedium),
                    value: 'moveWords',
                    groupValue: selectedAction,
                    onChanged: (val) => setStateSB(() => selectedAction = val!),
                  ),
                  if (selectedAction == 'moveWords')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedTargetFolder,
                        hint: Text(l10n.moveWordsTo),
                        items: widget.foldersList
                            .where((f) => f != folderName)
                            .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (val) => setStateSB(() => selectedTargetFolder = val),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancel, style: AppTypography.labelBold.copyWith(color: AppColors.outlineVariant)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedAction == 'moveWords' && selectedTargetFolder == null) {
                      return; // Must select target
                    }
                    widget.onDeleteFolder(folderName, selectedAction, selectedTargetFolder);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                  child: Text(l10n.delete, style: AppTypography.labelBold.copyWith(color: AppColors.onError)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _showMoveWordsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String? selectedTargetFolder;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceBright,
              title: Text(l10n.moveWordsTo, style: AppTypography.headlineMediumMobile.copyWith(fontSize: 20)),
              content: DropdownButton<String>(
                isExpanded: true,
                value: selectedTargetFolder,
                hint: Text(l10n.selectFolder),
                items: widget.foldersList
                    .where((f) => f != _viewingFolderId)
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (val) => setStateSB(() => selectedTargetFolder = val),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancel, style: AppTypography.labelBold.copyWith(color: AppColors.outlineVariant)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedTargetFolder != null && _viewingFolderId != null) {
                      widget.onMoveWordsBulk(_selectedWords.toList(), _viewingFolderId!, selectedTargetFolder!);
                      setState(() {
                        _isSelectionMode = false;
                        _selectedWords.clear();
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiary),
                  child: Text(l10n.move, style: AppTypography.labelBold.copyWith(color: AppColors.onSecondary)),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
