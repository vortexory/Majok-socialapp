// lib/src/screens/station_4/station_4_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futu/l10n/app_localizations.dart';
import 'package:futu/src/models/chat_message_model.dart';
import 'package:futu/src/providers/user_state_provider.dart';
import 'package:futu/src/services/ai_chat_service.dart';
import 'package:futu/src/services/audio_service.dart';
import 'package:futu/src/services/analytics_service.dart';
import 'package:futu/src/services/station_4_generator.dart';
import 'package:futu/src/theme/app_theme.dart';

class Station4ResultScreen extends ConsumerStatefulWidget {
  final String? celebrityScoop;
  final int? selectedColorIndex;
  final String? selectedFruit;
  final String? movieMagic;

  const Station4ResultScreen({Key? key, this.celebrityScoop, this.selectedColorIndex, this.selectedFruit, this.movieMagic})
    : super(key: key);

  @override
  ConsumerState<Station4ResultScreen> createState() => _Station4ResultScreenState();
}

class _Station4ResultScreenState extends ConsumerState<Station4ResultScreen> {
  final List<ChatMessage> _messages = [];
  Map<String, String> _partnerInfo = {};
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _stationCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    try {
      final localizations = AppLocalizations.of(context)!;
      // Initialize the AI Service
      AIChatService.instance.initialize();

      // Generate the partner's deterministic identity
      final partnerInfo = Station4Generator.instance.generatePartnerInfo(
        localizations: localizations,
        userInputs: {
          'celebrity_scoop': widget.celebrityScoop,
          'color_index': widget.selectedColorIndex,
          'fruit': widget.selectedFruit,
          'movie_magic': widget.movieMagic,
        },
      );

      setState(() {
        _partnerInfo = partnerInfo;
        _isTyping = true; // Show typing indicator for the initial message
      });

      // Get the initial message from the AI
      final initialMessageText = await AIChatService.instance.generateInitialMessage(
        partnerInfo: _partnerInfo,
        userPreferences: {
          'celebrityScoop': widget.celebrityScoop,
          'selectedColorIndex': widget.selectedColorIndex,
          'selectedFruit': widget.selectedFruit,
          'movieMagic': widget.movieMagic,
        },
      );

      final initialMessage = ChatMessage(text: initialMessageText, sender: MessageSender.soulmate, time: _getCurrentTime());

      setState(() {
        _messages.add(initialMessage);
        _isLoading = false;
        _isTyping = false;
      });

      _scrollToBottom();
      await AnalyticsService.instance.logStationStart(4, 'AI Chat');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to initialize chat: $e";
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isTyping) return;

    AudioService.instance.play(Sound.transition);
    _textController.clear();

    // Add user message to UI immediately
    setState(() {
      _messages.add(ChatMessage(text: text, sender: MessageSender.user, time: _getCurrentTime()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Mark station as complete after the first user message
    if (!_stationCompleted) {
      await ref.read(userStateProvider.notifier).updateStationStatus(4, 'completed');
      await ref.read(userStateProvider.notifier).updateStationStatus(5, 'unlocked');
      await AnalyticsService.instance.logStationComplete(4, 'AI Chat');
      setState(() => _stationCompleted = true);
    }

    await AnalyticsService.instance.logUserChoice(choiceType: 'chat_message_sent', choiceValue: text, stationId: 4);

    // Build chat history for the AI
    final history = _messages.map((msg) {
      return (role: msg.sender == MessageSender.user ? 'user' : 'model', text: msg.text);
    }).toList();

    // Get response from AI
    final aiResponseText = await AIChatService.instance.getChatResponse(
      partnerInfo: _partnerInfo,
      userPreferences: {
        'celebrityScoop': widget.celebrityScoop,
        'selectedColorIndex': widget.selectedColorIndex,
        'selectedFruit': widget.selectedFruit,
        'movieMagic': widget.movieMagic,
      },
      history: history,
    );

    AudioService.instance.play(Sound.tap);

    // Add AI response to UI
    setState(() {
      _messages.add(ChatMessage(text: aiResponseText, sender: MessageSender.soulmate, time: _getCurrentTime()));
      _isTyping = false;
    });
    _scrollToBottom();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return TimeOfDay.fromDateTime(now).format(context);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // The rest of the build method and sub-widgets (_ChatMessageBubble, _TypingIndicator, etc.)
  // from the original file can remain largely the same, as they are UI components.
  // We just need to adapt the main build method to use the new state variables.

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Connecting...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    final partnerName = _partnerInfo['name'] ?? 'Soulmate';
    final partnerTitle = _partnerInfo['title'] ?? 'The One';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              AudioService.instance.play(Sound.tap);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
              child: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
        leadingWidth: 72,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Center(
                child: Text(
                  partnerName.isNotEmpty ? partnerName[0].toUpperCase() : 'S',
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.soulmate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(partnerTitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _TypingIndicator(partnerName: partnerName);
                }
                final message = _messages[index];
                return _ChatMessageBubble(message: message);
              },
            ),
          ),
          _ChatInputField(
            controller: _textController,
            onSend: _sendMessage,
            hintText: _isTyping ? "..." : "Type your message",
            enabled: !_isTyping,
          ),
        ],
      ),
    );
  }
}


class _ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: isUser ? Colors.white : Colors.black87)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isUser ? Colors.white70 : Colors.grey.shade600),
                ),
                if (isUser) ...[const SizedBox(width: 4), const Icon(Icons.done_all, color: Colors.white70, size: 16)],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  final String partnerName;
  const _TypingIndicator({required this.partnerName});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final value = (_animation.value - delay).clamp(0.0, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600.withOpacity(value < 0.5 ? value * 2 : 2 - value * 2),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hintText;
  final bool enabled;

  const _ChatInputField({required this.controller, required this.onSend, required this.hintText, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
                onSubmitted: enabled ? (_) => onSend() : null,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: enabled ? AppTheme.primaryColor : Colors.grey.shade400),
              onPressed: enabled ? onSend : null,
            ),
          ],
        ),
      ),
    );
  }
}
