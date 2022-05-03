import UIKit

public enum InteractiveTextFieldStyle {
    case normal
    case material
}

public typealias ValidationRule = (message: String?, regularExpression: String, isBlock: Bool)

public struct InteractiveTextFieldConfig {
    
    internal var text: String?
    
    public var enableBorder: Bool = true
    public var enablePlaceholder: Bool = true
    public var enableInline: Bool = true
    public var enableInlineBorderColor: Bool = true
    public var placeholderStickTop: Bool = false // Applied only material style
    
    public var leadingIconSize: CGSize?

    public var placeholderFontSize: CGFloat = 12
    
    public var cornerRadius: CGFloat = 6
    public var normalBorderWidth: CGFloat = 1
    public var activeBorderWidth: CGFloat = 2
    
    public var prefixStringColor: UIColor = .darkGray
    public var suffixStringColor: UIColor = .darkGray
    public var textColor: UIColor = .black
    public var normalBorderColor: UIColor = .darkGray
    public var activeBorderColor: UIColor = .blue
    public var inlinedBorderColor: UIColor = .red
    public var placeholderColor: UIColor = .systemGray
    
    public var textRectMinY: CGFloat = 9
    public var textRectMinX: CGFloat = 12
    public var textRect: CGRect = .zero
    public var textRectLeftMargin: CGFloat = 0
    
    public init() {}
    
}
