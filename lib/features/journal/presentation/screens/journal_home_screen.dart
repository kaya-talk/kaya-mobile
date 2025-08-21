import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/journal_service.dart';
import '../../../../core/models/journal_entry_model.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  final JournalService _journalService = JournalService();
  String _selectedFilter = 'All Entries';
  bool _isLoading = true;
  List<JournalEntryModel> _entries = [];
  String? _errorMessage;

  List<String> get _availableFilters {
    final moods = _entries
        .where((entry) => entry.mood != null && entry.mood!.isNotEmpty)
        .map((entry) => entry.mood!)
        .toSet()
        .toList();
    
    return ['All Entries', ...moods];
  }

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final entries = await _journalService.getEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
        // Reset filter if current selection is no longer available
        if (!_availableFilters.contains(_selectedFilter)) {
          _selectedFilter = 'All Entries';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load journal entries: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<JournalEntryModel> get _filteredEntries {
    if (_selectedFilter == 'All Entries') {
      return _entries;
    }
    return _entries.where((entry) => entry.mood == _selectedFilter).toList();
  }

  void _refreshEntries() {
    _loadEntries();
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
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB6A9E5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.book,
                      color: Color(0xFF2E1065),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Where your thoughts land.',
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
                onRefresh: _loadEntries,
                color: const Color(0xFFB6A9E5),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Journal Title and Prompt
                      const Text(
                        'Journal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "There's no wrong way to begin.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Filter Buttons
                      if (_entries.isNotEmpty) ...[
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
                    
                      // Recent Entries
                      const Text(
                        'Recent Entries',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Journal Entry Cards
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
                                onPressed: _refreshEntries,
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
                                Icons.edit_note,
                                color: Color(0xFFB6A9E5),
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No journal entries yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start your journaling journey by writing your first entry',
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
                        ..._filteredEntries.map((entry) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
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
                                    entry.formattedDate,
                                    style: const TextStyle(
                                      color: Color(0xFFB6A9E5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (entry.mood != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4B2996),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        entry.mood!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.title.isNotEmpty ? entry.title : 'Untitled',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (entry.content.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  entry.content.length > 100 
                                    ? '${entry.content.substring(0, 100)}...'
                                    : entry.content,
                                  style: const TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
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
            
            // Write New Entry Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pushNamed('journal-compose'),
                  icon: const Icon(Icons.edit_note, color: Colors.white),
                  label: const Text(
                    'Write a New Entry',
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
        onPressed: () => context.pushNamed('journal-compose'),
        backgroundColor: const Color(0xFF4B2996),
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit_note),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: 2, // Journal tab is selected
        onTap: (index) {
          if (index == 0) {
            // Home button
            context.goNamed('home');
          } else if (index == 1) {
            // Talk button
            context.pushNamed('chat-history');
          } else if (index == 2) {
            // Journal button - already on journal history
            // Do nothing, already selected
          } else if (index == 3) {
            // Letters button
            context.pushNamed('letters');
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