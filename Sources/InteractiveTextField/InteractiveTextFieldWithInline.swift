import UIKit

open class InteractiveTextFieldWithInline: UIStackView {
    
    public var delegate: InteractiveTextFieldWithInlineDelegate?
    
    public var inlineView: InteractiveInline {
        inlineLabel
    }
    
    public var textFieldHeight: CGFloat = 54 {
        didSet {
            layoutIfNeeded()
        }
    }
    
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
            inlineLabel.icon = inlineLabelIcon
        }
    }
    
    public var inlineLabelTextColor: UIColor? {
        didSet {
            inlineLabel.textColor = inlineLabelTextColor
        }
    }
    
    public var inlineVerticalSpacing: CGFloat = 8
    
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
    
    public var validationMessage: String? {
        didSet {
            updateInlineMessageVisibility()
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
        var frame = frame
        if frame.height == 0 {
            frame.size.height = textFieldHeight
        }
        textField = InteractiveTextField(frame: frame, config: config)
        super.init(frame: frame)
        commitUI()
    }
    
    required public init(coder: NSCoder) {
        textField = InteractiveTextField()
        super.init(coder: coder)
        if let height = heightConstraint?.constant {
            textFieldHeight = height
        }
        heightConstraint?.priority = UILayoutPriority(250)
        commitUI()
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
}

extension InteractiveTextFieldWithInline {
    
    private var isInlineNilOrEmpty: Bool {
        validationMessage?.isEmpty ?? true
    }
    
    private func updateInlineMessageVisibility() {
        let isNilOrEmpty = isInlineNilOrEmpty
        
        inlineLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0)
        inlineLabel.font = inlineFont
        inlineLabel.numberOfLines = 0
        inlineLabel.text = validationMessage
        inlineLabel.icon = isNilOrEmpty ? nil : inlineLabelIcon
        spacing = isNilOrEmpty ? 0 : inlineVerticalSpacing
        
        inlineLabel.isHidden = isNilOrEmpty
        let inlineHeight = isNilOrEmpty ? 0 : inlineLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let updatedHeight = textFieldHeight + spacing + inlineHeight
        frame.size.height = updatedHeight
    }
    
    private func commitUI() {
        axis = .vertical
        
        addArrangedSubview(textField)
        addArrangedSubview(inlineLabel)
        
        inlineLabel.isHidden = isInlineNilOrEmpty
        
        inlineLabel.font = inlineFont
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
    
    var heightConstraint: NSLayoutConstraint? {
        constraints.filter { $0.firstAttribute == .height }.first
    }
    
}
