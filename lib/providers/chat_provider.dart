import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:orbit/models/chat_model.dart';
import 'package:orbit/models/message_model.dart';
import 'package:orbit/services/chat_services.dart';

class ChatProvider extends ChangeNotifier{
  final ChatServices _chatServices = ChatServices();

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  List<ChatModel> _chats = [];
  List<ChatModel> get chats => _chats;

  bool _isSending = false;
  bool get isSending => _isSending;

  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  StreamSubscription<List<ChatModel>>? _chatsSubscription;

  void listenMessages(String otherUserId) {
    _messagesSubscription?.cancel();

    _messagesSubscription = _chatServices.streamMessages(otherUserId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  void listenChats() {
    _chatsSubscription?.cancel();
    _chatsSubscription = _chatServices.streamChats().listen((chats) {
      _chats = chats;
      notifyListeners();
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text
}) async {
    try {
      _isSending = true;
      notifyListeners();

      await _chatServices.sendMessage(receiverId: receiverId, text: text);
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> markChatAsRead(String otherUserId) async {
    await _chatServices.markChatAsRead(otherUserId);
  }
  void clearChat() {
    _messagesSubscription?.cancel();
    _chatsSubscription?.cancel();
    _messages = [];
    _chats = [];
    _isSending = false;
    notifyListeners();
  }

  Future<void> markMessagesAsRead(String otherUserId) async {
    await _chatServices.markMessagesAsRead(otherUserId);
  }

  Future<void> setTypingStatus({
    required String otherUserId,
    required bool isTyping
}) async {
    await _chatServices.setTypingStatus(
        otherUserId: otherUserId,
        isTyping: isTyping
    );
  }

  Future<void> clearTypingStatus() async {
    for(final chat in _chats) {
      for(final participant in chat.participants) {
        await _chatServices.setTypingStatus(otherUserId: participant, isTyping: false);
      }
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _chatsSubscription?.cancel();
    super.dispose();
  }
}