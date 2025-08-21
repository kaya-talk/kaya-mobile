import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/letters_service.dart';
import '../../../../core/models/letter_model.dart';

class LettersHomeScreen extends StatefulWidget {
  const LettersHomeScreen({super.key});

  @override
  State<LettersHomeScreen> createState() => _LettersHomeScreenState();
}

class _LettersHomeScreenState extends State<LettersHomeScreen> {
  final LettersService _lettersService = LettersService();
  String _selectedFilter = 'All Letters';
  bool _isLoading = true;
  List<LetterModel> _letters = [];
  String? _errorMessage;

  List<String> get _availableFilters {
    final moods = _letters
        .where((entry) => entry.mood != null && entry.mood!.isNotEmpty)
        .map((entry) => entry.mood!)
        .toSet()
        .toList();
    
    return ['All Letters', ...moods];
  }

  @override
  void initState() {
    super.initState();
    _loadLetters();
  }

  Future<void> _loadLetters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final letters = await _lettersService.getLetters(
        mood: _selectedFilter == 'All Letters' ? null : _selectedFilter,
      );
      setState(() {
        _letters = letters;
        _isLoading = false;
        // Reset filter if current selection is no longer available
        if (!_availableFilters.contains(_selectedFilter)) {
          _selectedFilter = 'All Letters';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load letters: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<LetterModel> get _filteredEntries {
    if (_selectedFilter == 'All Letters') {
      return _letters;
    }
    return _letters.where((entry) => entry.mood == _selectedFilter).toList();
  }

  void _refreshLetters() {
    _loadLetters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: const Row(
                children: [
                  Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Letters never sent — still heard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadLetters,
                color: const Color(0xFFB6A9E5),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main title
                      const Text(
                        'Unsent Letters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Write something you're not ready to say out loud.",
                        style: TextStyle(
                          color: Color(0xFFB6A9E5),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Filter Buttons
                      if (_letters.isNotEmpty) ...[
                        const Text(
                          'Filter by mood:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableFilters.map((filter) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                              _loadLetters(); // Reload with new filter
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedFilter == filter 
                                  ? const Color(0xFFB6A9E5) 
                                  : const Color(0xFF4B2996),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Letters List
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB6A9E5)),
                            ),
                          ),
                        )
                      else if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B2170),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refreshLetters,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else if (_filteredEntries.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.mail_outline,
                                color: Color(0xFFB6A9E5),
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No letters yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start writing letters you\'re not ready to send',
                                style: TextStyle(
                                  color: Color(0xFFB6A9E5),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ..._filteredEntries.map((letter) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B2170),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    letter.formattedDate,
                                    style: const TextStyle(
                                      color: Color(0xFFB6A9E5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (letter.mood != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          margin: const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4B2996),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            letter.mood!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: letter.isDraft 
                                            ? const Color(0xFF4B2996) 
                                            : const Color(0xFF059669),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          letter.isDraft ? 'Draft' : 'Sent',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                letter.displayTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (letter.content.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  letter.content.length > 120 
                                    ? '${letter.content.substring(0, 120)}...'
                                    : letter.content,
                                  style: const TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        )).toList(),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Write New Letter Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pushNamed('letters-compose'),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Write a New Letter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2170),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('letters-compose'),
        backgroundColor: const Color(0xFF4B2996),
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: 3, // Letters tab is selected
        onTap: (index) {
          if (index == 0) {
            // Home button
            context.goNamed('home');
          } else if (index == 1) {
            // Talk button
            context.pushNamed('chat-history');
          } else if (index == 2) {
            // Journal button
            context.pushNamed('journal');
          } else if (index == 3) {
            // Letters button - already on letters home
            // Do nothing, already selected
          } else if (index == 4) {
            // Glow button
            context.pushNamed('glow-notes');
          } else if (index == 5) {
            // Profile button
            context.pushNamed('profile');
          }
        },
        selectedItemColor: const Color(0xFFB6A9E5),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Talk'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Letters'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Glow'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
} 