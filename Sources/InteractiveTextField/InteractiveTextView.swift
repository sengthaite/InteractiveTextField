import UIKit

open class InteractiveTextView: UITextView {
    
    open var uiConfig: InteractiveTextViewConfig!
    
    open var title: UILabel?
    
    open var isActive: Bool = false {
        didSet {
            setBorder()
        }
    }
    
    open var leadingIconPadding: UIEdgeInsets = .zero {
        didSet {
            layoutUI()
        }
    }
    
    open var titleLabel: UILabel? {
        didSet {
            guard let titleLabel = titleLabel else {
                return
            }
            titleLabel.removeFromSuperview()
            addSubview(titleLabel)
            layoutUI()
        }
    }
    
    open var leadingIconView: UIImageView? {
        didSet {
            guard let leadingIconView = leadingIconView else {
                return
            }
            leadingIconView.removeFromSuperview()
            addSubview(leadingIconView)
            layoutUI()
        }
    }
    
    open override var font: UIFont? {
        didSet {
            guard let font = font else {
                return
            }
            titleLabel?.font = font.withSize(uiConfig.titleFontSize)
            super.font = font
        }
    }
    
    public init(frame: CGRect = .zero, textContainer: NSTextContainer? = nil, config: InteractiveTextViewConfig? = nil) {
        uiConfig = InteractiveTextViewConfig()
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
        commitUI()
    }
    
    public required init?(coder: NSCoder) {
        uiConfig = InteractiveTextViewConfig()
        super.init(coder: coder)
        commitUI()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutUI()
    }
    
}

extension InteractiveTextView {
    
    private func commitUI() {
        clipsToBounds = true
        setBorder()
    }
    
    private func layoutUI() {
        let inset = textContainerInset
        if let titleLabel = titleLabel {
            titleLabel.frame = CGRect(x: uiConfig.titleRectMinX, y: uiConfig.titleRectMinY, width: bounds.width - 2 * uiConfig.titleRectMinX, height: 17)
        }
        if let leadingIconView = leadingIconView {
            leadingIconView.frame = CGRect(origin: CGPoint(x: uiConfig.titleRectMinX + leadingIconPadding.left, y: (titleLabel?.frame.maxY ?? inset.top) + leadingIconPadding.top), size: uiConfig.leadingIconSize)
        }
        textContainerInset = UIEdgeInsets(top: titleLabel?.frame.maxY ?? inset.top, left: (leadingIconView?.frame.maxX ?? 0) + leadingIconPadding.right, bottom: inset.bottom, right: inset.right)
    }
    
    private func setBorder() {
        layer.cornerRadius = uiConfig.cornerRadius
        layer.borderWidth = isActive ? uiConfig.activeBorderWidth : uiConfig.normalBorderWidth
        layer.borderColor = isActive ? uiConfig.activeBorderColor.cgColor : uiConfig.normalBorderColor.cgColor
    }
    
}

extension InteractiveTextView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isActive = true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        isActive = false
    }
    
}
