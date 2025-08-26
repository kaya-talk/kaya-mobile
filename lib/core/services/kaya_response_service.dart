import 'dart:math';
import 'package:kaya_app/core/models/kaya_model.dart';

class KayaResponseService {
  static final Random _random = Random();

  // Generate a response based on Kaya's properties and presence
  static String generateResponse({
    required String userMessage,
    required String presence,
    required KayaModel kaya,
  }) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Check for specific emotional content first
    if (_containsEmotionalContent(lowerMessage)) {
      return _generateEmotionalResponse(lowerMessage, presence, kaya);
    }
    
    // Check for specific topics
    if (_containsTopicContent(lowerMessage)) {
      return _generateTopicResponse(lowerMessage, presence, kaya);
    }
    
    // Check if we can generate a personality-based response
    final personalityResponse = generatePersonalityResponse(
      userMessage: userMessage,
      presence: presence,
      kaya: kaya,
    );
    
    // If the personality response is different from the general response, use it
    final generalResponse = _generateGeneralResponse(presence, kaya);
    if (personalityResponse != generalResponse) {
      return personalityResponse;
    }
    
    // Generate a general response based on presence and personality
    return generalResponse;
  }

  // Generate a response that incorporates Kaya's personality
  static String generatePersonalityResponse({
    required String userMessage,
    required String presence,
    required KayaModel kaya,
  }) {
    final lowerMessage = userMessage.toLowerCase();
    final personalityTraits = kaya.personalityTraits.map((t) => t.toLowerCase()).toList();
    
    // Check if Kaya has specific personality traits that should influence the response
    if (personalityTraits.contains('empathetic') || personalityTraits.contains('caring')) {
      if (lowerMessage.contains('problem') || lowerMessage.contains('issue') || lowerMessage.contains('trouble')) {
        return "I can really feel how challenging this is for you. As someone who cares deeply about others, I want you to know that your feelings matter and I'm here to listen.";
      }
    }
    
    if (personalityTraits.contains('wise') || personalityTraits.contains('experienced')) {
      if (lowerMessage.contains('decision') || lowerMessage.contains('choice') || lowerMessage.contains('confused')) {
        return "Having lived through many experiences myself, I know that decisions can feel overwhelming. Sometimes the best approach is to trust your intuition and take one step at a time.";
      }
    }
    
    if (personalityTraits.contains('creative') || personalityTraits.contains('inspiring')) {
      if (lowerMessage.contains('stuck') || lowerMessage.contains('boring') || lowerMessage.contains('routine')) {
        return "I love thinking outside the box! When things feel stuck, sometimes we need to shake up our perspective. What if we looked at this from a completely different angle?";
      }
    }
    
    if (personalityTraits.contains('analytical') || personalityTraits.contains('thoughtful')) {
      if (lowerMessage.contains('why') || lowerMessage.contains('understand') || lowerMessage.contains('figure out')) {
        return "I enjoy diving deep into understanding things. Let's break this down together - what aspects would you like to explore further?";
      }
    }
    
    // Default personality response
    return _generateGeneralResponse(presence, kaya);
  }

  static bool _containsEmotionalContent(String message) {
    final emotionalKeywords = [
      'sad', 'upset', 'angry', 'frustrated', 'anxious', 'worried',
      'happy', 'excited', 'grateful', 'proud', 'confident',
      'tired', 'exhausted', 'overwhelmed', 'stressed',
      'lonely', 'isolated', 'misunderstood', 'lost',
      'tough day', 'bad day', 'rough time', 'struggling'
    ];
    
    return emotionalKeywords.any((keyword) => message.contains(keyword));
  }

  static bool _containsTopicContent(String message) {
    final topicKeywords = [
      'work', 'job', 'career', 'school', 'study', 'exam',
      'relationship', 'family', 'friend', 'partner', 'marriage',
      'health', 'sleep', 'exercise', 'diet', 'meditation',
      'future', 'goal', 'dream', 'plan', 'decision'
    ];
    
    return topicKeywords.any((keyword) => message.contains(keyword));
  }

  static String _generateEmotionalResponse(String message, String presence, KayaModel kaya) {
    final responsePatterns = kaya.getResponsePatterns();
    
    if (message.contains('sad') || message.contains('upset') || message.contains('depressed')) {
      final empathyResponses = responsePatterns['empathy'] ?? [];
      final supportResponses = responsePatterns['support'] ?? [];
      
      if (presence == 'listener') {
        return _getRandomResponse([
          "I can feel the weight of what you're carrying.",
          "It's okay to not be okay right now.",
          "I'm here, listening to every word.",
          "Your pain is valid, and I hear you.",
        ]);
      } else if (presence == 'therapist') {
        return _getRandomResponse([
          "What's happening that's making you feel this way?",
          "Can you tell me more about what's going on?",
          "I'd like to understand what's behind these feelings.",
          "What triggered this sadness for you?",
        ]);
      } else if (presence == 'coach') {
        return _getRandomResponse([
          "I know this is hard, but you're stronger than you think.",
          "Let's work through this together. What's the first step?",
          "You don't have to stay stuck in this feeling.",
          "What would help you feel a little better right now?",
        ]);
      } else { // friend
        return _getRandomResponse([
          "Oh no, I'm so sorry you're feeling this way.",
          "That really sucks. Want to talk about it?",
          "I'm here for you, always.",
          "You know I care about you, right?",
        ]);
      }
    }
    
    if (message.contains('happy') || message.contains('excited') || message.contains('good')) {
      if (presence == 'listener') {
        return "I can feel your joy radiating through your words. Tell me more about what's making you feel this way.";
      } else if (presence == 'therapist') {
        return "It's wonderful to hear you're feeling positive. What's contributing to this happiness?";
      } else if (presence == 'coach') {
        return "That's fantastic! How can we build on this positive energy?";
      } else { // friend
        return "Yay! I'm so happy for you! What happened?";
      }
    }
    
    if (message.contains('anxious') || message.contains('worried') || message.contains('stressed')) {
      if (presence == 'listener') {
        return "I can sense the anxiety in your words. I'm here to hold space for whatever you need to share.";
      } else if (presence == 'therapist') {
        return "Anxiety can be really overwhelming. Can you help me understand what's worrying you most?";
      } else if (presence == 'coach') {
        return "Let's break this down. What's the biggest concern on your mind right now?";
      } else { // friend
        return "Oh no, anxiety is the worst! What's got you worried?";
      }
    }
    
    if (message.contains('tired') || message.contains('exhausted') || message.contains('overwhelmed')) {
      if (presence == 'listener') {
        return "You sound exhausted. I'm here to listen, no matter how long it takes.";
      } else if (presence == 'therapist') {
        return "It sounds like you're carrying a lot. What's been most draining for you?";
      } else if (presence == 'coach') {
        return "When you're this tired, it's hard to see solutions. Let's find one small thing that might help.";
      } else { // friend
        return "Oh honey, you sound wiped out. What do you need right now?";
      }
    }
    
    // Default emotional response
    return _getRandomResponse(responsePatterns['empathy'] ?? ["I hear you."]);
  }

  static String _generateTopicResponse(String message, String presence, KayaModel kaya) {
    if (message.contains('work') || message.contains('job') || message.contains('career')) {
      if (presence == 'listener') {
        return "Work can be such a big part of our lives. I'm listening to whatever you need to share about it.";
      } else if (presence == 'therapist') {
        return "Work stress affects so many areas of life. What aspect is most challenging for you right now?";
      } else if (presence == 'coach') {
        return "Work challenges can feel overwhelming. What's one small change that might make a difference?";
      } else { // friend
        return "Work drama is the worst! What's going on?";
      }
    }
    
    if (message.contains('relationship') || message.contains('family') || message.contains('friend')) {
      if (presence == 'listener') {
        return "Relationships can be so complex. I'm here to listen to whatever you need to work through.";
      } else if (presence == 'therapist') {
        return "Relationships often bring up our deepest feelings. What's happening that you'd like to explore?";
      } else if (presence == 'coach') {
        return "Relationships take work. What's one thing you could do to improve this situation?";
      } else { // friend
        return "Relationships are complicated! What's the latest?";
      }
    }
    
    if (message.contains('future') || message.contains('goal') || message.contains('dream')) {
      if (presence == 'listener') {
        return "Dreams and goals are so personal. I'd love to hear what's on your mind about the future.";
      } else if (presence == 'therapist') {
        return "Thinking about the future can bring up many emotions. What feelings does this bring up for you?";
      } else if (presence == 'coach') {
        return "Goals are exciting! What's one small step you could take toward this dream?";
      } else { // friend
        return "Ooh, tell me about your dreams! What are you thinking?";
      }
    }
    
    // Default topic response
    return _getRandomResponse([
      "That's interesting. Tell me more about that.",
      "I'd like to understand this better. Can you elaborate?",
      "This sounds important to you. What's your perspective?",
    ]);
  }

  static String _generateGeneralResponse(String presence, KayaModel kaya) {
    final responsePatterns = kaya.getResponsePatterns();
    
    switch (presence) {
      case 'listener':
        return _getRandomResponse([
          "I'm listening.",
          "Tell me more.",
          "I hear you.",
          "Go on.",
          "I'm here.",
        ]);
        
      case 'friend':
        return _getRandomResponse([
          "That's really interesting!",
          "Wow, tell me more about that.",
          "I'm curious to hear more.",
          "That sounds like quite a situation.",
          "I'm here for you.",
        ]);
        
      case 'therapist':
        return _getRandomResponse([
          "What's your sense of what's happening here?",
          "How does that make you feel?",
          "Can you tell me more about that?",
          "What's your perspective on this?",
          "I'd like to understand this better.",
        ]);
        
      case 'coach':
        return _getRandomResponse([
          "What would be most helpful to focus on right now?",
          "What's one thing you could do about this?",
          "How can we move this forward?",
          "What's your next step?",
          "What would success look like here?",
        ]);
        
      default:
        return _getRandomResponse(responsePatterns['support'] ?? ["I'm here to help."]);
    }
  }

  static String _getRandomResponse(List<String> responses) {
    if (responses.isEmpty) return "I'm here to listen.";
    return responses[_random.nextInt(responses.length)];
  }

  // Generate a follow-up question based on presence and context
  static String generateFollowUp({
    required String presence,
    required KayaModel kaya,
    String? previousResponse,
  }) {
    switch (presence) {
      case 'listener':
        return _getRandomResponse([
          "What else is on your mind?",
          "Is there more you'd like to share?",
          "I'm still listening.",
          "Take your time.",
        ]);
        
      case 'friend':
        return _getRandomResponse([
          "What else is happening?",
          "Tell me more!",
          "What's next?",
          "How are you feeling about all this?",
        ]);
        
      case 'therapist':
        return _getRandomResponse([
          "What does this bring up for you?",
          "How does this connect to other areas of your life?",
          "What would be most helpful to explore?",
          "What's your sense of what you need right now?",
        ]);
        
      case 'coach':
        return _getRandomResponse([
          "What's your next action step?",
          "How can we build on this?",
          "What would help you feel more confident?",
          "What's one thing you could do differently?",
        ]);
        
      default:
        return "What would you like to talk about next?";
    }
  }
}
