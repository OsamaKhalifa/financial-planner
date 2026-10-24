/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/settings_screen.dart';

/// Zakat tab (UC-3). Empty until the yearly calculation ships.
class ZakatScreen extends StatelessWidget {
  const ZakatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabZakat),
        actions: const [SettingsAction()],
      ),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
