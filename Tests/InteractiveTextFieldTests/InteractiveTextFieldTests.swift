import XCTest
@testable import InteractiveTextField

final class InteractiveTextFieldTests: XCTestCase {
    
    private let textField = InteractiveTextField()
    
    func testSetTextWithRegexValidation() {
        let inputs = [",", "123 456", "abc", "0", "🎂", "1 1 1 1"]
        let expectedResult: [String?] = ["", "123456", "", "0", "", "1111"]
        let numberForamtter = NumberFormatter()
        numberForamtter.locale = Locale(identifier: "en_US")
        numberForamtter.groupingSeparator = " "
        numberForamtter.groupingSize = 3
        textField.validationRegex = [(message: "", regularExpression: "^\\s*(?:,*[0-9]\\s*){0,6}([,.][0-9]{0,2})?$", isBlock: true)]
        textField.numberFormatter = numberForamtter
        for (i, input) in inputs.enumerated() {
            textField.text = input
            XCTAssertEqual(textField.text, expectedResult[i])
        }
    }
}
