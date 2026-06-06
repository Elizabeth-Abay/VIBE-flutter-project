import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_app/features/posts/presentation/providers/post_provider.dart';

void main() {
  group('CategoryNotifier (Riverpod)', () {
    // Helper: build a fresh ProviderContainer per test
    ProviderContainer makeContainer() => ProviderContainer();

    tearDown(() {});

    // ── initial state ────────────────────────────────────────────────────────

    test('initial state is "books"', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final state = container.read(selectedCategoryProvider);
      expect(state, equals('books'));
    });

    // ── updateCategory ───────────────────────────────────────────────────────

    test('updateCategory changes state to the new category', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.read(selectedCategoryProvider.notifier).updateCategory('music');
      expect(container.read(selectedCategoryProvider), equals('music'));
    });

    test('updateCategory can be called multiple times', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(selectedCategoryProvider.notifier);

      notifier.updateCategory('movies');
      expect(container.read(selectedCategoryProvider), equals('movies'));

      notifier.updateCategory('gaming');
      expect(container.read(selectedCategoryProvider), equals('gaming'));

      notifier.updateCategory('books');
      expect(container.read(selectedCategoryProvider), equals('books'));
    });

    test('updateCategory with empty string sets state to empty string', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container
          .read(selectedCategoryProvider.notifier)
          .updateCategory('');
      expect(container.read(selectedCategoryProvider), equals(''));
    });

    // ── reactivity ───────────────────────────────────────────────────────────

    test('listener is notified when category changes', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final received = <String>[];
      container.listen<String>(
        selectedCategoryProvider,
        (prev, next) => received.add(next),
      );

      container
          .read(selectedCategoryProvider.notifier)
          .updateCategory('art');

      expect(received, equals(['art']));
    });

    test('listener receives each consecutive change', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final received = <String>[];
      container.listen<String>(
        selectedCategoryProvider,
        (_, next) => received.add(next),
      );

      container
          .read(selectedCategoryProvider.notifier)
          .updateCategory('sports');
      container
          .read(selectedCategoryProvider.notifier)
          .updateCategory('tech');

      expect(received, equals(['sports', 'tech']));
    });

    // ── isolation ────────────────────────────────────────────────────────────

    test('two containers do not share state', () {
      final a = makeContainer();
      final b = makeContainer();
      addTearDown(a.dispose);
      addTearDown(b.dispose);

      a.read(selectedCategoryProvider.notifier).updateCategory('music');

      expect(a.read(selectedCategoryProvider), equals('music'));
      expect(b.read(selectedCategoryProvider), equals('books')); // unaffected
    });
  });

  // ── CreatePostNotifier ───────────────────────────────────────────────────

  group('CreatePostNotifier (Riverpod)', () {
    test('initial state is AsyncData(false)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(createPostNotifierProvider);
      expect(state, equals(const AsyncData<bool>(false)));
    });

    test('initial state is not loading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(createPostNotifierProvider).isLoading,
        isFalse,
      );
    });

    test('initial state has no error', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(createPostNotifierProvider).hasError,
        isFalse,
      );
    });
  });
}
