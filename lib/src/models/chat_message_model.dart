enum MessageSender { user, soulmate }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final String time;

  ChatMessage({required this.text, required this.sender, required this.time});
}