// Part 2: the concrete view types, shapes, styles, property wrappers and
// modifiers the catalog uses. Same contract as part 1: signature-faithful
// enough that idiomatic SwiftUI typechecks, no rendering.

// MARK: - Combine's observable surface

public final class ObservableObjectPublisher {
  public init() {}
  public func send() {}
}

public let sharedObjectWillChange = ObservableObjectPublisher()

public protocol ObservableObject: AnyObject {}

extension ObservableObject {
  public var objectWillChange: ObservableObjectPublisher { sharedObjectWillChange }
}

@propertyWrapper
public struct Published<Value> {
  public var wrappedValue: Value
  public init(wrappedValue: Value) { self.wrappedValue = wrappedValue }
  public var projectedValue: Binding<Value> { Binding.constant(wrappedValue) }
}

/// The type behind `$model`.
///
/// DELIBERATELY NOT `@dynamicMemberLookup`: the real `ObservedObject.Wrapper`
/// has no such subscript, so `$model.display` on a `@StateObject` or
/// `@EnvironmentObject` does not compile in SwiftUI and must not compile here
/// either — a stub that is more permissive than the SDK in a way that HIDES a
/// real error is worse than no stub. Reaching into an observable class is done
/// with `@Observable` + `@Bindable`, or by passing plain values, which is what
/// the catalog's own lessons do.
public struct ObservableObjectWrapper<ObjectType: ObservableObject> {
  public var wrappedValue: ObjectType
  public init(wrappedValue: ObjectType) { self.wrappedValue = wrappedValue }
}

// MARK: - Property wrappers

public struct BindingBox<Value> {
  public var get: () -> Value
  public var set: (Value) -> Void
  public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
    self.get = get
    self.set = set
  }
}

/// `@dynamicMemberLookup` is what makes `$calculator.display` legal: a
/// `Binding<Calculator>` reaches through to a `Binding<String>`.
@propertyWrapper
@dynamicMemberLookup
public struct Binding<Value> {
  // One private stored property and NO declared public initializer, so Swift
  // synthesises only a private memberwise `init(box:)` that client modules
  // cannot see. See SwiftUIStub.swift's header for why declaring a PUBLIC
  // `init(wrappedValue:)` is wrong here: it would make `@Binding var x: String`
  // synthesise a memberwise init taking a bare `String`, and `.constant(_:)`
  // would stop resolving.
  private let box: BindingBox<Value>

  /// Internal so the stub's own wrappers in other files can build one.
  init(_ box: BindingBox<Value>) { self.box = box }

  public var wrappedValue: Value {
    get { box.get() }
    nonmutating set { box.set(newValue) }
  }

  public var projectedValue: Binding<Value> { self }

  public subscript<Subject>(
    dynamicMember keyPath: WritableKeyPath<Value, Subject>
  ) -> Binding<Subject> {
    let box: BindingBox<Subject> = BindingBox(
      get: { wrappedValue[keyPath: keyPath] },
      set: { wrappedValue[keyPath: keyPath] = $0 }
    )
    return Binding<Subject>(box)
  }

  public static func constant(_ value: Value) -> Binding<Value> {
    Binding(BindingBox(get: { value }, set: { _ in }))
  }
}

@propertyWrapper
public struct State<Value> {
  public final class Box {
    public var value: Value
    public init(_ value: Value) { self.value = value }
  }

  private let box: Box

  public var wrappedValue: Value {
    get { box.value }
    nonmutating set { box.value = newValue }
  }

  public var projectedValue: Binding<Value> {
    get { Binding(BindingBox(get: { box.value }, set: { box.value = $0 })) }
  }

  public init(wrappedValue: Value) { box = Box(wrappedValue) }
  public init(initialValue: Value) { box = Box(initialValue) }
}

@propertyWrapper
public struct ObservedObject<ObjectType: ObservableObject> {
  public var wrappedValue: ObjectType
  public init(wrappedValue: ObjectType) { self.wrappedValue = wrappedValue }
  public var projectedValue: ObservableObjectWrapper<ObjectType> {
    ObservableObjectWrapper(wrappedValue: wrappedValue)
  }
}

@propertyWrapper
public struct StateObject<ObjectType: ObservableObject> {
  public final class Box {
    public let value: ObjectType
    public init(_ value: ObjectType) { self.value = value }
  }

  private let box: Box

  public var wrappedValue: ObjectType { box.value }
  public var projectedValue: ObservableObjectWrapper<ObjectType> {
    ObservableObjectWrapper(wrappedValue: box.value)
  }

  public init(wrappedValue: @autoclosure @escaping () -> ObjectType) {
    box = Box(wrappedValue())
  }
}

public protocol EnvironmentKey {
  associatedtype Value
  static var defaultValue: Value { get }
}

public struct EnvironmentValues {
  public init() {}
  public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
    get { K.defaultValue }
  }
}

public struct ColorScheme: Sendable {
  public let isDark: Bool
  public init(isDark: Bool) { self.isDark = isDark }
  public static let light = ColorScheme(isDark: false)
  public static let dark = ColorScheme(isDark: true)
}

public extension EnvironmentValues {
  var colorScheme: ColorScheme {
    get { self[ColorSchemeKey.self] }
  }
  var isEnabled: Bool {
    get { self[IsEnabledKey.self] }
  }
  var dismiss: DismissAction {
    get { self[DismissKey.self] }
  }
  var openURL: OpenURLAction {
    get { self[OpenURLKey.self] }
  }
}

public struct DismissAction {
  public func callAsFunction() {}
}

public struct OpenURLAction {
  public func callAsFunction(_ url: URL) {}
}

public struct ColorSchemeKey: EnvironmentKey {
  public static var defaultValue: ColorScheme { .light }
}

public struct IsEnabledKey: EnvironmentKey {
  public static var defaultValue: Bool { true }
}

public struct DismissKey: EnvironmentKey {
  public static var defaultValue: DismissAction { DismissAction() }
}

public struct OpenURLKey: EnvironmentKey {
  public static var defaultValue: OpenURLAction { OpenURLAction() }
}

@propertyWrapper
public struct Environment<Value> {
  private var stored: Value?

  public var wrappedValue: Value { stored! }

  public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
    stored = EnvironmentValues()[keyPath: keyPath]
  }

  public init() { stored = nil }
}

@propertyWrapper
public struct EnvironmentObject<ObjectType: ObservableObject> {
  private var stored: ObjectType?
  public var wrappedValue: ObjectType { stored! }
  public init(wrappedValue: ObjectType) { stored = wrappedValue }
  public var projectedValue: ObservableObjectWrapper<ObjectType> {
    ObservableObjectWrapper(wrappedValue: stored!)
  }
  /// The no-argument initializer is what lets Swift synthesise a memberwise
  /// `init()` for a view whose only stored property is `@EnvironmentObject`:
  /// Swift gives that memberwise parameter a default when the wrapper has an
  /// `init()`, so `DetailView()` compiles with nothing to pass in.
  public init() {}
}

/// Stands in for Foundation's `UUID`, which a real app reaches through
/// SwiftUI's own Foundation re-export (an app file needs only `import SwiftUI`).
public struct UUID: Hashable {
  private let value: String
  public init() { value = "uuid" }
  public var uuidString: String { value }
}

// MARK: - Primitive views

public struct Text: View {
  public typealias Body = Never
  public struct TruncationMode {
    public static let head = TruncationMode()
    public static let middle = TruncationMode()
    public static let tail = TruncationMode()
  }
  public let content: String
  public init(_ content: String) { self.content = content }
  public init(verbatim content: String) { self.content = content }
  public init<S: StringProtocol>(_ content: S) { self.content = String(content) }
  public func monospacedDigit() -> Font { .monospacedDigit }
  public func truncationMode(_ mode: Text.TruncationMode) -> some View {
    ModifiedContent(content: EmptyView(), modifier: FontModifier(.body))
  }
}

public struct Image: View {
  public typealias Body = Never
  public let name: String
  public init(systemName: String) { name = systemName }
  public init(_ name: String) { self.name = name }
  public init(systemName: String, bundle: Bundle?) { name = systemName }
}

public struct Button<Label: View>: View {
  public typealias Body = Never
  public let action: () -> Void
  public let label: Label

  public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
    self.action = action
    self.label = label()
  }

  public init<S: StringProtocol>(
    _ title: S, action: @escaping () -> Void
  ) where Label == Text {
    self.action = action
    self.label = Text(title)
  }
}

public extension Button where Label == Text {
  init<S: StringProtocol>(_ title: S, systemImage: String, action: @escaping () -> Void) {
    self.init(title, action: action)
  }
}

public struct TextField<Label: View>: View {
  public typealias Body = Never
  public let title: String
  public init(_ title: String, text: Binding<String>) where Label == Text {
    self.title = title
  }
  public init(_ title: String, text: Binding<Double>) where Label == Text {
    self.title = title
  }
  public init(_ title: String, text: Binding<Int>) where Label == Text {
    self.title = title
  }
}

public struct SecureField<Label: View>: View {
  public typealias Body = Never
  public init(_ title: String, text: Binding<String>) where Label == Text {}
}

public struct Toggle: View {
  public typealias Body = Never
  public init(_ title: String, isOn: Binding<Bool>) {}
}

public struct Slider: View {
  public typealias Body = Never
  public init(value: Binding<Double>, in bounds: ClosedRange<Double>) {}
}

public struct Stepper: View {
  public typealias Body = Never
  public init(_ title: String, value: Binding<Int>, in bounds: ClosedRange<Int>) {}
}

public struct ProgressView: View {
  public typealias Body = Never
  public init() {}
  public init(_ label: String) {}
}

public struct Link: View {
  public typealias Body = Never
  public init(_ title: String, destination: URL) {}
}

public struct EmptyInit: View {
  public typealias Body = Never
  public init() {}
}

public struct UIKeyboardType {
  public let name: String
  public init(_ name: String) { self.name = name }
  public static let `default` = UIKeyboardType("default")
  public static let numberPad = UIKeyboardType("numberPad")
  public static let decimalPad = UIKeyboardType("decimalPad")
  public static let emailAddress = UIKeyboardType("emailAddress")
}

// MARK: - Containers

public struct VStack<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct HStack<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct ZStack<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    alignment: Alignment = .center,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct Group<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
}

public struct LazyVGrid<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    columns: [GridItem],
    alignment: HorizontalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct LazyHGrid<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    rows: [GridItem],
    alignment: VerticalAlignment = .center,
    spacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct Grid<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(
    alignment: Alignment = .center,
    horizontalSpacing: CGFloat? = nil,
    verticalSpacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }
}

public struct GridRow<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(alignment: VerticalAlignment = .center, @ViewBuilder content: () -> Content) {
    self.content = content()
  }
}

public struct GridItem {
  public init(
    _ size: GridItemSize = .flexible(),
    spacing: CGFloat? = nil,
    alignment: Alignment? = nil
  ) {}
  public init(
    _ size: CGFloat,
    spacing: CGFloat? = nil,
    alignment: Alignment? = nil
  ) {}
}

public struct GridItemSize {
  public static func fixed(_ value: CGFloat) -> GridItemSize { GridItemSize() }
  public static func flexible(minimum: CGFloat = 0, maximum: CGFloat = 40) -> GridItemSize {
    GridItemSize()
  }
  public static func adaptive(minimum: CGFloat, maximum: CGFloat = 40) -> GridItemSize {
    GridItemSize()
  }
}

public struct Spacer: View {
  public typealias Body = Never
  public init(minLength: CGFloat? = nil) {}
}

public struct Divider: View {
  public typealias Body = Never
  public init() {}
}

public struct ScrollView<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public init(_ axes: Axis.Set, @ViewBuilder content: () -> Content) {
    self.content = content()
  }
}

public struct List<Content: View>: View {
  public typealias Body = Never
  public let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
}

public struct ForEach<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
  public typealias Body = Never
  public let content: Content
  var unused: Never { fatalError() }
}

extension ForEach where Data.Element: Identifiable, ID == Data.Element.ID {
  public init(
    _ data: Binding<Data>,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) {
    precondition(data.wrappedValue.count >= 0)
    self.content = content(data.wrappedValue.first!)
  }
}

extension ForEach where Data.Element: Identifiable, ID == Data.Element.ID {
  public init(
    _ data: Data,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) {
    precondition(data.count >= 0)
    self.content = content(data.first!)
  }
}

extension ForEach {
  public init(
    _ data: Data,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) {
    precondition(data.count >= 0)
    self.content = content(data.first!)
  }
  public init(
    _ data: Binding<Data>,
    id: KeyPath<Data.Element, ID>,
    @ViewBuilder content: @escaping (Data.Element) -> Content
  ) {
    precondition(data.wrappedValue.count >= 0)
    self.content = content(data.wrappedValue.first!)
  }
}

public struct ListForEachModifier<Item: Identifiable>: View {
  public typealias Body = Never
  public let items: [Item]
  public init(_ items: [Item]) { self.items = items }
}

// MARK: - Alignment

public struct HorizontalAlignment: Hashable {
  public static let leading = HorizontalAlignment()
  public static let center = HorizontalAlignment()
  public static let trailing = HorizontalAlignment()
}

public struct VerticalAlignment: Hashable {
  public static let top = VerticalAlignment()
  public static let center = VerticalAlignment()
  public static let bottom = VerticalAlignment()
  public static let firstTextBaseline = VerticalAlignment()
}

public struct Alignment: Hashable {
  public static let center = Alignment()
  public static let topLeading = Alignment()
  public static let top = Alignment()
  public static let topTrailing = Alignment()
  public static let leading = Alignment()
  public static let trailing = Alignment()
  public static let bottomLeading = Alignment()
  public static let bottom = Alignment()
  public static let bottomTrailing = Alignment()
}

// MARK: - Shapes and styles

public struct Color: View, Hashable, ShapeStyle {
  public typealias Body = Never
  public let name: String
  public init(_ name: String) { self.name = name }
  public init(red: Double, green: Double, blue: Double, opacity: Double = 1) {
    name = "rgb"
  }
  public init(white: Double, opacity: Double = 1) { name = "white" }
  public init(_ space: Color.RGBColorSpace, red: Double, green: Double, blue: Double) {
    name = "rgb"
  }
  public enum RGBColorSpace {
    case sRGB
  }
  public static let clear = Color("clear")
  public static let black = Color("black")
  public static let white = Color("white")
  public static let gray = Color("gray")
  public static let red = Color("red")
  public static let green = Color("green")
  public static let blue = Color("blue")
  public static let orange = Color("orange")
  public static let yellow = Color("yellow")
  public static let pink = Color("pink")
  public static let purple = Color("purple")
  public static let primary = Color("primary")
  public static let secondary = Color("secondary")
  public static let accentColor = Color("accentColor")
  public static let background = Color("background")
  public func opacity(_ opacity: Double) -> Color {
    Color("\(name)-\(opacity)")
  }
}

public struct Font: Hashable {
  public let name: String
  public init(_ name: String) { self.name = name }
  public static let largeTitle = Font("largeTitle")
  public static let title = Font("title")
  public static let title2 = Font("title2")
  public static let title3 = Font("title3")
  public static let headline = Font("headline")
  public static let subheadline = Font("subheadline")
  public static let body = Font("body")
  public static let callout = Font("callout")
  public static let subhead = Font("subhead")
  public static let footnote = Font("footnote")
  public static let caption = Font("caption")
  public static let caption2 = Font("caption2")
  public static let monospaced = Font("monospaced")
  public static let monospacedDigit = Font("monospacedDigit")
  public static func system(
    size: CGFloat, weight: Weight = .regular, design: Design = .default
  ) -> Font { Font("system") }
  public static func system(
    _ style: TextStyle, design: Design = .default
  ) -> Font { Font("system-style") }
  public static func system(
    size: CGFloat, relativeTo: TextStyle, design: Design = .default
  ) -> Font { Font("system-relative") }
  public static func custom(_ name: String, size: CGFloat) -> Font { Font("custom") }
  public struct Weight: Hashable {
    public static let regular = Weight()
    public static let medium = Weight()
    public static let semibold = Weight()
    public static let bold = Weight()
    public static let heavy = Weight()
    public static let light = Weight()
    public static let thin = Weight()
  }
  public struct Design: Hashable {
    public static let `default` = Design()
    public static let monospaced = Design()
    public static let rounded = Design()
    public static let serif = Design()
  }
  public struct TextStyle: Hashable {
    public static let largeTitle = TextStyle()
    public static let title = TextStyle()
    public static let title2 = TextStyle()
    public static let title3 = TextStyle()
    public static let headline = TextStyle()
    public static let subheadline = TextStyle()
    public static let body = TextStyle()
    public static let callout = TextStyle()
    public static let subhead = TextStyle()
    public static let footnote = TextStyle()
    public static let caption = TextStyle()
    public static let caption2 = TextStyle()
  }
  public func bold() -> Font { self }
  public func weight(_ weight: Weight) -> Font { self }
  public func italic() -> Font { self }
  public func monospacedDigit() -> Font { self }
}

public protocol Shape: View where Body == Never {}

public struct Path {
  public init() {}
  public init(rect: CGRect) {}
  public init(roundedRect: CGRect, cornerRadius: CGFloat) {}
  public mutating func addPath(_ other: Path) {}
}

public struct CGRect {
  public var origin: CGPoint
  public var size: CGSize
  public var width: CGFloat { size.width }
  public var height: CGFloat { size.height }
  public var minX: CGFloat { origin.x }
  public var maxX: CGFloat { origin.x + size.width }
  public var midX: CGFloat { origin.x + size.width / 2 }
  public var minY: CGFloat { origin.y }
  public var maxY: CGFloat { origin.y + size.height }
  public var midY: CGFloat { origin.y + size.height / 2 }
  public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
    origin = CGPoint(x: x, y: y)
    size = CGSize(width: width, height: height)
  }
  public init(origin: CGPoint, size: CGSize) {
    self.origin = origin
    self.size = size
  }
}

public struct CGPoint {
  public var x: CGFloat
  public var y: CGFloat
  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
}

public struct CGSize {
  public var width: CGFloat
  public var height: CGFloat
  public init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
}

public struct EdgeInsets {
  public static let zero = EdgeInsets()
  public var top: CGFloat
  public var leading: CGFloat
  public var bottom: CGFloat
  public var trailing: CGFloat
  public init(
    top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0
  ) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
  public static func all(_ length: CGFloat) -> EdgeInsets {
    EdgeInsets(top: length, leading: length, bottom: length, trailing: length)
  }
}

public typealias CGFloat = Double

public struct Rectangle: Shape {
  public init() {}
}

public struct Circle: Shape {
  public init() {}
}

public struct Capsule: Shape {
  public init(style: RoundedCornerStyle = .circular) {}
}

public struct RoundedRectangle: Shape {
  public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {}
  public init(cornerSize: CGSize, style: RoundedCornerStyle = .circular) {}
}

public struct UnevenRoundedRectangle: Shape {
  public init(
    topLeadingRadius: CGFloat = 0,
    bottomLeadingRadius: CGFloat = 0,
    bottomTrailingRadius: CGFloat = 0,
    topTrailingRadius: CGFloat = 0,
    style: RoundedCornerStyle = .circular
  ) {}
}

public struct RoundedCornerStyle {
  public static let circular = RoundedCornerStyle()
  public static let continuous = RoundedCornerStyle()
}

public struct RoundedRectangleShape: Shape {
  public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {}
}

public struct AngularGradient: Hashable, ShapeStyle {
  public init(
    colors: [Color],
    center: UnitPoint = .center,
    startAngle: Angle = .zero,
    endAngle: Angle = .zero
  ) {}
}

public struct LinearGradient: Hashable, ShapeStyle {
  public init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {}
  public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {}
}

public struct Gradient {
  public static let colors: [Color] = []
  public init(colors: [Color]) {}
  public init(stops: [Gradient.Stop]) {}
  public struct Stop {
    public init(color: Color, location: CGFloat) {}
  }
}

public protocol ShapeStyle {}

public struct UnitPoint: Hashable {
  public static let center = UnitPoint()
  public static let top = UnitPoint()
  public static let bottom = UnitPoint()
  public static let leading = UnitPoint()
  public static let trailing = UnitPoint()
  public static let topLeading = UnitPoint()
  public static let topTrailing = UnitPoint()
  public static let bottomLeading = UnitPoint()
  public static let bottomTrailing = UnitPoint()
}

public struct Angle {
  public static let zero = Angle()
}

public struct AccessibilityTraits: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }
  public static let isButton = AccessibilityTraits(rawValue: 1)
  public static let isHeader = AccessibilityTraits(rawValue: 2)
  public static let isSelected = AccessibilityTraits(rawValue: 4)
  public static let isStaticText = AccessibilityTraits(rawValue: 8)
}

// MARK: - Button styles

public protocol PrimitiveButtonStyle {
  associatedtype Body: View
  func makeBody(configuration: Configuration) -> Body
  typealias Configuration = PrimitiveButtonStyleConfiguration
}

public struct PrimitiveButtonStyleConfiguration {
  public let label: AnyView
  public let isPressed: Bool
}

public struct BorderedProminentButtonStyle: PrimitiveButtonStyle {
  public init() {}
  public typealias Body = Never
  public func makeBody(configuration: Configuration) -> Never {
    fatalError()
  }
}

public struct PlainButtonStyle: PrimitiveButtonStyle {
  public init() {}
  public typealias Body = Never
  public func makeBody(configuration: Configuration) -> Never {
    fatalError()
  }
}

public struct BorderlessButtonStyle: PrimitiveButtonStyle {
  public init() {}
  public typealias Body = Never
  public func makeBody(configuration: Configuration) -> Never {
    fatalError()
  }
}

public struct DefaultButtonStyle: PrimitiveButtonStyle {
  public init() {}
  public typealias Body = Never
  public func makeBody(configuration: Configuration) -> Never {
    fatalError()
  }
}

public struct CapsuleTextFieldStyle {
  public init() {}
}

public struct RoundedBorderTextFieldStyle {
  public init() {}
}

public extension PrimitiveButtonStyle where Self == PlainButtonStyle {
  static var plain: PlainButtonStyle { PlainButtonStyle() }
}

public extension PrimitiveButtonStyle where Self == BorderlessButtonStyle {
  static var borderless: BorderlessButtonStyle { BorderlessButtonStyle() }
}

public extension PrimitiveButtonStyle where Self == BorderedProminentButtonStyle {
  static var borderedProminent: BorderedProminentButtonStyle {
    BorderedProminentButtonStyle()
  }
}

// MARK: - Animation

public struct Animation: Hashable {
  public let name: String
  public init(_ name: String) { self.name = name }
  public static let `default` = Animation("default")
  public static let linear = Animation("linear")
  public static func linear(duration: Double = 0.35) -> Animation {
    Animation("linear")
  }
  public static func easeInOut(duration: Double) -> Animation { Animation("easeInOut") }
  public static func easeIn(duration: Double) -> Animation { Animation("easeIn") }
  public static func easeOut(duration: Double) -> Animation { Animation("easeOut") }
  public static func spring(response: Double, dampingFraction: Double = 0.825, blendDuration: Double = 0) -> Animation {
    Animation("spring")
  }
  public static func spring(duration: Double, damping: Double) -> Animation {
    Animation("spring")
  }
  public static func interactiveSpring() -> Animation { Animation("spring") }
}

public struct Transaction {
  public static var current: Transaction { Transaction() }
  public var animation: Animation?
  public init() {}
}

@discardableResult
public func withAnimation<Result>(
  _ animation: Animation? = nil, _ body: () throws -> Result
) rethrows -> Result {
  try body()
}

@discardableResult
public func withTransaction<Result>(
  _ transaction: Transaction, _ body: () throws -> Result
) rethrows -> Result {
  try body()
}
