/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
