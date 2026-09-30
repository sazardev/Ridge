// A minimal but signature-faithful stand-in for Apple's SwiftUI, SwiftUI's
// Combine re-exports, and the `@AppStorage`/`@Published` property wrappers.
//
// PURPOSE: Apple's SwiftUI does not exist on the Linux Swift toolchain
// (`import SwiftUI` -> "no such module 'SwiftUI'" in docker.io/library/swift:6.2),
// so a SwiftUI snippet cannot be compiled against the real framework here.
// This module exists so the real swiftc 6.2 front end can still typecheck the
// snippets for real, which catches Swift syntax errors, wrong argument labels,
// wrong generic constraints, result-builder misuse, and property-wrapper
// misuse. It deliberately does NOT try to be a running UI framework: it has no
// layout, no rendering and no event loop, so snippets typecheck but cannot run.
//
// Fidelity rules followed here (each one was found by bisecting real compiler
// errors, not guessed):
//   * every declaration is `public` - an `internal` type is invisible to the
//     importing module, which would silently make the snippet untypecheckable;
//   * `ViewBuilder` needs the full `buildBlock` arity ladder 0...10, because a
//     result builder dispatches the whole block through `buildBlock`, not
//     `buildExpression`;
//   * leaf views declare `typealias Body = Never` and get their `body` from
//     `extension View where Body == Never`; declaring their own
//     `var body: Never { fatalError() }` instead makes the `@ViewBuilder`
//     witness transform try to convert the result to `Never` and fail;
//   * `Binding` must NOT declare a `public init(wrappedValue:)`, or `@Binding
//     var x: String` synthesises a memberwise `init` taking `String` and
//     `.constant(...)` stops resolving. Leaving `init` undeclared lets Swift
//     synthesise an `internal` one, invisible to clients, which is exactly
//     what real SwiftUI's `Binding` does.
//
// Known gap, documented rather than hidden: the real `View` protocol and `App`
// protocol are `@MainActor`-isolated in Swift 6 language mode. This stub is not,
// so snippets are typechecked in Swift 5 language mode (the default, and what
// an Xcode 16+ app template uses). Typecheck harness: see harness/verify.sh.

// MARK: - View

public protocol View {
  associatedtype Body: View
  @ViewBuilder var body: Body { get }
}

extension Never: View {
  public typealias Body = Never
}

extension View where Body == Never {
  public var body: Never { fatalError("leaf view") }
}

public struct EmptyView: View {
  public typealias Body = Never
  public init() {}
}

public struct AnyView: View {
  public typealias Body = Never
  public init<V: View>(_ view: V) {}
  public init<V: View>(erasing view: V) {}
}

public struct TupleView<T>: View {
  public typealias Body = Never
  public let value: T
  public init(_ value: T) { self.value = value }
}

public struct _ConditionalContent<TrueContent: View, FalseContent: View>: View {
  public typealias Body = Never
}

public struct OptionalContentWrapper<Content: View>: View {
  public typealias Body = Never
}

// MARK: - ViewBuilder

@resultBuilder
public enum ViewBuilder {
  public static func buildBlock() -> EmptyView { EmptyView() }
  public static func buildBlock<C: View>(_ content: C) -> C { content }
  public static func buildBlock<C0: View, C1: View>(
    _ c0: C0, _ c1: C1
  ) -> TupleView<(C0, C1)> { TupleView((c0, c1)) }
  public static func buildBlock<C0: View, C1: View, C2: View>(
    _ c0: C0, _ c1: C1, _ c2: C2
  ) -> TupleView<(C0, C1, C2)> { TupleView((c0, c1, c2)) }
  public static func buildBlock<C0: View, C1: View, C2: View, C3: View>(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3
  ) -> TupleView<(C0, C1, C2, C3)> { TupleView((c0, c1, c2, c3)) }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4
  ) -> TupleView<(C0, C1, C2, C3, C4)> { TupleView((c0, c1, c2, c3, c4)) }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View, C5: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5
  ) -> TupleView<(C0, C1, C2, C3, C4, C5)> {
    TupleView((c0, c1, c2, c3, c4, c5))
  }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6
  ) -> TupleView<(C0, C1, C2, C3, C4, C5, C6)> {
    TupleView((c0, c1, c2, c3, c4, c5, c6))
  }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View,
    C7: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6,
    _ c7: C7
  ) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)> {
    TupleView((c0, c1, c2, c3, c4, c5, c6, c7))
  }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View,
    C7: View, C8: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6,
    _ c7: C7, _ c8: C8
  ) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)> {
    TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8))
  }
  public static func buildBlock<
    C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View,
    C7: View, C8: View, C9: View
  >(
    _ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6,
    _ c7: C7, _ c8: C8, _ c9: C9
  ) -> TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
    TupleView((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
  }

  public static func buildExpression<C: View>(_ content: C) -> C { content }
  public static func buildExpression<C: View>(_ content: C?) -> C? { content }
  public static func buildLimitedAvailability<C: View>(_ content: C) -> C {
    content
  }
  public static func buildOptional<C: View>(_ content: C?) -> C? { content }
  public static func buildEither<T: View, F: View>(first: T) -> CValue<T, F> {
    fatalError("buildEither(first:)")
  }
  public static func buildEither<T: View, F: View>(second: F) -> CValue<T, F> {
    fatalError("buildEither(second:)")
  }
}

public typealias CValue<T: View, F: View> = _ConditionalContent<T, F>

// MARK: - App / Scene

public protocol Scene {
  associatedtype Body: Scene
  @SceneBuilder var body: Body { get }
}

// `Never` deliberately does NOT conform to `Scene` here: a type can only
// declare one `Body` typealias, and `Never: View` needs it for the leaf-view
// default. Scenes use this dedicated uninhabited stand-in instead.
public struct NeverScene: Scene {
  public typealias Body = NeverScene
}

extension Scene where Body == NeverScene {
  public var body: NeverScene { NeverScene() }
}

@resultBuilder
public enum SceneBuilder {
  public static func buildBlock() -> EmptyScene { EmptyScene() }
  public static func buildBlock<S: Scene>(_ scene: S) -> S { scene }
  public static func buildBlock<S0: Scene, S1: Scene>(
    _ s0: S0, _ s1: S1
  ) -> TupleScene<(S0, S1)> { fatalError("buildBlock") }
}

public struct EmptyScene: Scene {
  public typealias Body = NeverScene
  public init() {}
}

public struct TupleScene<T>: Scene {
  public typealias Body = NeverScene
  public let value: T
  public init(_ value: T) { self.value = value }
}

public protocol App {
  associatedtype Body: Scene
  @SceneBuilder var body: Body { get }
}

// The real SwiftUI `App` protocol ships exactly this default, and it is what
// makes `@main` legal on an `App` type: `@main` needs a `static func main()`,
// and conformance supplies one.
extension App {
  public static func main() {}
}

public struct WindowGroup<Content: View>: Scene {
  public typealias Body = NeverScene
  public init(@ViewBuilder content: () -> Content) {}
  public init(@ViewBuilder content: () -> Content, id: String) {}
}

public struct Window: Scene {
  public typealias Body = NeverScene
  public init(@ViewBuilder content: () -> some View) {}
}

@resultBuilder
public enum AppBuilder {
  public static func buildBlock<A: App>(_ app: A) -> A { app }
}

@propertyWrapper
public struct AppStorage<Value> {
  private final class Box {
    var value: Value
    init(_ value: Value) { self.value = value }
  }

  private final class Storage {
    var box: Box
    init(_ box: Box) { self.box = box }
  }

  private let storage: Storage

  public var wrappedValue: Value {
    get { storage.box.value }
    nonmutating set { storage.box.value = newValue }
  }

  public var projectedValue: Binding<Value> {
    Binding(BindingBox(
      get: { storage.box.value },
      set: { storage.box.value = $0 }
    ))
  }

  public init(wrappedValue: Value, _ key: String) {
    storage = Storage(Box(wrappedValue))
  }

  public init(wrappedValue: Value, _ key: String, store: Any?) {
    storage = Storage(Box(wrappedValue))
  }
}

extension AppStorage where Value == Int {
  public init(_ key: String) {
    self.init(wrappedValue: 0, key)
  }
  public init(_ key: String, store: Any?) {
    self.init(wrappedValue: 0, key)
  }
}

extension AppStorage where Value == Double {
  public init(_ key: String) {
    self.init(wrappedValue: 0.0, key)
  }
  public init(_ key: String, store: Any?) {
    self.init(wrappedValue: 0.0, key)
  }
}

extension AppStorage where Value == String {
  public init(_ key: String) {
    self.init(wrappedValue: "", key)
  }
  public init(_ key: String, store: Any?) {
    self.init(wrappedValue: "", key)
  }
}

extension AppStorage where Value == Bool {
  public init(_ key: String) {
    self.init(wrappedValue: false, key)
  }
  public init(_ key: String, store: Any?) {
    self.init(wrappedValue: false, key)
  }
}

@propertyWrapper
public struct SceneStorage<Value> {
  public init(wrappedValue: Value) {}
  public var wrappedValue: Value {
    get { fatalError("SceneStorage") }
    nonmutating set {}
  }
  public var projectedValue: Binding<Value> { fatalError("SceneStorage") }
}
