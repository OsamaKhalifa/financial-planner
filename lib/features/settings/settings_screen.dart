import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ai/ai_settings.dart';
import '../../core/ai/ai_vendors.dart';

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
    final vendors = ref.watch(aiVendorsProvider);
    final vendor = vendorById(vendors, settings.vendorId);
    final heading = Theme.of(context).textTheme.titleSmall;
    return ListView(
      children: [
        ListTile(title: Text('AI', style: heading)),
        SwitchListTile(
          title: const Text('Use cloud AI'),
          subtitle: const Text(
            'When on, the text you send to AI leaves your phone and goes to '
            'the AI provider you choose below.',
          ),
          value: settings.cloudEnabled,
          onChanged: notifier.setCloudEnabled,
        ),
        if (settings.cloudEnabled) ...[
          ListTile(title: Text('AI provider', style: heading)),
          RadioGroup<String>(
            groupValue: vendor?.id,
            onChanged: (id) {
              _keyController.clear();
              notifier.selectVendor(id);
            },
            child: Column(
              children: [
                for (final v in vendors)
                  RadioListTile<String>(
                    value: v.id,
                    title: Text(v.name),
                    subtitle: Text('Your own key. ${v.dataNotice}'),
                  ),
              ],
            ),
          ),
          if (vendor != null) ..._keyFields(vendor, settings, notifier),
        ],
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(_status(settings, vendor)),
        ),
      ],
    );
  }

  List<Widget> _keyFields(
    AiVendor vendor,
    AiSettings settings,
    AiSettingsNotifier notifier,
  ) {
    final hasKey = settings.apiKey != null;
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _keyController,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: '${vendor.name} API key',
            helperText: '${vendor.keyHelp} Stored only on this phone.',
            helperMaxLines: 2,
            hintText: hasKey ? 'A key is saved' : null,
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
              onPressed: hasKey
                  ? () => notifier.setApiKey(vendor.id, null)
                  : null,
              child: const Text('Remove key'),
            ),
            FilledButton(
              onPressed: () async {
                await notifier.setApiKey(vendor.id, _keyController.text);
                _keyController.clear();
              },
              child: const Text('Save key'),
            ),
          ],
        ),
      ),
    ];
  }

  String _status(AiSettings settings, AiVendor? vendor) {
    if (!settings.cloudEnabled) return 'Cloud AI is off.';
    if (vendor == null) return 'Pick an AI provider to use it.';
    return settings.apiKey == null
        ? 'Add your ${vendor.name} key to use it.'
        : 'Using your own ${vendor.name} key.';
  }
}
