//
//  File.swift
//  
//
//  Created by Sengthai Te on 13/5/22.
//

public protocol InteractiveTextFieldWithInlineDelegate: AnyObject {
    func didTapRightView(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField)
    func didTapTextFieldMask(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField)
    func textDidChange(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField)
    func textFieldDidBeginEditing(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField)
    func textFieldDidEndEditing(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField)
}

public extension InteractiveTextFieldWithInlineDelegate {
    func didTapRightView(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField) {}
    func didTapTextFieldMask(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField) {}
    func textDidChange(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField) {}
    func textFieldDidBeginEditing(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField) {}
    func textFieldDidEndEditing(_ wrap: InteractiveTextFieldWithInline, textField: InteractiveTextField) {}
}
