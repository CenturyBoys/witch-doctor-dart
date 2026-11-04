import 'dispensary.dart';
import 'errors.dart';
import 'injector.dart';

const String _defaultName = 'default';

/// The global entry point of the library.
///
/// Witch Doctor keeps two things:
///
/// * a set of named [Dispensary] instances, each a template of registrations;
/// * a single merged graph built by loading dispensaries into it.
///
/// Typical flow:
///
/// ```dart
/// final d = WitchDoctor.dispensary();        // the 'default' dispensary
/// d.registerLazySingleton<Db>((i) => Db());
/// d.registerFactory<UserRepo>((i) => UserRepo(i<Db>()));
/// WitchDoctor.load();                         // merge into the graph
/// final repo = WitchDoctor.resolve<UserRepo>();
/// ```
class WitchDoctor {
  WitchDoctor._();

  static final WitchDoctor _instance = WitchDoctor._();

  /// Returns the singleton instance.
  factory WitchDoctor() => _instance;

  /// A short handle to the singleton, enabling the callable shorthand:
  ///
  /// ```dart
  /// final wd = WitchDoctor.instance;
  /// final repo = wd<UserRepo>();
  /// ```
  static WitchDoctor get instance => _instance;

  static final Map<String, Dispensary> _dispensaries = {};
  static final Map<Type, Registration> _graph = {};
  static final List<Type> _resolving = [];
  static final Injector _injector = _GraphInjector();

  /// Returns the dispensary named [name], creating it on first access.
  static Dispensary dispensary({String name = _defaultName}) =>
      _dispensaries.putIfAbsent(name, Dispensary.new);

  /// Merges the registrations of the dispensary named [name] into the active
  /// graph.
  ///
  /// Loading is last-wins: if two loaded dispensaries register the same type,
  /// the most recently loaded one is used. Loading dispensaries with disjoint
  /// types aggregates them.
  ///
  /// Throws [DispensaryNotFoundError] if no dispensary named [name] exists.
  static void load({String name = _defaultName}) {
    final dispensary = _dispensaries[name];
    if (dispensary == null) {
      throw DispensaryNotFoundError(name);
    }
    _graph.addAll(dispensary.registrations);
  }

  /// The merged graph as an [Injector], e.g. for use with [inject].
  static Injector get graph => _injector;

  /// Resolves an instance of [T] from the active graph.
  ///
  /// Throws [NotRegisteredError] if nothing is registered for [T], or
  /// [DependencyCycleError] if resolving [T] depends on itself.
  static T resolve<T extends Object>() {
    final registration = _graph[T];
    if (registration == null) {
      throw NotRegisteredError(T);
    }
    if (_resolving.contains(T)) {
      throw DependencyCycleError([..._resolving, T]);
    }
    _resolving.add(T);
    try {
      return registration.resolve(_injector) as T;
    } finally {
      _resolving.removeLast();
    }
  }

  /// Like [resolve] but returns `null` instead of throwing when [T] is not
  /// registered.
  static T? tryResolve<T extends Object>() =>
      _graph.containsKey(T) ? resolve<T>() : null;

  /// Clears every dispensary and the active graph.
  ///
  /// Intended for test isolation — call it in `setUp`/`tearDown` so state does
  /// not leak between tests.
  static void reset() {
    _dispensaries.clear();
    _graph.clear();
    _resolving.clear();
  }

  /// Callable shorthand for [resolve] via [instance]: `wd<UserRepo>()`.
  T call<T extends Object>() => resolve<T>();
}

class _GraphInjector implements Injector {
  @override
  T resolve<T extends Object>() => WitchDoctor.resolve<T>();

  @override
  T call<T extends Object>() => WitchDoctor.resolve<T>();

  @override
  T? tryResolve<T extends Object>() => WitchDoctor.tryResolve<T>();
}

/// Resolves dependencies from the active graph and passes them to [body].
///
/// An AOT-safe echo of the Python sibling's injection decorator:
///
/// ```dart
/// final total = inject((i) => report(i<Repo>(), i<Logger>()));
/// ```
R inject<R>(R Function(Injector injector) body) => body(WitchDoctor.graph);
