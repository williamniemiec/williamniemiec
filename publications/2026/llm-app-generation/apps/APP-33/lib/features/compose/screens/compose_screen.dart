import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/thread.dart';

class ComposeScreen extends StatefulWidget {
  final Thread? parentThread; // For replies
  final Thread? quotedThread; // For quotes

  const ComposeScreen({
    super.key,
    this.parentThread,
    this.quotedThread,
  });

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<MediaAttachment> _attachments = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _canPost {
    return _textController.text.trim().isNotEmpty || _attachments.isNotEmpty;
  }

  String get _title {
    if (widget.parentThread != null) return 'Reply';
    if (widget.quotedThread != null) return 'Quote';
    return 'New thread';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    _title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _canPost && !_isPosting ? _postThread : null,
                  child: _isPosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Post',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _canPost
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parent thread (for replies)
                  if (widget.parentThread != null) ...[
                    _buildParentThread(),
                    const SizedBox(height: 16),
                  ],
                  
                  // User info and text input
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<AppProvider>(
                        builder: (context, appProvider, child) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            child: appProvider.currentUser?.profileImageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      appProvider.currentUser!.profileImageUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.person,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              maxLines: null,
                              maxLength: AppConstants.maxThreadLength,
                              decoration: InputDecoration(
                                hintText: widget.parentThread != null
                                    ? 'Post your reply'
                                    : 'What\'s happening?',
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: Theme.of(context).textTheme.bodyLarge,
                              onChanged: (_) => setState(() {}),
                            ),
                            
                            // Attachments
                            if (_attachments.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildAttachments(),
                            ],
                            
                            // Quoted thread
                            if (widget.quotedThread != null) ...[
                              const SizedBox(height: 12),
                              _buildQuotedThread(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom toolbar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _pickMedia,
                  icon: const Icon(Icons.image_outlined),
                  tooltip: 'Add photo or video',
                ),
                IconButton(
                  onPressed: _pickCamera,
                  icon: const Icon(Icons.camera_alt_outlined),
                  tooltip: 'Take photo',
                ),
                const Spacer(),
                Text(
                  '${_textController.text.length}/${AppConstants.maxThreadLength}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _textController.text.length > AppConstants.maxThreadLength * 0.9
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentThread() {
    final parent = widget.parentThread!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: parent.author.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          parent.author.profileImageUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                parent.author.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '@${parent.author.username}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            parent.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuotedThread() {
    final quoted = widget.quotedThread!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: quoted.author.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          quoted.author.profileImageUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                quoted.author.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '@${quoted.author.username}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            quoted.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _attachments.map((attachment) {
        return Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: attachment.type == 'image'
                    ? Image.network(
                        attachment.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )
                    : const Icon(Icons.videocam),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _attachments.remove(attachment);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // In a real app, you would upload the image and get a URL
      final attachment = MediaAttachment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: image.path, // This would be the uploaded URL
        type: 'image',
      );
      
      setState(() {
        _attachments.add(attachment);
      });
    }
  }

  Future<void> _pickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      // In a real app, you would upload the image and get a URL
      final attachment = MediaAttachment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: image.path, // This would be the uploaded URL
        type: 'image',
      );
      
      setState(() {
        _attachments.add(attachment);
      });
    }
  }

  Future<void> _postThread() async {
    if (!_canPost || _isPosting) return;

    setState(() {
      _isPosting = true;
    });

    final appProvider = context.read<AppProvider>();
    final success = await appProvider.createThread(
      content: _textController.text.trim(),
      attachments: _attachments,
      parentThreadId: widget.parentThread?.id,
      quotedThreadId: widget.quotedThread?.id,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.parentThread != null ? 'Reply posted!' : 'Thread posted!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else if (mounted) {
      setState(() {
        _isPosting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appProvider.error ?? 'Failed to post thread'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}