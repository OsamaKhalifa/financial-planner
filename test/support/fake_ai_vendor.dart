import 'package:financial_planner/core/ai/ai_vendors.dart';
import 'package:http/http.dart' as http;

import 'fake_ai_client.dart';

/// A second vendor, to prove adding one changes nothing else.
final fakeVendorClient = FakeAiClient(reply: 'from fake vendor');

final fakeVendor = AiVendor(
  id: 'fakeai',
  name: 'Fake AI',
  keyHelp: 'Get a key at fake.example.',
  dataNotice: 'Text goes to Fake AI.',
  createClient: (http.Client _, String _) => fakeVendorClient,
);
