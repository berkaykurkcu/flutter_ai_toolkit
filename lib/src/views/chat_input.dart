// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.submit,
    required this.pauseInput,
    super.key,
  });

  /// Callback for submitting new messages
  final void Function(String) submit;

  /// Prevents submitting new messages when true
  final bool pauseInput;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
              child: TextField(
                minLines: 1,
                maxLines: 1024,
                controller: _controller,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => _submit(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  hintText: "Prompt the LLM",
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => IconButton(
              icon: const Icon(Icons.send),
              onPressed: _canTakeInput ? () => _submit(value.text) : null,
            ),
          ),
        ],
      );

  bool get _canTakeInput => _controller.text.isNotEmpty && !widget.pauseInput;

  void _submit(String prompt) {
    if (_canTakeInput) {
      widget.submit(prompt);
      _controller.clear();
    }

    _focusNode.requestFocus();
  }
}
