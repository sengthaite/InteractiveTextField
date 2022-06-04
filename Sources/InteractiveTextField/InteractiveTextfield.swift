import UIKit

open class InteractiveTextField: UITextField {
    
    open var didTapRightView: ((_ textField: InteractiveTextField)->Void)?
    
    open var didTapTextFieldMaskView: ((_ textField: InteractiveTextField)->Void)?
    
    open var displayInlineMessage: ((String?)-> Void)?
    
    open var textDidChange: ((_ textField: InteractiveTextField)->Void)?
    
    open var textDidBeginEditing: ((_ textField: InteractiveTextField)->Void)?
    
    open var textDidEndEditing: ((_ textField: InteractiveTextField)->Void)?
    
    open var textFieldShouldChangeCharacter: (_ range: NSRange, _ replacementString: String)-> Bool? = { range,replacementString in nil }
    
    open var validationRegex = [ValidationRule]()
    
    open var validationEndEditingRegex = [ValidationRule]()
    
    open var numberFormatter: NumberFormatter?
    
    open var uiConfig: InteractiveTextFieldConfig!
    
    public var style: InteractiveTextFieldStyle = .normal {
        didSet {
            applyConfig()
        }
    }
    
    public var showInlineBorder: Bool = false {
        didSet {
            setBorder(isActive: isActive)
        }
    }
    
    public var enableTapOnTextField: Bool = false {
        didSet {
            let maskView = textFieldMaskView
            maskView.removeFromSuperview()
            guard enableTapOnTextField else {
                return
            }
            maskView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTextFieldMaskView))
            maskView.addGestureRecognizer(tapGesture)
            addSubview(maskView)
        }
    }
    
    internal var editingStyleMaterial: Bool {
        switch style {
        case .normal:
            return false
        case .material:
            return isActive || !isEmpty || uiConfig.placeholderStickTop
        }
    }
    
    public override var font: UIFont? {
        didSet {
            super.font = font
            placeholderLabel.font = placeholderFont
            layoutIfNeeded()
        }
    }
    
    public override var rightView: UIView? {
        didSet {
            rightViewMode = .always
            layoutIfNeeded()
        }
    }
    
    public override var leftView: UIView? {
        didSet {
            leftViewMode = .always
            layoutIfNeeded()
        }
    }
    
    public var prefixHorizontalPadding: CGFloat = 0 {
        didSet {
            layoutUI()
        }
    }
    
    public var prefixLeadingMargin: CGFloat = 0 {
        didSet {
            layoutUI()
        }
    }
    
    public var prefixString: String? {
        didSet {
            guard let prefixString = prefixString else {
                return
            }
            let label = UILabel()
            label.textColor = uiConfig.prefixStringColor
            label.font = font
            label.text = prefixString
            label.textAlignment = .center
            leftView = label
            leftViewMode = .always
        }
    }
    
    public var prefixBackgroundColor: UIColor? {
        didSet {
            leftView?.backgroundColor = prefixBackgroundColor
        }
    }
    
    public var suffixHorizontalPadding: CGFloat = 0 {
        didSet {
            layoutUI()
        }
    }
    
    public var suffixTrailingMargin: CGFloat = 0 {
        didSet {
            layoutUI()
        }
    }
    
    public var suffixString: String? {
        didSet {
            guard let suffixString = suffixString else {
                return
            }
            let label = UILabel()
            label.textColor = uiConfig.suffixStringColor
            label.font = font
            label.text = suffixString
            label.textAlignment = .center
            rightView = label
            rightViewMode = .always
        }
    }
    
    public var suffixBackgroundColor: UIColor? {
        didSet {
            rightView?.backgroundColor = suffixBackgroundColor
        }
    }
    
    public var leadingIcon: UIImage? {
        didSet {
            guard let leadingIcon = leadingIcon else {
                return
            }
            let imageView = UIImageView(image: leadingIcon.withRenderingMode(.alwaysOriginal))
            imageView.contentMode = .scaleAspectFit
            leftView = imageView
            leftViewMode = .always
        }
    }
    
    public var trailingIcon: UIImage? {
        didSet {
            guard let trailingIcon = trailingIcon else {
                return
            }
            let button = UIButton()
            button.contentMode = .scaleAspectFill
            button.setImage(trailingIcon.withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
            rightView = button
            rightViewMode = .always
        }
    }
    
    public override var text: String? {
        willSet {
            if text != newValue {
                showInlineBorder = false
            }
        }
        didSet {
            guard let text = text,
                  validateText(text)
            else {
                setText(nil)
                return
            }
            guard let formatter = numberFormatter else {
                setText(text)
                return
            }
            var textNumber = text
            textNumber = text.replacingOccurrences(of: formatter.groupingSeparator, with: "")
            if !validateText(textNumber) {
                return
            }
            guard let number = formatter.number(from: textNumber),
                  validateText(formatter.string(from: number))
            else {
                setText(nil)
                return
            }
            setText(formatter.string(from: number))
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            super.attributedText = attributedText
        }
    }
    
    internal var placeholderFont: UIFont? {
        switch style {
        case .normal:
            return font
        case .material:
            return editingStyleMaterial ? font?.withSize(uiConfig.placeholderFontSize) : font
        }
    }
    
    public override var placeholder: String? {
        didSet {
            guard let placeholder = placeholder,
                  uiConfig.enablePlaceholder
            else {
                placeholderLabel.isHidden = true
                return
            }
            placeholderLabel.isHidden = style == .normal ? true : false
            placeholderLabel.font = placeholderFont
            placeholderLabel.text = placeholder
            placeholderLabel.textColor = uiConfig.placeholderColor
        }
    }
    
    public override var attributedPlaceholder: NSAttributedString? {
        didSet {
            guard let attributedPlaceholder = attributedPlaceholder,
                  uiConfig.enablePlaceholder
            else {
                placeholderLabel.isHidden = true
                return
            }
            placeholderLabel.isHidden = style == .normal ? true : false
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        let enableTapOnTextField = enableTapOnTextField
        setBorder(isActive: !enableTapOnTextField)
        return enableTapOnTextField ? false : super.becomeFirstResponder()
    }
    
    @discardableResult
    open override func resignFirstResponder() -> Bool {
        setBorder(isActive: false)
        return super.resignFirstResponder()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = uiConfig.textRect
        switch style {
        case .normal:
            rect.origin.y = bounds.minY
        case .material:
            rect.origin.y = bounds.minY + uiConfig.textRectMinY
        }
        rect.size.height = bounds.height
        return rect
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = uiConfig.textRect
        switch style {
        case .normal:
            rect.origin.y = bounds.minY
        case .material:
            rect.origin.y = bounds.minY + uiConfig.textRectMinY
        }
        rect.size.height = bounds.height
        return rect
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }
    
    internal let textFieldMaskView: UIView = UIView()
    
    internal let placeholderLabel: UILabel = UILabel()
    
    open var isActive: Bool {
        isEditing || isFirstResponder
    }
    
    open var isEmpty: Bool {
        guard let text = text ?? attributedText?.string else {
            return true
        }
        return text.replacingOccurrences(of: " ", with: "").isEmpty
    }
    
    public init(frame: CGRect = .zero, config: InteractiveTextFieldConfig? = nil) {
        uiConfig = config ?? InteractiveTextFieldConfig()
        super.init(frame: frame)
        commitUI()
    }
    
    public required init?(coder: NSCoder) {
        uiConfig = InteractiveTextFieldConfig()
        super.init(coder: coder)
        commitUI()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutUI()
    }
    
    public func applyConfig() {
        setBorder(isActive: isActive)
        validateText(text)
        layoutUI()
    }
    
}

// MARK:- Fundamental functions
extension InteractiveTextField {
    
    internal func commitUI() {
        delegate = self
        addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        textColor = uiConfig.textColor
        layer.cornerRadius = uiConfig.cornerRadius
        setBorder(isActive: isActive)
        if uiConfig.enablePlaceholder {
            placeholderLabel.backgroundColor = .clear
            addSubview(placeholderLabel)
        }
    }
    
    internal func layoutUI() {
        var maskViewBound = bounds
        if let _ = trailingIcon,
           let rightButton = rightView as? UIButton {
            maskViewBound.size.width = rightButton.frame.minX
        }
        textFieldMaskView.frame = maskViewBound
        
        var leftViewMaxX: CGFloat = uiConfig.textRectMinX
        var rightViewMinX: CGFloat = bounds.width - leftViewMaxX
        let editingMarginTop: CGFloat
        switch style {
        case .normal:
            editingMarginTop = 0
        case .material:
            editingMarginTop = editingStyleMaterial ? uiConfig.textRectMinY : 0
        }
        
        if let leftView = leftView {
            if let _ = leadingIcon {
                if let iconSize = uiConfig.leadingIconSize {
                    leftView.frame = CGRect(x: uiConfig.textRectMinX, y: (bounds.height - iconSize.height) * 0.5 + editingMarginTop, width: iconSize.width, height: iconSize.height)
                } else {
                    leftView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
                }
            } else if let _ = prefixString {
                leftView.sizeToFit()
                leftView.frame = CGRect(x: prefixLeadingMargin, y: editingMarginTop, width: leftView.frame.width + prefixHorizontalPadding * 2, height: bounds.height - editingMarginTop)
            }
            leftViewMaxX = leftView.frame.maxX + uiConfig.textRectLeftMargin
            if let backgroundColor = prefixBackgroundColor {
                leftView.backgroundColor = backgroundColor
            }
        }
        
        if let rightView = rightView {
            if let _ = trailingIcon {
                rightView.frame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
            } else if let _ = suffixString {
                rightView.sizeToFit()
                let rightViewWidth: CGFloat = rightView.frame.width
                let posX: CGFloat = bounds.width - rightViewWidth - suffixTrailingMargin - suffixHorizontalPadding * 2
                rightView.frame = CGRect(x: posX, y: editingMarginTop, width: rightViewWidth + suffixHorizontalPadding * 2, height: bounds.height - editingMarginTop)
            }
            rightViewMinX = rightView.frame.minX
            if let backgroundColor = suffixBackgroundColor {
                rightView.backgroundColor = backgroundColor
            }
        }
        
        placeholderLabel.font = font
        placeholderLabel.sizeToFit()
        let placeholderHeight: CGFloat = placeholderLabel.frame.height
        var placeholderRect: CGRect = CGRect(x: leftViewMaxX, y: (bounds.height - placeholderHeight) * 0.5, width: rightViewMinX - leftViewMaxX, height: placeholderHeight)
        uiConfig.textRect = placeholderRect
        switch style {
        case .normal:
            placeholderLabel.frame = placeholderRect
        case .material:
            if editingStyleMaterial {
                placeholderRect.origin.x = uiConfig.textRectMinX
                placeholderRect.origin.y -= uiConfig.textRectMinY
            }
            placeholderLabel.font = editingStyleMaterial ? placeholderFont : font
            placeholderLabel.frame = placeholderRect
        }
    }
    
}


// MARK:- Operations
extension InteractiveTextField {
    
    @objc open func tapRightButton() {
        resignFirstResponder()
        superview?.resignFirstResponder()
        didTapRightView?(self)
    }
    
    @objc open func tapTextFieldMaskView() {
        resignFirstResponder()
        super.resignFirstResponder()
        didTapTextFieldMaskView?(self)
    }
    
    public func setBorder(isActive: Bool) {
        guard uiConfig.enableBorder else {
            layer.borderWidth = 0
            return
        }
        layer.borderWidth = isActive ? uiConfig.activeBorderWidth : uiConfig.normalBorderWidth
        layer.borderColor = showInlineBorder && uiConfig.enableInlineBorderColor ? uiConfig.inlinedBorderColor.cgColor : (isActive ? uiConfig.activeBorderColor : uiConfig.normalBorderColor).cgColor
    }
    
    private func setText(_ text: String?) {
        uiConfig.text = text
        if text != super.text {
            showInlineBorder = false
            displayInlineMessage?(nil)
            super.text = text
            textDidChange?(self)
        }
        handlePlaceholderVisibility(text)
    }
    
    private func handlePlaceholderVisibility(_ text: String? = nil) {
        let isEmpty = text == nil ? isEmpty : text?.replacingOccurrences(of: " ", with: "") == ""
        switch style {
        case .normal:
            placeholderLabel.isHidden = uiConfig.enablePlaceholder ? !isEmpty : true
        case .material:
            placeholderLabel.isHidden = false
        }
    }
    
    @discardableResult
    private func validateText(_ text: String?, validationRegex: [ValidationRule]? = nil)-> Bool {
        let text = text ?? ""
        let validationRegex = validationRegex ?? self.validationRegex
        for validation in validationRegex {
            guard let regex = try? NSRegularExpression(pattern: validation.regularExpression, options: []) else {
                break
            }
            if regex.numberOfMatches(in: text, options: [], range: NSRange(location: 0, length: text.unicodeScalars.count)) <= 0 {
                if uiConfig.enableInline && !validation.isBlock {
                    showInlineBorder = true
                    displayInlineMessage?(validation.message)
                }
                return false
            }
        }
        handlePlaceholderVisibility(text)
        return true
    }
    
    private func validateNumber(range: NSRange, replacementString string: String)-> Bool {
        let formatter = numberFormatter ?? NumberFormatter()
        guard let storedText = uiConfig.text else {
            if validateText(string) {
                setText(string)
            }
            return false
        }
        guard let range = Range(range, in: storedText) else {
            return false
        }
        var tmpText = storedText.replacingCharacters(in: range, with: string).replacingOccurrences(of: formatter.groupingSeparator, with: "")
        guard !string.isEmpty else {
            guard let number = formatter.number(from: tmpText) else {
                setText(nil)
                return false
            }
            let formattedStringNumber = formatter.string(from: number)
            if let lastChar = tmpText.last,
               String(lastChar) == formatter.decimalSeparator,
               let formattedStringNumber = formattedStringNumber {
                setText(formattedStringNumber + formatter.decimalSeparator)
                return false
            }
            setText(formattedStringNumber)
            return false
        }
        if string == Locale.current.decimalSeparator {
            tmpText = storedText.replacingCharacters(in: range, with: formatter.decimalSeparator)
            if validateText(tmpText) {
                setText(tmpText)
            }
            return false
        }
        if !validateText(tmpText) {
            return false
        }
        guard let number = formatter.number(from: tmpText),
              validateText(formatter.string(from: number))
        else {
            return false
        }
        setText(formatter.string(from: number))
        return false
    }
    
}

extension InteractiveTextField: UITextFieldDelegate {
    
    @objc open func textDidChanged() {
        handlePlaceholderVisibility(text)
        showInlineBorder = false
        displayInlineMessage?(nil)
        textDidChange?(self)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textDidBeginEditing?(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateText(text, validationRegex: validationEndEditingRegex)
        self.textDidEndEditing?(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let shouldChangeCharacter = textFieldShouldChangeCharacter(range, string) {
            return shouldChangeCharacter
        }
        if let formatter = numberFormatter {
            if let text = textField.text,
               let range = Range(range, in: text) {
                let fullText = text.replacingCharacters(in: range, with: string)
                if fullText.contains(formatter.decimalSeparator + "0") &&
                    validateText(fullText) {
                    uiConfig.text = fullText
                    return true
                }
            }
            return validateNumber(range: range, replacementString: string)
        }
        guard let text = textField.text,
              let range = Range(range, in: text)
        else {
            return true
        }
        return validateText(text.replacingCharacters(in: range, with: string))
    }
}
