import 'dart:async';

/// Emits [combine] of the latest values once all three streams have
/// emitted, then on every change. Errors are forwarded; closes when all
/// sources are done. (Avoids pulling in rxdart for one operator.)
Stream<R> combineLatest3<A, B, C, R>(
  Stream<A> a,
  Stream<B> b,
  Stream<C> c,
  R Function(A a, B b, C c) combine,
) {
  late StreamController<R> controller;
  final subs = <StreamSubscription<Object?>>[];
  A? va;
  B? vb;
  C? vc;
  var hasA = false;
  var hasB = false;
  var hasC = false;
  var done = 0;

  void emit() {
    if (hasA && hasB && hasC) {
      controller.add(combine(va as A, vb as B, vc as C));
    }
  }

  void onDone() {
    if (++done == 3) unawaited(controller.close());
  }

  controller = StreamController<R>(
    onListen: () {
      subs
        ..add(
          a.listen(
            (v) {
              va = v;
              hasA = true;
              emit();
            },
            onError: controller.addError,
            onDone: onDone,
          ),
        )
        ..add(
          b.listen(
            (v) {
              vb = v;
              hasB = true;
              emit();
            },
            onError: controller.addError,
            onDone: onDone,
          ),
        )
        ..add(
          c.listen(
            (v) {
              vc = v;
              hasC = true;
              emit();
            },
            onError: controller.addError,
            onDone: onDone,
          ),
        );
    },
    onPause: () {
      for (final s in subs) {
        s.pause();
      }
    },
    onResume: () {
      for (final s in subs) {
        s.resume();
      }
    },
    onCancel: () => Future.wait(subs.map((s) => s.cancel())),
  );
  return controller.stream;
}
