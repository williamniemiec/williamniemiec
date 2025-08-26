import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/chat_message.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Dio _dio = Dio();

  // Mock AI responses for demo purposes
  // In a real app, this would connect to OpenAI, Claude, or another AI service
  Future<String> analyzeConversation({
    required List<String> imageUrls,
    String? additionalContext,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock response for conversation analysis
      return _generateConversationAnalysis();
    } catch (e) {
      debugPrint('AI Service Error: $e');
      throw AIServiceException('Failed to analyze conversation: ${e.toString()}');
    }
  }

  Future<String> roastProfile({
    required String bio,
    required List<String> photoUrls,
    int? age,
    String? location,
    List<String>? interests,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 3));

      // Mock response for profile roast
      return _generateProfileRoast(bio, photoUrls.length);
    } catch (e) {
      debugPrint('AI Service Error: $e');
      throw AIServiceException('Failed to roast profile: ${e.toString()}');
    }
  }

  Future<List<String>> generateBios({
    required List<String> interests,
    required String personality,
    int? age,
    String? occupation,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock response for bio generation
      return _generateBios(interests, personality);
    } catch (e) {
      debugPrint('AI Service Error: $e');
      throw AIServiceException('Failed to generate bios: ${e.toString()}');
    }
  }

  Future<List<String>> generateRizzLines({
    String? context,
    String? profileInfo,
    String? conversationTopic,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock response for rizz generation
      return _generateRizzLines(context);
    } catch (e) {
      debugPrint('AI Service Error: $e');
      throw AIServiceException('Failed to generate rizz lines: ${e.toString()}');
    }
  }

  Future<String> getGeneralAdvice({
    required String question,
    String? context,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock response for general advice
      return _generateGeneralAdvice(question);
    } catch (e) {
      debugPrint('AI Service Error: $e');
      throw AIServiceException('Failed to get advice: ${e.toString()}');
    }
  }

  // Mock response generators
  String _generateConversationAnalysis() {
    final responses = [
      """**Conversation Analysis** 📱

**Vibe Check:** The conversation has a playful, flirty energy. They're clearly interested and engaging with your humor!

**Suggested Replies:**
1. "I'm starting to think you might be trouble... the good kind 😏"
2. "Plot twist: I was actually testing if you could keep up with my wit. You passed ✨"
3. "Okay, you've officially made me smile more than my morning coffee does"

**Pro Tips:**
• Keep the playful banter going - they're matching your energy
• Ask an engaging question to learn more about them
• The conversation is ready for a date suggestion if you feel the timing is right!""",

      """**Chat Analysis** 💬

**Current Mood:** Sweet and genuine connection building. They're sharing personal details - great sign!

**Reply Options:**
1. "That's actually really cool! I love people who are passionate about [their interest]. Tell me more!"
2. "Okay, now I'm curious - what's the most interesting thing that's happened to you recently?"
3. "I have a feeling we'd have some great conversations over coffee ☕"

**Strategy Notes:**
• They're opening up - reciprocate with something personal about yourself
• Show genuine interest in their passions
• This is perfect timing to suggest meeting up!""",

      """**Conversation Breakdown** 🔍

**Energy Level:** Medium-high interest, they're investing in the conversation

**Best Responses:**
1. "I'm impressed - most people can't handle my level of random facts 🤓"
2. "Alright, you've convinced me you're actually interesting. What's your next fun fact?"
3. "I feel like we should continue this conversation somewhere with better coffee than my kitchen"

**Next Steps:**
• They're clearly enjoying the intellectual banter
• Perfect opportunity to transition to planning a meet-up
• Keep the curiosity and humor flowing!"""
    ];

    return responses[DateTime.now().millisecond % responses.length];
  }

  String _generateProfileRoast(String bio, int photoCount) {
    final roasts = [
      """**Profile Roast** 🔥

**Bio Analysis:** "$bio"
Okay, let's be real here. Your bio reads like a grocery list written by someone who's never been grocery shopping. "Love to laugh" - wow, groundbreaking! Next you'll tell me you enjoy breathing oxygen.

**Photo Situation:** $photoCount photos
Your photo game needs work. I can see you have $photoCount photos, but quality > quantity, my friend.

**The Verdict:** 6.5/10
You're not hopeless, but you're definitely not optimized for maximum swipe-ability.

**Improvement Plan:**
1. **Bio Makeover:** Tell a story, not a resume. What makes you YOU?
2. **Photo Strategy:** First photo should be a clear face shot, then show your personality
3. **Conversation Starters:** Give people something to message you about!

**New Bio Options:**
• "Professional overthinker, amateur chef, expert at finding the best tacos in town 🌮"
• "I collect vintage vinyl and modern dad jokes. Both are equally impressive at parties."
• "Currently accepting applications for someone to judge my Netflix choices with"

**Bottom Line:** You've got potential, but right now you're a rough diamond that needs some polishing! ✨""",

      """**Roast Session** 🎯

**Bio Review:** Your current bio...
Look, I'm not saying it's bad, but I've seen more personality in a Terms of Service agreement. You're playing it so safe, you might as well have written "I exist and have hobbies."

**Photo Count:** $photoCount images
Having $photoCount photos is a start, but are they actually doing you justice?

**Score:** 5.8/10
You're in the "nice guy/girl" zone, which is dating app purgatory.

**The Fix:**
1. **Show, Don't Tell:** Instead of "I love adventures," show yourself on an adventure
2. **Be Specific:** "I make a mean pasta" beats "I like cooking"
3. **Add Some Edge:** A little controversy never hurt anyone (within reason!)

**Rewrite Suggestions:**
• "Warning: I will judge you based on your pizza topping choices 🍕"
• "Part-time [your job], full-time overthinker, occasional comedian"
• "Looking for someone who won't judge me for talking to my plants"

**Reality Check:** You're probably cooler than your profile suggests. Let that personality shine! 🌟"""
    ];

    return roasts[DateTime.now().millisecond % roasts.length];
  }

  List<String> _generateBios(List<String> interests, String personality) {
    final interestText = interests.take(3).join(', ');
    
    return [
      // Witty & Short
      "Professional $interestText enthusiast. Part-time human, full-time overthinker. Currently accepting applications for adventure partners 🎯",
      
      // Detailed & Storytelling
      "By day, I'm conquering the world of $interestText. By night, I'm the person who actually reads the terms and conditions (just kidding, nobody does that). I believe in good coffee, better conversations, and the healing power of perfectly timed memes. Looking for someone who can appreciate both deep talks and ridiculous jokes.",
      
      // Playful & Conversation Starter
      "I collect $interestText and unpopular opinions. Current debate: Is cereal soup? Let's discuss over coffee and see if we're compatible ☕✨"
    ];
  }

  List<String> _generateRizzLines(String? context) {
    final lines = [
      "Are you a parking ticket? Because you've got 'fine' written all over you... and I'm probably going to ignore you until the last minute 😅",
      "I'm not a photographer, but I can definitely picture us together... probably arguing about what to watch on Netflix",
      "Do you believe in love at first swipe, or should I unmatch and swipe again? 📱",
      "I must be a snowflake, because I've fallen for you... and I'm probably going to melt under pressure",
      "Are you WiFi? Because I'm really feeling a connection... even though it might be unstable sometimes 📶",
      "If you were a vegetable, you'd be a cute-cumber... and I'd be the person who makes terrible vegetable puns",
      "I'm not saying you're the best catch on this app, but you're definitely in my top... *checks matches* ...one 🎣",
      "Do you have a map? Because I just got lost in your profile... and my GPS isn't working",
    ];

    return lines.take(5).toList();
  }

  String _generateGeneralAdvice(String question) {
    final adviceResponses = [
      """**Dating Wisdom** 💡

Great question! Here's the tea ☕:

The key to great dating conversations is being genuinely curious about the other person. Ask follow-up questions, share relatable stories, and don't be afraid to show your personality - quirks and all!

**Quick Tips:**
• Listen more than you talk
• Ask open-ended questions
• Share something vulnerable (but not too personal too soon)
• Use humor to break tension
• Be authentic - the right person will appreciate the real you

Remember: Dating should be fun, not a job interview! 😊""",

      """**Real Talk** 🗣️

Here's what I've learned from helping thousands of people with their dating game:

The best connections happen when you stop trying to be perfect and start being interesting. Share your passions, ask thoughtful questions, and don't be afraid to disagree (respectfully) sometimes.

**Golden Rules:**
• Quality over quantity in conversations
• Show interest in their world
• Be confident but not cocky
• Know when to suggest meeting up
• Trust your instincts

You've got this! 💪""",

      """**Dating Coach Mode** 🎯

Excellent question! Let me break this down for you:

The secret sauce is balance - be interested but not desperate, confident but not arrogant, funny but not trying too hard. Think of dating as making a new friend who you might also want to kiss.

**Pro Strategies:**
• Mirror their communication style
• Find common ground early
• Use their name in conversation
• Ask about their passions
• Share stories, not just facts

Most importantly: If it feels like work, they're not your person. The right match should feel easy and natural! ✨"""
    ];

    return adviceResponses[DateTime.now().millisecond % adviceResponses.length];
  }
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}