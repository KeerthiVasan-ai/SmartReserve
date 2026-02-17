// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingNotifier)
final bookingProvider = BookingNotifierProvider._();

final class BookingNotifierProvider
    extends $NotifierProvider<BookingNotifier, BookingState> {
  BookingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingNotifierHash();

  @$internal
  @override
  BookingNotifier create() => BookingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingState>(value),
    );
  }
}

String _$bookingNotifierHash() => r'e059f83c777e1cc7adedffe57774613d894ea4e3';

abstract class _$BookingNotifier extends $Notifier<BookingState> {
  BookingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BookingState, BookingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingState, BookingState>,
              BookingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
