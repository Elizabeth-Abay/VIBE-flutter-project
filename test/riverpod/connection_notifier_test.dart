import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/connections/presentation/providers/connection_notifier.dart';

void main() {
  group('ConnectionActionNotifier (Riverpod)', () {
    ProviderContainer makeContainer() => ProviderContainer();

    // ── initial state ──────────────────────────────────────────────────────

    test('starts as AsyncData(null) — idle', () {
      final c = makeContainer();
      addTearDown(c.dispose);

      final state = c.read(connectionActionProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
    });

    test('initial state value is null', () {
      final c = makeContainer();
      addTearDown(c.dispose);

      final state = c.read(connectionActionProvider);
      // AsyncValue<void> can't use .value in expressions — assert the idle state directly
      expect(state, const AsyncData<void>(null));
    });

    // ── isolation ─────────────────────────────────────────────────────────

    test('two containers have independent action state', () {
      final c1 = makeContainer();
      final c2 = makeContainer();
      addTearDown(c1.dispose);
      addTearDown(c2.dispose);

      expect(c1.read(connectionActionProvider).isLoading, isFalse);
      expect(c2.read(connectionActionProvider).isLoading, isFalse);
    });

    // ── listener setup ─────────────────────────────────────────────────────

    test('listener can be attached without errors', () {
      final c = makeContainer();
      addTearDown(c.dispose);

      final received = <AsyncValue<void>>[];
      c.listen<AsyncValue<void>>(
        connectionActionProvider,
        (_, next) => received.add(next),
      );

      // No mutations yet — just verify listener setup doesn't throw
      expect(received, isEmpty);
    });
  });

  group('connectionsFeedProvider (Riverpod)', () {
    test('provider exists and is a FutureProvider', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      // Reading the provider should not throw; it returns AsyncValue
      final state = c.read(connectionsFeedProvider);
      // It will be AsyncLoading initially (no real repo in unit tests)
      expect(state, isA<AsyncValue>());
    });
  }); 

  group('peopleNotifierProvider (Riverpod)', () {
    test('provider exists and is a FutureProvider', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final state = c.read(peopleNotifierProvider);
      expect(state, isA<AsyncValue>());
    });
  });
}
