import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String, String) onSendImage;
  final VoidCallback onToggleVoiceMode;
  final Function(String) onGenerateImage;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onToggleVoiceMode,
    required this.onGenerateImage,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  bool _showImageOptions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.textTertiary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showImageOptions) _buildImageOptions(),
          _buildInputRow(),
        ],
      ),
    );
  }

  Widget _buildImageOptions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose an option:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildOptionButton(
                  icon: Icons.camera_alt,
                  label: 'Take Photo',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOptionButton(
                  icon: Icons.photo_library,
                  label: 'Choose Photo',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _buildOptionButton(
              icon: Icons.palette,
              label: 'Generate Image',
              onTap: _showImageGenerationDialog,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _showImageOptions ? Icons.close : Icons.add,
            color: AppTheme.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _showImageOptions = !_showImageOptions;
            });
          },
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message ChatGPT...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.surfaceColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isExpanded = value.isNotEmpty;
                });
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (_isExpanded)
          IconButton(
            icon: const Icon(
              Icons.send,
              color: AppTheme.primaryColor,
            ),
            onPressed: _sendMessage,
          )
        else
          IconButton(
            icon: const Icon(
              Icons.mic,
              color: AppTheme.textSecondary,
            ),
            onPressed: widget.onToggleVoiceMode,
          ),
      ],
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
      setState(() {
        _isExpanded = false;
        _showImageOptions = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _showImageOptions = false;
        });
        
        // Show dialog to add prompt for image analysis
        _showImageAnalysisDialog(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showImageAnalysisDialog(String imagePath) {
    final TextEditingController promptController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analyze Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What would you like to know about this image?'),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                hintText: 'e.g., "What is in this image?" or "Transcribe the text"',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final prompt = promptController.text.trim();
              if (prompt.isNotEmpty) {
                widget.onSendImage(imagePath, prompt);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Analyze'),
          ),
        ],
      ),
    );
  }

  void _showImageGenerationDialog() {
    final TextEditingController promptController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Describe the image you want to generate:'),
            const SizedBox(height: 16),
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                hintText: 'e.g., "A sunset over mountains" or "A futuristic city"',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _showImageOptions = false;
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final prompt = promptController.text.trim();
              if (prompt.isNotEmpty) {
                widget.onGenerateImage(prompt);
                Navigator.of(context).pop();
                setState(() {
                  _showImageOptions = false;
                });
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}