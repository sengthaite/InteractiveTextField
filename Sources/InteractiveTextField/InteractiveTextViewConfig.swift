import UIKit

public struct InteractiveTextViewConfig {
    
    public var normalBorderColor: UIColor = .gray
    public var activeBorderColor: UIColor = .blue
    
    public var normalBorderWidth: CGFloat = 1
    public var activeBorderWidth: CGFloat = 2
    public var cornerRadius: CGFloat = 6
    
    public var titleRectMinX: CGFloat = 12
    public var titleRectMinY: CGFloat = 8
    
    public var titleFontSize: CGFloat = 12
    
    public var leadingIconSize: CGSize = CGSize(width: 18, height: 18)
    
    public init() {}
    
}
