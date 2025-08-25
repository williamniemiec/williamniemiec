import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSend;
  final VoidCallback onEmojiTap;
  final VoidCallback onAttachmentTap;
  final Function(bool) onTyping;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onEmojiTap,
    required this.onAttachmentTap,
    required this.onTyping,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
      widget.onTyping(hasText);
    }
  }

  void _sendMessage() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      widget.controller.clear();
      setState(() {
        _isTyping = false;
      });
      widget.onTyping(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.mediumGray.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              onPressed: widget.onAttachmentTap,
              icon: const Icon(
                Icons.attach_file,
                color: AppTheme.secondaryText,
              ),
              tooltip: 'Attach file',
            ),
            
            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.mediumGray.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Emoji button
                    IconButton(
                      onPressed: widget.onEmojiTap,
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppTheme.secondaryText,
                      ),
                      tooltip: 'Emoji',
                    ),
                    
                    // Text field
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: AppTheme.secondaryText,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryText,
                        ),
                        maxLines: 5,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    
                    // Camera button (optional)
                    IconButton(
                      onPressed: () {
                        // Handle camera
                        _showCameraOptions();
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppTheme.secondaryText,
                      ),
                      tooltip: 'Camera',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Send button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isTyping ? AppTheme.primaryBlue : AppTheme.mediumGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isTyping ? Icons.send : Icons.mic,
                  color: AppTheme.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryBlue),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Handle take photo
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: AppTheme.primaryBlue),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                // Handle record video
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryBlue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Handle choose from gallery
              },
            ),
          ],
        ),
      ),
    );
  }
}