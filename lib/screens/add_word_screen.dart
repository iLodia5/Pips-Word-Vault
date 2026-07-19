import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../models/word.dart';
import '../widgets/sprite_animation.dart';
import 'package:pip_word_vault/l10n/app_localizations.dart';
import 'settings_screen.dart';

class SentenceInput {
  final TextEditingController englishController = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  String selectedType = 'Noun';

  void dispose() {
    englishController.dispose();
    arabicController.dispose();
  }
}

class AddWordScreen extends StatefulWidget {
  final Function(Word) onAddWord;
  final bool isFirstWord;
  final Word? editWord;
  final List<String> existingFolders;
  final VoidCallback? onGoToVault;

  const AddWordScreen({
    super.key,
    required this.onAddWord,
    required this.isFirstWord,
    required this.existingFolders,
    this.editWord,
    this.onGoToVault,
  });

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _englishController = TextEditingController();
  final _arabicController = TextEditingController();
  
  final List<String> _wordTypes = ['Noun', 'Verb', 'Adj', 'Adverb', 'Pronoun', 'Prep', 'Conj', 'Interj'];
  final List<String> _selectedTypes = ['Noun'];

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
  
  final List<SentenceInput> _sentenceInputs = [SentenceInput()];
  
  bool _isCheeringActive = false;
  bool _isAnimatingCheer = false;
  
  final List<String> _selectedFolders = [];
  final _newFolderController = TextEditingController();
  late List<String> _folders;

  @override
  void initState() {
    super.initState();
    if (widget.editWord != null) {
      _englishController.text = widget.editWord!.english;
      _arabicController.text = widget.editWord!.arabic;
      _selectedTypes.clear();
      _selectedTypes.addAll(widget.editWord!.types);
      _sentenceInputs.clear();
      if (widget.editWord!.sentences.isEmpty) {
        _sentenceInputs.add(SentenceInput());
      } else {
        for (var s in widget.editWord!.sentences) {
          final input = SentenceInput();
          input.englishController.text = s.english;
          input.arabicController.text = s.arabic;
          input.selectedType = s.type;
          _sentenceInputs.add(input);
        }
      }
      
      _selectedFolders.clear();
      _selectedFolders.addAll(widget.editWord!.folders);
      _folders = List.from(widget.existingFolders);
      for (var f in _selectedFolders) {
        if (!_folders.contains(f)) {
          _folders.add(f);
        }
      }
    } else {
      _folders = List.from(widget.existingFolders);
    }
  }

  @override
  void dispose() {
    _englishController.dispose();
    _arabicController.dispose();
    _newFolderController.dispose();
    for (var input in _sentenceInputs) {
      input.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isFirstWord) {
      precacheImage(const AssetImage('assets/images/Cheering-ezgif.com-gif-to-sprite-converter.png'), context);
    }
  }

  void _addSentenceField() {
    setState(() {
      _sentenceInputs.add(SentenceInput());
    });
  }

  void _removeSentenceField(int index) {
    setState(() {
      if (_sentenceInputs.length > 1) {
        _sentenceInputs[index].dispose();
        _sentenceInputs.removeAt(index);
      } else {
        _sentenceInputs[0].englishController.clear();
        _sentenceInputs[0].arabicController.clear();
        _sentenceInputs[0].selectedType = 'Noun';
      }
    });
  }

  void _carveWord() async {
    final l10n = AppLocalizations.of(context)!;
    if (_englishController.text.trim().isEmpty || _arabicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorEnterWords)),
      );
      return;
    }
    
    if (_selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSelectWordType)),
      );
      return;
    }
    
    final sentences = _sentenceInputs
        .where((input) => input.englishController.text.trim().isNotEmpty || input.arabicController.text.trim().isNotEmpty)
        .map((input) => ExampleSentence(
              english: input.englishController.text.trim(),
              arabic: input.arabicController.text.trim(),
              type: input.selectedType,
            ))
        .toList();

    final newWord = Word(
      english: _englishController.text.trim(),
      arabic: _arabicController.text.trim(),
      types: List.from(_selectedTypes),
      hasBookmark: false,
      folders: List.from(_selectedFolders),
      sentences: sentences,
    );
    
    final isFirst = widget.isFirstWord && widget.editWord == null;

    if (isFirst) {
      setState(() {
        _isCheeringActive = true;
      });
      // Give the framework a slightly longer moment to mount the heavy GIF before sliding
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _isAnimatingCheer = true;
        });
      }
      await Future.delayed(const Duration(milliseconds: 2670));
      if (mounted) {
        setState(() {
          _isAnimatingCheer = false;
        });
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) {
          setState(() {
            _isCheeringActive = false;
          });
        }
      }
    }

    widget.onAddWord(newWord);
    
    _englishController.clear();
    _arabicController.clear();
    _newFolderController.clear();
    setState(() {
      _selectedFolders.clear();
      _selectedTypes.clear();
      _selectedTypes.add('Noun');
      for (var input in _sentenceInputs) {
        input.dispose();
      }
      _sentenceInputs.clear();
      _sentenceInputs.add(SentenceInput());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.outlineVariant, height: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.pets, color: AppColors.primary),
          onPressed: widget.onGoToVault,
        ),
        title: Text(l10n.wordVault, style: AppTypography.headlineMediumMobile.copyWith(color: AppColors.secondary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.secondary),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.editWord != null ? l10n.editWord : l10n.giftPipNewWord, style: AppTypography.headlineMedium),
            const SizedBox(height: 16),
            // Illustration Box
            Transform.rotate(
              angle: -0.035,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline, width: 4),
                  boxShadow: const [
                    BoxShadow(color: AppColors.outline, offset: Offset(2, 4)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/Pip_3.png.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 60, color: AppColors.outlineVariant),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // English Word
            _buildInputSection(l10n.englishWord, l10n.egEthereal, false, _englishController),
            const SizedBox(height: 16),
            // Arabic Translation
            _buildInputSection(l10n.arabicTranslation, l10n.egArabic, true, _arabicController),
            const SizedBox(height: 24),
            // Folder Selection
            _buildFolderSection(context),
            const SizedBox(height: 24),
            // Word Types (Multi-select)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(l10n.wordTypes, style: AppTypography.labelBold),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _wordTypes.map((type) {
                    final isSelected = _selectedTypes.contains(type);
                    return FilterChip(
                      label: Text(_getLocalizedWordType(context, type)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTypes.add(type);
                          } else {
                            _selectedTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: AppColors.tertiary.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.tertiary,
                      labelStyle: AppTypography.labelBold.copyWith(
                        color: isSelected ? AppColors.tertiary : AppColors.onSurfaceVariant,
                      ),
                      backgroundColor: AppColors.surfaceBright,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? AppColors.tertiary : AppColors.outlineVariant,
                          width: 2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Example Sentences
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                border: Border.all(color: AppColors.outlineVariant, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note, color: AppColors.tertiary),
                          const SizedBox(width: 8),
                          Text(l10n.exampleSentences, style: AppTypography.labelBold),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceBright,
                          border: Border.all(color: AppColors.secondary, width: 2),
                          boxShadow: const [
                            BoxShadow(color: AppColors.secondary, offset: Offset(2, 3)),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: AppColors.secondary),
                          onPressed: _addSentenceField,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          padding: EdgeInsets.zero,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_sentenceInputs.length, (index) {
                    final input = _sentenceInputs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          border: Border.all(color: AppColors.outlineVariant, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: AppColors.outlineVariant, offset: Offset(1, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${l10n.example} ${index + 1}', style: AppTypography.labelBold.copyWith(color: AppColors.primary)),
                                GestureDetector(
                                  onTap: () => _removeSentenceField(index),
                                  child: const Icon(Icons.close, color: AppColors.outline, size: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // English Sentence
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.outlineVariant, width: 1),
                              ),
                              child: TextField(
                                controller: input.englishController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]')),
                                ],
                                decoration: InputDecoration(
                                  hintText: l10n.englishSentence,
                                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outlineVariant),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Arabic Sentence
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.outlineVariant, width: 1),
                              ),
                              child: TextField(
                                controller: input.arabicController,
                                textDirection: TextDirection.rtl,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                                ],
                                decoration: InputDecoration(
                                  hintText: l10n.arabicTranslationSentence,
                                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outlineVariant),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Sentence Word Type
                            Row(
                              children: [
                                Text(l10n.wordRoleInSentence, style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLowest,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.outlineVariant, width: 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: input.selectedType,
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                                        style: AppTypography.bodyLarge,
                                        dropdownColor: AppColors.surfaceContainerLowest,
                                        items: _wordTypes.map((type) {
                                          return DropdownMenuItem(
                                            value: type,
                                            child: Text(_getLocalizedWordType(context, type)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              input.selectedType = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Carve into Vault Button
            GestureDetector(
              onTap: _carveWord,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF5A3A22), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF5A3A22), offset: Offset(0, 6)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFFFDCC5)),
                    const SizedBox(width: 12),
                    Text(
                      widget.editWord != null ? l10n.updateWord : l10n.carveIntoVault,
                      style: AppTypography.headlineSmall.copyWith(color: AppColors.onSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
    if (_isCheeringActive)
      Positioned.fill(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: _isAnimatingCheer ? Colors.black.withValues(alpha: 0.6) : Colors.transparent,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              bottom: _isAnimatingCheer ? -90 : -MediaQuery.of(context).size.height,
              left: -150,
              right: -150,
              child: IgnorePointer(
                child: SpriteAnimation(
                  key: UniqueKey(),
                  image: const AssetImage('assets/images/Cheering-ezgif.com-gif-to-sprite-converter.png'),
                  columns: 5,
                  rows: 13,
                  totalFrames: 64,
                  duration: const Duration(milliseconds: 2670),
                  loop: false,
                  height: MediaQuery.of(context).size.height * 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildInputSection(String label, String hint, bool isRtl, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(label, style: AppTypography.labelBold),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline, width: 2),
            boxShadow: const [
              BoxShadow(color: AppColors.outline, offset: Offset(2, 4)),
            ],
          ),
          child: TextField(
            controller: controller,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            inputFormatters: [
              if (isRtl)
                FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]'))
              else
                FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]')),
            ],
            style: AppTypography.headlineSmall,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.outlineVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFolderSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(l10n.folders, style: AppTypography.labelBold),
        ),
        if (_folders.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _folders.map((folder) {
              final isSelected = _selectedFolders.contains(folder);
              return FilterChip(
                label: Text(folder),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFolders.add(folder);
                    } else {
                      _selectedFolders.remove(folder);
                    }
                  });
                },
                selectedColor: AppColors.tertiary.withOpacity(0.2),
                checkmarkColor: AppColors.tertiary,
                labelStyle: AppTypography.labelBold.copyWith(
                  color: isSelected ? AppColors.tertiary : AppColors.onSurfaceVariant,
                ),
                backgroundColor: AppColors.surfaceBright,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? AppColors.tertiary : AppColors.outlineVariant,
                    width: 2,
                  ),
                ),
              );
            }).toList(),
          ),
        if (_folders.isNotEmpty) const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant, width: 2),
                ),
                child: TextField(
                  controller: _newFolderController,
                  style: AppTypography.bodyMedium,
                  decoration: InputDecoration(
                    hintText: l10n.createNewFolder,
                    hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.outlineVariant, fontStyle: FontStyle.italic),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary,
                boxShadow: const [
                  BoxShadow(color: AppColors.outline, offset: Offset(1, 2)),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: AppColors.onSecondary),
                onPressed: () {
                  final newFolder = _newFolderController.text.trim();
                  if (newFolder.isNotEmpty && !_folders.contains(newFolder)) {
                    setState(() {
                      _folders.add(newFolder);
                      _selectedFolders.add(newFolder);
                      _newFolderController.clear();
                    });
                  } else if (newFolder.isNotEmpty && _folders.contains(newFolder)) {
                    setState(() {
                      if (!_selectedFolders.contains(newFolder)) {
                        _selectedFolders.add(newFolder);
                      }
                      _newFolderController.clear();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
