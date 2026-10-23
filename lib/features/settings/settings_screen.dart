import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/ai/ai_settings.dart';
import '../../core/ai/ai_vendors.dart';
import '../export/data/google_sheets_client.dart';
import '../export/export_providers.dart';
import '../export/export_tables.dart';

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
        const Divider(),
        const _GoogleSheetsSection(),
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

class _GoogleSheetsSection extends ConsumerWidget {
  const _GoogleSheetsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(googleAccountProvider);
    final email = account.value;
    final export = ref.watch(exportControllerProvider);
    final running = export is ExportRunning;
    final controller = ref.read(exportControllerProvider.notifier);

    Widget exportTile(
      ExportMode mode,
      IconData icon,
      String title,
      String sub,
    ) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(sub),
      enabled: !running,
      trailing: export is ExportRunning && export.mode == mode
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: () => controller.run(mode),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            'Google Sheets',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: const Text(
            'Export sends a copy of your data to a new spreadsheet in your '
            'Google Drive. Nothing leaves this phone until you tap Export.',
          ),
        ),
        if (account.isLoading)
          const ListTile(title: LinearProgressIndicator())
        else if (email == null)
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Link Google account'),
            onTap: () => _link(context, ref),
          )
        else ...[
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(email),
            subtitle: const Text('Linked'),
            trailing: TextButton(
              onPressed: running
                  ? null
                  : ref.read(googleAccountProvider.notifier).unlink,
              child: const Text('Unlink'),
            ),
          ),
          exportTile(
            ExportMode.full,
            Icons.history,
            'Export everything',
            'Every record, with all history.',
          ),
          exportTile(
            ExportMode.snapshot,
            Icons.today,
            'Export snapshot',
            'Each item as of now, with its value, gain and ROI.',
          ),
          switch (export) {
            ExportDone(:final url) => ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Export done.'),
              trailing: TextButton(
                onPressed: () =>
                    launchUrl(url, mode: LaunchMode.externalApplication),
                child: const Text('Open in Sheets'),
              ),
            ),
            ExportError(:final message) => ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(message),
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ],
    );
  }

  Future<void> _link(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(googleAccountProvider.notifier).link();
    } on ExportFailed catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
