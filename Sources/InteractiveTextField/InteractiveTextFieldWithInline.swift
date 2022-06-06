import UIKit

open class InteractiveTextFieldWithInline: UIStackView {
    
    public var delegate: InteractiveTextFieldWithInlineDelegate?
    
    fileprivate var updatedFrame: CGRect = .zero
    
    public var inlineView: InteractiveInline {
        inlineLabel
    }
    
    public var textFieldHeight: CGFloat = .zero {
        didSet {
            updatedFrame = .zero
            updatedTextFieldHeight = textFieldHeight
            layoutSubviews()
        }
    }
    
    fileprivate var updatedTextFieldHeight: CGFloat = 54
    
    public var rightView: UIView? {
        didSet {
            textField.rightView = rightView
        }
    }
    
    public var leftView: UIView? {
        didSet {
            textField.leftView = leftView
        }
    }
    
    public var textFieldClipToBound: Bool = true {
        didSet {
            textField.clipsToBounds = textFieldClipToBound
        }
    }
    
    public var inlineLabelIcon: UIImage? {
        didSet {
            guard let inlineLabelIcon = inlineLabelIcon else {
                return
            }
            inlineLabel.icon = inlineLabelIcon
            if inlineIconSize == .zero {
                inlineIconSize = inlineLabel.iconSize
            }
        }
    }
    
    public var inlineLabelTextColor: UIColor? {
        didSet {
            inlineLabel.textColor = inlineLabelTextColor
        }
    }
    
    public var inlineFontSize: CGFloat = 12
    
    public var inlineFont: UIFont? {
        didSet {
            inlineLabel.font = (inlineFont ?? font).withSize(inlineFontSize)
        }
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        DispatchQueue.main.async {
            self.textField.resignFirstResponder()
        }
        return super.resignFirstResponder()
    }
    
    public var inlineIconSize: CGSize = .zero {
        didSet {
            inlineLabel.iconSize = inlineIconSize
        }
    }
    
    public var inlineLabelIconPadding: CGFloat = 4 {
        didSet {
            inlineLabel.iconPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inlineLabelIconPadding)
        }
    }
    
    public var style: InteractiveTextFieldStyle = .normal {
        didSet {
            textField.style = style
        }
    }
    
    public var textFieldUIConfig: InteractiveTextFieldConfig? {
        didSet {
            textField.uiConfig = textFieldUIConfig
        }
    }
    
    public var showInlineBorder: Bool = false {
        didSet {
            textField.showInlineBorder = showInlineBorder
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            textField.font = font
        }
    }
    
    public var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    public var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    public var attributedText: NSAttributedString? {
        didSet {
            textField.attributedText = attributedText
        }
    }
    
    public var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    public var attributedPlaceholder: NSAttributedString? {
        didSet {
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    public var prefixString: String? {
        didSet {
            textField.prefixString = prefixString
        }
    }
    
    public var prefixBackgroundColor: UIColor? {
        didSet {
            textField.prefixBackgroundColor = prefixBackgroundColor
        }
    }
    
    public var prefixHorizontalPadding: CGFloat = 0 {
        didSet {
            textField.prefixHorizontalPadding = prefixHorizontalPadding
        }
    }
    
    public var suffixString: String? {
        didSet {
            textField.suffixString = suffixString
        }
    }
    
    public var suffixHorizontalPadding: CGFloat = 0 {
        didSet {
            textField.suffixHorizontalPadding = suffixHorizontalPadding
        }
    }
    
    public var suffixBackgroundColor: UIColor? {
        didSet {
            textField.suffixBackgroundColor = suffixBackgroundColor
        }
    }
    
    public var leadingIcon: UIImage? {
        didSet {
            textField.leadingIcon = leadingIcon
        }
    }
    
    public var trailingIcon: UIImage? {
        didSet {
            textField.trailingIcon = trailingIcon
        }
    }
    
    public var textFieldRightView: UIView? {
        textField.rightView
    }
    
    public var textFieldLeftView: UIView? {
        textField.leftView
    }
    
    public var enableTapOnTextField: Bool = false {
        didSet {
            textField.enableTapOnTextField = enableTapOnTextField
        }
    }
    
    public var autoActive: Bool = false {
        didSet {
            DispatchQueue.main.async { [self] in
                if autoActive {
                    textField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        }
    }
    
    public var inlineMessage: String? {
        didSet {
            updateInlineMessageVisibility()
        }
    }
    
    public var validationMessage: String? {
        didSet {
            updateInlineMessageVisibility()
        }
    }
    
    public var numberOfLines: Int = 0 {
        didSet {
            inlineLabel.numberOfLines = 0
        }
    }
    
    public var numberFormatter: NumberFormatter? {
        didSet {
            textField.numberFormatter = numberFormatter
        }
    }
    
    public var validationRegex = [ValidationRule]() {
        didSet {
            textField.validationRegex = validationRegex
        }
    }
    
    public var  validationEndEditingRegex = [ValidationRule]() {
        didSet {
            textField.validationEndEditingRegex = validationEndEditingRegex
        }
    }
    
    public var textFieldShouldChangeCharacter: (_ range: NSRange, _ replacementString: String)-> Bool? = {
        range,replacementString in nil
    } {
        didSet {
            textField.textFieldShouldChangeCharacter = textFieldShouldChangeCharacter
        }
    }
    
    fileprivate let inlineLabel: InteractiveInline = {
        let label = InteractiveInline()
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()
    
    fileprivate var textField: InteractiveTextField!
    
    public init(frame: CGRect = .zero, config: InteractiveTextFieldConfig? = nil) {
        textField = InteractiveTextField(frame: frame, config: config)
        updatedFrame = frame
        if frame.height > .zero {
            updatedTextFieldHeight = frame.height
        }
        super.init(frame: frame)
        commitUI()
    }
    
    required public init(coder: NSCoder) {
        textField = InteractiveTextField()
        super.init(coder: coder)
        if let heightConstraint = heightConstraint {
            if heightConstraint.constant > .zero {
                updatedTextFieldHeight = heightConstraint.constant
            }
            removeHeightConstraint()
            textField.heightAnchor.constraint(equalToConstant: updatedTextFieldHeight).isActive = true
        }
        commitUI()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        performLayoutChange()
    }
}

extension InteractiveTextFieldWithInline {
    
    fileprivate var isFrameZero: Bool {
        frame == .zero
    }
    
    fileprivate var isInlineNilOrEmpty: Bool {
        inlineMessage?.isEmpty ?? validationMessage?.isEmpty ?? true
    }
    
    fileprivate var selfHeight: CGFloat {
        isInlineNilOrEmpty ? updatedTextFieldHeight : updatedTextFieldHeight + spacing + inlineLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    fileprivate func performLayoutChange() {
        if isFrameZero { return }
        if updatedFrame.height == .zero && frame.height > .zero {
            updatedTextFieldHeight = frame.height
            textField.frame.size.height = updatedTextFieldHeight
            textField.heightConstraint?.constant = updatedTextFieldHeight
        }
        var newFrame = frame
        newFrame.size.height = selfHeight
        if updatedFrame != newFrame {
            updatedFrame = newFrame
            frame = newFrame
        } else {
            textField.frame.size.height = updatedTextFieldHeight
            textField.heightConstraint?.constant = updatedTextFieldHeight
        }
    }
    
    fileprivate func updateInlineMessageVisibility() {
        inlineLabel.text = inlineMessage ?? validationMessage
        inlineLabel.isHidden = isInlineNilOrEmpty
        if !isFrameZero { layoutIfNeeded() }
    }
    
    fileprivate func commitUI() {
        arrangedSubviews.forEach({$0.removeFromSuperview()})
        axis = .vertical
        
        addArrangedSubview(textField)
        addArrangedSubview(inlineLabel)
        
        inlineLabel.isHidden = isInlineNilOrEmpty
        inlineLabel.font = inlineFont
        inlineLabel.iconSize = inlineIconSize
        inlineLabel.numberOfLines = numberOfLines
        inlineLabel.iconPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inlineLabelIconPadding)
        
        if let icon = inlineLabelIcon {
            inlineLabel.icon = icon
        }
        
        if let inlineTextColor = inlineLabelTextColor {
            inlineLabel.textColor = inlineTextColor
        }
        
        textField.clipsToBounds = textFieldClipToBound
        textField.displayInlineMessage = { message in
            self.validationMessage = message
        }
        textField.didTapRightView = { textField in
            self.delegate?.didTapRightView(self, textField: textField)
        }
        textField.didTapTextFieldMaskView = { textField in
            self.delegate?.didTapTextFieldMask(self, textField: textField)
        }
        textField.textDidChange = { textField in
            self.delegate?.textDidChange(self, textField: textField)
        }
        textField.textDidBeginEditing = { textField in
            self.delegate?.textFieldDidBeginEditing(self, textField: textField)
        }
        textField.textDidEndEditing = { textField in
            self.delegate?.textFieldDidEndEditing(self, textField: textField)
        }
    }
    
}

fileprivate extension UIView {
    
    @discardableResult
    func removeHeightConstraint()-> [NSLayoutConstraint]? {
        guard let heightConstraints = heightConstraints else {
            return nil
        }
        removeConstraints(heightConstraints)
        return heightConstraints
    }
    
    var heightConstraints: [NSLayoutConstraint]? {
        constraints.filter { $0.firstAttribute == .height || $0.secondAttribute == .height }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        heightConstraints?.first
    }
    
}
