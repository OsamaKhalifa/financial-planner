/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/settings_screen.dart';

/// Plan tab: what-if and forecast. Empty until they ship.
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabPlan),
        actions: const [SettingsAction()],
      ),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
