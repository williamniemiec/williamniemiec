import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../core/theme/app_theme.dart';

class VoiceModeOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const VoiceModeOverlay({
    super.key,
    required this.onClose,
  });

  @override
  State<VoiceModeOverlay> createState() => _VoiceModeOverlayState();
}

class _VoiceModeOverlayState extends State<VoiceModeOverlay>
    with TickerProviderStateMixin {
  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _lastWords = '';
  String _currentResponse = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _initSpeech() async {
    _speechToText = SpeechToText();
    
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _showPermissionDialog();
      return;
    }

    _speechEnabled = await _speechToText.initialize(
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        _showError('Speech recognition error: ${error.errorMsg}');
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
    );
    setState(() {});
  }

  void _initTts() async {
    _flutterTts = FlutterTts();
    
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildVoiceVisualizer(),
              const SizedBox(height: 32),
              _buildStatusText(),
              const SizedBox(height: 24),
              _buildTranscriptionText(),
              const SizedBox(height: 32),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.mic,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        const Text(
          'Voice Mode',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose,
        ),
      ],
    );
  }

  Widget _buildVoiceVisualizer() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _waveController]),
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getVisualizerColor().withOpacity(0.1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer wave
              if (_isListening || _isSpeaking)
                Transform.scale(
                  scale: 1.0 + (_waveAnimation.value * 0.3),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getVisualizerColor().withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              // Inner circle
              Transform.scale(
                scale: _isListening || _isSpeaking ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getVisualizerColor(),
                  ),
                  child: Icon(
                    _getVisualizerIcon(),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    String statusText;
    if (_isSpeaking) {
      statusText = 'Speaking...';
    } else if (_isListening) {
      statusText = 'Listening...';
    } else {
      statusText = 'Tap to speak';
    }

    return Text(
      statusText,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildTranscriptionText() {
    final displayText = _lastWords.isNotEmpty ? _lastWords : 'Say something...';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 16,
          color: AppTheme.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Stop speaking button
        if (_isSpeaking)
          ElevatedButton.icon(
            onPressed: _stopSpeaking,
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
          ),
        // Listen button
        if (!_isSpeaking)
          ElevatedButton.icon(
            onPressed: _speechEnabled ? _toggleListening : null,
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            label: Text(_isListening ? 'Stop' : 'Listen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListening ? AppTheme.errorColor : AppTheme.primaryColor,
            ),
          ),
      ],
    );
  }

  Color _getVisualizerColor() {
    if (_isSpeaking) return AppTheme.successColor;
    if (_isListening) return AppTheme.primaryColor;
    return AppTheme.secondaryColor;
  }

  IconData _getVisualizerIcon() {
    if (_isSpeaking) return Icons.volume_up;
    if (_isListening) return Icons.mic;
    return Icons.mic_none;
  }

  void _toggleListening() async {
    if (!_speechEnabled) {
      _showError('Speech recognition not available');
      return;
    }

    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _lastWords = '';
        _isListening = true;
      });
      
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult && _lastWords.isNotEmpty) {
      _sendVoiceMessage(_lastWords);
    }
  }

  void _sendVoiceMessage(String message) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    // Send the message
    await chatProvider.sendMessage(message);
    
    // Get the response and speak it
    if (chatProvider.currentConversation?.messages.isNotEmpty ?? false) {
      final lastMessage = chatProvider.currentConversation!.messages.last;
      if (lastMessage.role.name == 'assistant') {
        await _speak(lastMessage.content);
      }
    }
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        _currentResponse = text;
      });
      await _flutterTts.speak(text);
    }
  }

  Future<void> _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text(
          'Voice mode requires microphone access to listen to your voice. '
          'Please grant permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onClose();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}