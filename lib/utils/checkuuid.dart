import 'package:uuid/uuid.dart';
import 'dart:html'; // Web-related operations


String getOrCreateUniqueId() {
  final storage = window.localStorage;
  const key = 'browserUniqueId';

  // Check if the ID already exists
  if (storage.containsKey(key)) {
    return storage[key]!;
  }

  // Generate a new unique ID
  final uniqueId = const Uuid().v4(); // Generates a UUID
  storage[key] = uniqueId;

  return uniqueId;
}
