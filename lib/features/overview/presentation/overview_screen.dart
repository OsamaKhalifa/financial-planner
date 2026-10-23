/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Overview tab (UC-2). Empty until the dashboard ships.
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabOverview)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
