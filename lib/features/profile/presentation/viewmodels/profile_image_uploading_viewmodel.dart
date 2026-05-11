import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileImageUploadingProvider =
    NotifierProvider.autoDispose.family<_ProfileImageUploadingNotifier, bool, Object>(
  _ProfileImageUploadingNotifier.new,
);

class _ProfileImageUploadingNotifier extends Notifier<bool> {
  _ProfileImageUploadingNotifier(this.key);

  final Object key;

  @override
  bool build() => false;

  void setUploading(bool value) => state = value;
}