import 'package:flutter_playground/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goodStreamProviderA = StreamProvider.autoDispose((ref) {
  ref.onDispose(() {
    logger.info('dispose goodStreamProviderA');
  });
  return Stream<int>.periodic(const Duration(seconds: 2), (count) => count);
});

final goodStreamProviderB = StreamProvider.autoDispose((ref) {
  ref.onDispose(() {
    logger.info('dispose goodStreamProviderB');
  });
  return Stream<int>.periodic(const Duration(seconds: 3), (count) => count);
});

final goodFutureProvider = FutureProvider.autoDispose((ref) async {
  ref.onDispose(() {
    logger.info('dispose goodFutureProvider');
  });
  final a = ref.watch(goodStreamProviderA).valueOrNull ?? 0;
  final b = ref.watch(goodStreamProviderB).valueOrNull ?? 0;

  return a * b;
});

final badStreamProviderA = StreamProvider.autoDispose((ref) {
  ref.onDispose(() {
    logger.info('dispose badStreamProviderA');
  });
  return Stream<int>.periodic(const Duration(seconds: 2), (count) => count);
});

final badStreamProviderB = StreamProvider.autoDispose((ref) {
  ref.onDispose(() {
    logger.info('dispose badStreamProviderB');
  });
  return Stream<int>.periodic(const Duration(seconds: 3), (count) => count);
});

final badFutureProvider = FutureProvider.autoDispose((ref) async {
  ref.onDispose(() {
    logger.info('dispose badFutureProvider');
  });
  // あのawait中にbはdisposeされている
  final a = await ref.watch(badStreamProviderA.future);
  final b = ref.watch(badStreamProviderB).valueOrNull ?? 0;

  return a * b;
});
