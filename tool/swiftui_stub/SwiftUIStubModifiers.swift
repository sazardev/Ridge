// Part 3: the `View` modifier surface. Every method returns an opaque
// `some View`, exactly as the real ones do, so a chained call is typechecked
// the way Xcode would check it.

public struct ModifiedContent<Content, Modifier> {
  public typealias Body = Never
  public var content: Content
  public var modifier: Modifier
  public func body() -> some View { EmptyView() }
}

extension ModifiedContent: View where Content: View, Modifier: View {}

public struct TextAlign: Hashable {
  public static let leading = TextAlign()
  public static let center = TextAlign()
  public static let trailing = TextAlign()
  public static let justified = TextAlign()
}

public struct Axis: Hashable {
  public struct Set: OptionSet, Hashable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let horizontal = Set(rawValue: 1)
    public static let vertical = Set(rawValue: 2)
  }
  public static let horizontal = Axis()
  public static let vertical = Axis()
}

public struct EdgeInsetsSet: OptionSet, Hashable {
  public let rawValue: Int
  public init(rawValue: Int) { self.rawValue = rawValue }
  public static let top = EdgeInsetsSet(rawValue: 1)
  public static let leading = EdgeInsetsSet(rawValue: 2)
  public static let bottom = EdgeInsetsSet(rawValue: 4)
  public static let trailing = EdgeInsetsSet(rawValue: 8)
  public static let all = EdgeInsetsSet(rawValue: 15)
  public static let horizontal = EdgeInsetsSet(rawValue: 10)
  public static let vertical = EdgeInsetsSet(rawValue: 5)
}

public struct Bundle {
  public static let main = Bundle()
}

public struct URL {
  public init(string: String) {}
}

public struct AnyTransition {
  public static let opacity = AnyTransition()
  public static let scale = AnyTransition()
  public static let move = AnyTransition()
  public static var combined: AnyTransition { AnyTransition() }
}

public struct PreviewLayout {
  public static let sizeThatFits = PreviewLayout()
  public static let fixed = PreviewLayout()
}

public protocol PreviewProvider {
  associatedtype PreviewViewType: View
  static var previews: PreviewViewType { get }
}

public protocol PreviewMacro: View {}

// MARK: - Layout and appearance modifiers

public extension View {
  func font(_ font: Font) -> some View {
    ModifiedContent(content: self, modifier: FontModifier(font))
  }
  func fontWeight(_ weight: Font.Weight) -> some View {
    ModifiedContent(content: self, modifier: FontModifier(.body))
  }
  func bold() -> some View {
    ModifiedContent(content: self, modifier: FontModifier(.body))
  }
  func italic() -> some View {
    ModifiedContent(content: self, modifier: FontModifier(.body))
  }
  func monospacedDigit() -> some View {
    ModifiedContent(content: self, modifier: FontModifier(.body))
  }
  func foregroundColor(_ color: Color) -> some View {
    ModifiedContent(content: self, modifier: ForegroundModifier(color))
  }
  func foregroundStyle(_ color: Color) -> some View {
    ModifiedContent(content: self, modifier: ForegroundModifier(color))
  }
  func tint(_ color: Color) -> some View {
    ModifiedContent(content: self, modifier: ForegroundModifier(color))
  }
  func opacity(_ opacity: Double) -> some View {
    ModifiedContent(content: self, modifier: ForegroundModifier(.clear))
  }
  func padding(_ length: CGFloat) -> some View {
    ModifiedContent(content: self, modifier: PaddingModifier(EdgeInsets.all(length)))
  }
  func padding() -> some View {
    ModifiedContent(content: self, modifier: PaddingModifier(.zero))
  }
  func padding(_ insets: EdgeInsets) -> some View {
    ModifiedContent(content: self, modifier: PaddingModifier(insets))
  }
  func padding(_ edges: EdgeInsetsSet, _ length: CGFloat) -> some View {
    ModifiedContent(content: self, modifier: PaddingModifier(.zero))
  }
  func frame(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) -> some View {
    ModifiedContent(content: self, modifier: FrameModifier())
  }
  func frame(
    minWidth: CGFloat? = nil,
    idealWidth: CGFloat? = nil,
    maxWidth: CGFloat? = nil,
    minHeight: CGFloat? = nil,
    idealHeight: CGFloat? = nil,
    maxHeight: CGFloat? = nil,
    alignment: Alignment = .center
  ) -> some View {
    ModifiedContent(content: self, modifier: FrameModifier())
  }
  func frame(maxWidth: CGFloat, alignment: Alignment = .center) -> some View {
    ModifiedContent(content: self, modifier: FrameModifier())
  }
  func frame(maxHeight: CGFloat, alignment: Alignment = .center) -> some View {
    ModifiedContent(content: self, modifier: FrameModifier())
  }
  func containerRelativeFrame(
    _ axes: Axis.Set, alignment: Alignment = .center
  ) -> some View {
    ModifiedContent(content: self, modifier: FrameModifier())
  }
  func background(_ color: Color) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func background<S: View>(_ view: S) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func background<S: View>(_ view: S, alignment: Alignment = .center) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func clipShape<S: Shape>(_ shape: S) -> some View {
    ModifiedContent(content: self, modifier: ClipModifier())
  }
  func clipped() -> some View {
    ModifiedContent(content: self, modifier: ClipModifier())
  }
  func mask<S: Shape>(_ shape: S) -> some View {
    ModifiedContent(content: self, modifier: ClipModifier())
  }
  func overlay<S: View>(_ overlay: S) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func overlay<S: View>(_ overlay: S, alignment: Alignment = .center) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func buttonStyle<S: PrimitiveButtonStyle>(_ style: S) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func borderedProminentButtonStyle() -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func plainButtonStyle() -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func borderlessButtonStyle() -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func keyboardType(_ type: UIKeyboardType) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func textInputAutocapitalization(_ autocapitalization: TextInputAutocapitalization?) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func textFieldStyle(_ style: RoundedBorderTextFieldStyle) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func lineLimit(_ number: Int?) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func minimumScaleFactor(_ factor: CGFloat) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func multilineTextAlignment(_ alignment: TextAlign) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func truncationMode(_ mode: Text.TruncationMode) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func scaleEffect(_ scale: CGFloat) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func scaleEffect(_ scale: CGFloat, anchor: UnitPoint) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func offset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func disabled(_ disabled: Bool) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func environmentObject<T: ObservableObject>(_ object: T) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func environment<T>(
    _ keyPath: WritableKeyPath<EnvironmentValues, T>, _ value: T
  ) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func dynamicTypeSize(_ size: DynamicTypeSize...) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func hidden() -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func zIndex(_ index: CGFloat) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func tag<V: Hashable>(_ tag: V) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func id<ID: Hashable>(_ id: ID) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func transition(_ transition: AnyTransition) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func animation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func animation(_ animation: Animation? = nil) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func transaction(_ transform: (inout Transaction) -> Void) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }

  // MARK: Side effects

  func onAppear(perform action: (() -> Void)? = nil) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func onDisappear(perform action: (() -> Void)? = nil) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func onChange<V: Equatable>(
    of value: V, perform action: @escaping (V) -> Void
  ) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func onChange<V: Equatable>(
    of value: V, initial: Bool = true, _ action: @escaping (V, V) -> Void
  ) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func onTapGesture(
    count: Int = 1, perform action: @escaping () -> Void
  ) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func task(priority: TaskPriority = .userInitiated, _ action: @escaping () async -> Void) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }

  // MARK: Accessibility

  func accessibilityLabel(_ label: String) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityHint(_ hint: String) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityValue(_ value: String) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityIdentifier(_ identifier: String) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityAddTraits(_ traits: AccessibilityTraits) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityElement(children: AccessibilityChildBehavior = .ignore) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityChildren(_ children: AccessibilityChildBehavior) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityHidden(_ hidden: Bool) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
  func accessibilityFocused(_ focused: Bool) -> some View {
    ModifiedContent(content: self, modifier: BackgroundModifier())
  }
}

public struct TextInputAutocapitalization {
  public static let never = TextInputAutocapitalization()
  public static let sentences = TextInputAutocapitalization()
  public static let words = TextInputAutocapitalization()
  public static let characters = TextInputAutocapitalization()
}

public struct AccessibilityChildBehavior {
  public static let ignore = AccessibilityChildBehavior()
  public static let combine = AccessibilityChildBehavior()
  public static let contain = AccessibilityChildBehavior()
  public static let hidden = AccessibilityChildBehavior()
}

public struct DynamicTypeSize: Comparable {
  public let name: String
  public init(_ name: String) { self.name = name }
  public static func < (lhs: DynamicTypeSize, rhs: DynamicTypeSize) -> Bool {
    false
  }
  public static let xSmall = DynamicTypeSize("xSmall")
  public static let small = DynamicTypeSize("small")
  public static let medium = DynamicTypeSize("medium")
  public static let large = DynamicTypeSize("large")
  public static let xLarge = DynamicTypeSize("xLarge")
  public static let xxLarge = DynamicTypeSize("xxLarge")
  public static let xxxLarge = DynamicTypeSize("xxxLarge")
  public static let accessibility1 = DynamicTypeSize("accessibility1")
  public static let accessibility5 = DynamicTypeSize("accessibility5")
}

public struct TaskPriority {
  public static let userInitiated = TaskPriority()
  public static let background = TaskPriority()
}

// MARK: - Modifier payloads (exist only so the opaque types are concrete)

public struct FontModifier: View {
  public typealias Body = Never
  let font: Font
  public init(_ font: Font) { self.font = font }
}

public struct ForegroundModifier: View {
  public typealias Body = Never
  let color: Color
  public init(_ color: Color) { self.color = color }
}

public struct PaddingModifier: View {
  public typealias Body = Never
  let insets: EdgeInsets
  public init(_ insets: EdgeInsets) { self.insets = insets }
}

public struct FrameModifier: View {
  public typealias Body = Never
  public init() {}
}

public struct BackgroundModifier: View {
  public typealias Body = Never
  public init() {}
}

public struct ClipModifier: View {
  public typealias Body = Never
  public init() {}
}
