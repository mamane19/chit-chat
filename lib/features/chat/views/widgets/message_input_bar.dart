import 'package:flutter/material.dart';
import 'package:xave/core/models/conversation.dart';

/// Input bar where the user can enter a message text.
class MessageInputBar extends StatefulWidget {
  /// Initializes a new [MessageInputBar]
  const MessageInputBar({
    required this.conversation,
    required this.onSend,
    Key? key,
  }) : super(key: key);

  /// The conversation where this bar is being displayed.
  final Conversation conversation;

  /// Callback for when the send button is pressed.
  final void Function(String) onSend;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  late final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.1),
        boxShadow: const [
          BoxShadow(
            color: Colors.purple,
            blurRadius: 3,
            offset: Offset(1, 0),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.text,
              maxLines: null,
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onSend(_messageController.text);
              _messageController.clear();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
