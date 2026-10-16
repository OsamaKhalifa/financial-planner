import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ai/ai_settings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: switch (ref.watch(aiSettingsProvider)) {
        AsyncData(:final value) => _aiSection(context, value),
        AsyncError() => const Center(child: Text('Could not read settings.')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _aiSection(BuildContext context, AiSettings settings) {
    final notifier = ref.read(aiSettingsProvider.notifier);
    final hasOwnKey = settings.ownGeminiKey != null;
    return ListView(
      children: [
        ListTile(
          title: Text('AI', style: Theme.of(context).textTheme.titleSmall),
        ),
        SwitchListTile(
          title: const Text('Use cloud AI'),
          subtitle: const Text(
            'When on, the text you send to AI leaves your phone and goes to '
            'Google. On free use, Google may use it to improve its products.',
          ),
          value: settings.cloudEnabled,
          onChanged: notifier.setCloudEnabled,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _keyController,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: 'Your own Gemini key (optional)',
              helperText:
                  'Get a free key at aistudio.google.com. '
                  'Stored only on this phone.',
              helperMaxLines: 2,
              hintText: hasOwnKey ? 'A key is saved' : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: hasOwnKey
                    ? () => notifier.setOwnGeminiKey(null)
                    : null,
                child: const Text('Remove key'),
              ),
              FilledButton(
                onPressed: () async {
                  await notifier.setOwnGeminiKey(_keyController.text);
                  _keyController.clear();
                },
                child: const Text('Save key'),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(switch ((settings.cloudEnabled, hasOwnKey)) {
            (false, _) => 'Cloud AI is off.',
            (true, true) => 'Using your own Gemini key.',
            (true, false) => "Using the app's shared AI service.",
          }),
        ),
      ],
    );
  }
}
