import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_thumbnails.g.dart';

/// Map snapshots taken by a measure screen right before opening Save
/// (400×400 PNG), handed to `SaveController`. Kept in memory only: if the
/// app dies, Save falls back to a drawn thumbnail.
class PendingThumbnails {
  final Map<String, Uint8List> _byId = {};

  void put(String measurementId, Uint8List png) => _byId[measurementId] = png;

  Uint8List? peek(String measurementId) => _byId[measurementId];

  Uint8List? take(String measurementId) => _byId.remove(measurementId);
}

@Riverpod(keepAlive: true)
PendingThumbnails pendingThumbnails(Ref ref) => PendingThumbnails();
