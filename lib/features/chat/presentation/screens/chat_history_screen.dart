import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/providers/chat_provider.dart';
import 'package:kaya_app/core/models/chat_conversation.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatConversation> _filteredConversations = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    _filterConversations(query);
  }

  void _filterConversations(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredConversations = [];
      });
      return;
    }

    final chatProvider = context.read<ChatProvider>();
    final results = await chatProvider.searchConversations(query);
    setState(() {
      _filteredConversations = results;
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
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
                      Icons.chat_bubble_outline,
                      color: Color(0xFF2E1065),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your conversations with Kaya.',
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
                onRefresh: () async {
                  context.read<ChatProvider>().refreshConversations();
                },
                color: const Color(0xFFB6A9E5),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chat Title and Prompt
                      const Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Connect with your AI guide anytime.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2170),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Search conversations...',
                            hintStyle: const TextStyle(color: Color(0xFFB6A9E5)),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFB6A9E5)),
                            suffixIcon: _isSearching
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _isSearching = false;
                                      });
                                    },
                                    icon: const Icon(Icons.clear, color: Color(0xFFB6A9E5)),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Recent Conversations
                      const Text(
                        'Recent Conversations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Conversations List
                      Consumer<ChatProvider>(
                        builder: (context, chatProvider, child) {
                          if (chatProvider.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB6A9E5)),
                                ),
                              ),
                            );
                          }

                          if (chatProvider.error != null) {
                            return Container(
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
                                    chatProvider.error!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      chatProvider.clearError();
                                      chatProvider.initialize();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final conversations = _isSearching
                              ? _filteredConversations
                              : chatProvider.conversations;

                                                     if (conversations.isEmpty) {
                             return Container(
                               padding: const EdgeInsets.all(32),
                               child: Column(
                                 children: [
                                   Icon(
                                     _isSearching ? Icons.search_off : Icons.chat_bubble_outline,
                                     color: const Color(0xFFB6A9E5),
                                     size: 48,
                                   ),
                                   const SizedBox(height: 16),
                                   Text(
                                     _isSearching
                                         ? 'No conversations found'
                                         : 'No conversations yet',
                                     style: const TextStyle(
                                       color: Colors.white,
                                       fontSize: 18,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                   const SizedBox(height: 8),
                                   Text(
                                     _isSearching
                                         ? 'Try a different search term'
                                         : 'Start a conversation with Kaya',
                                     style: const TextStyle(
                                       color: Color(0xFFB6A9E5),
                                       fontSize: 14,
                                     ),
                                     textAlign: TextAlign.center,
                                   ),
                                 ],
                               ),
                             );
                           }

                           return Column(
                             children: conversations.map((conversation) => GestureDetector(
                               onTap: () => _openConversation(conversation),
                               child: Container(
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
                                           _formatTime(conversation.lastMessageTime),
                                           style: const TextStyle(
                                             color: Color(0xFFB6A9E5),
                                             fontSize: 14,
                                           ),
                                         ),
                                         Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                           decoration: BoxDecoration(
                                             color: const Color(0xFF4B2996),
                                             borderRadius: BorderRadius.circular(12),
                                           ),
                                           child: Text(
                                             conversation.presence,
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
                                       conversation.title,
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontSize: 16,
                                         fontWeight: FontWeight.w600,
                                       ),
                                     ),
                                     if (conversation.lastMessage != null && conversation.lastMessage!.isNotEmpty) ...[
                                       const SizedBox(height: 8),
                                       Text(
                                         conversation.lastMessage!.length > 100 
                                           ? '${conversation.lastMessage!.substring(0, 100)}...'
                                           : conversation.lastMessage!,
                                         style: const TextStyle(
                                           color: Color(0xFFB6A9E5),
                                           fontSize: 14,
                                         ),
                                         maxLines: 2,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                     ],
                                     const SizedBox(height: 8),
                                     Row(
                                       children: [
                                         Container(
                                           width: 24,
                                           height: 24,
                                           decoration: BoxDecoration(
                                             color: const Color(0xFF4B2996),
                                             borderRadius: BorderRadius.circular(12),
                                           ),
                                           child: Icon(
                                             conversation.guide.sex == 'Female' ? Icons.person : Icons.person_outline,
                                             color: const Color(0xFFB6A9E5),
                                             size: 16,
                                           ),
                                         ),
                                         const SizedBox(width: 8),
                                         Text(
                                           '${conversation.messageCount} messages • ${conversation.guide.name}',
                                           style: const TextStyle(
                                             color: Color(0xFFB6A9E5),
                                             fontSize: 12,
                                           ),
                                         ),
                                         const Spacer(),
                                         PopupMenuButton<String>(
                                           icon: const Icon(Icons.more_vert, color: Color(0xFFB6A9E5)),
                                           color: const Color(0xFF3B2170),
                                           itemBuilder: (context) => [
                                             const PopupMenuItem(
                                               value: 'delete',
                                               child: Row(
                                                 children: [
                                                   Icon(Icons.delete, color: Colors.red),
                                                   SizedBox(width: 8),
                                                   Text('Delete', style: TextStyle(color: Colors.red)),
                                                 ],
                                               ),
                                             ),
                                           ],
                                           onSelected: (value) {
                                             if (value == 'delete') {
                                               _deleteConversation(conversation);
                                             }
                                           },
                                         ),
                                       ],
                                     ),
                                   ],
                                 ),
                               ),
                             )).toList(),
                           );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            
            // Start Conversation Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pushNamed('presence-selection'),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  label: const Text(
                    'Start a New Conversation',
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
        onPressed: () => context.pushNamed('presence-selection'),
        backgroundColor: const Color(0xFF4B2996),
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: 1, // Talk tab is selected
        onTap: (index) {
          if (index == 0) {
            // Home button
            context.goNamed('home');
          } else if (index == 1) {
            // Talk button - already on chat history
            // Do nothing, already selected
          } else if (index == 2) {
            // Journal button
            context.pushNamed('journal');
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

  void _openConversation(ChatConversation conversation) {
    context.pushNamed('chat', extra: {
      'conversationId': conversation.id,
    });
  }

  void _deleteConversation(ChatConversation conversation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3B2170),
        title: const Text(
          'Delete Conversation',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${conversation.title}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFFB6A9E5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFB6A9E5)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ChatProvider>().deleteConversation(conversation.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 