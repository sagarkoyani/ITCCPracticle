//
//  GExtension+String.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension String {
    enum ValidationType: String {
        case alphabet = "[A-Za-z]+"
        case alphabetWithSpace = "[A-Za-z ]*"
        case alphabetNum = "[A-Za-z-0-9]*"
        case alphabetNumWithSpace = "[A-Za-z0-9 ]*"
        case userName = "[A-Za-z0-9 _]*"
        case name = "^[A-Z a-z]*$"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case number = "[0-9]+"
        case password = "^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$"
        case mobileNumber = "^[0-9]{8,11}$"
        case postalCode = "^[A-Za-z0-9- ]{1,10}$"
        case zipcode = "^[A-Za-z0-9]{4,}$"
        case currency = "^([0-9]+)(\\.([0-9]{0,2})?)?$"
        case amount = "^\\s*(?=.*[1-9])\\d*(?:\\.\\d{1,2})?\\s*$"
        case website = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    }
    
    func isValid(_ type: ValidationType) -> Bool {
        guard !isEmpty else { return false }
        let regTest = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return regTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func url() -> URL {
        guard let url = URL(string: self) else {
            return URL(string : "www.google.co.in")!
        }
        return url
    }
    
    func isBackspace() -> Bool {
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        return false
    }
    
    func last(index: Int) -> String? {
        guard count > index else { return nil }
        return self.reversed()[index].description
    }
    
    func getAttributedText ( defaultDic : [NSAttributedString.Key : Any] , attributeDic : [NSAttributedString.Key : Any]?, attributedStrings : [String]) -> NSMutableAttributedString {
        
        let attributeText : NSMutableAttributedString = NSMutableAttributedString(string: self, attributes: defaultDic)
        for strRange in attributedStrings {
            if let range = self.range(of: strRange) {
                let startIndex = self.distance(from: self.startIndex, to: range.lowerBound)
                let range1 = NSMakeRange(startIndex, strRange.count)
                attributeText.setAttributes(attributeDic, range: range1)
            }
        }
        return attributeText
    }
    
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1)).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        })
    }
    
    func unescapeString() -> String {
        return self.replacingOccurrences(of: "\\", with: "", options: String.CompareOptions.literal, range: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func sizeOfString (font : UIFont) -> CGSize {
        return self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedString.Key.font: font],
                                 context: nil).size
    }
    
    func getFormatedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let number =  Double(self) {
            if let strNumber = formatter.string(from: NSNumber(value: number)) {
                return strNumber
            }
        }
        return self
    }
    
    func getDateForSharingLimitation() -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateTimeFormater.UTCFormat.rawValue
        return dateFormater.date(from: self) ?? Date()
    }
    
    func localized(_ value : CVarArg...) -> String{
        let t = StringResourceUtility.Localizer()
        return withVaList(value) { t(self, $0) }
    }
    
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /**
     To Get UIAlertAction from String
     
     - Parameter style: UIAlertAction Style
     - Parameter handler: To Handle events
     
     */
    func addAction(style : UIAlertAction.Style  = .default , handler : AlertActionHandlerd? = nil) -> UIAlertAction{
        return UIAlertAction(title: self, style: style, handler: handler)
    }
    
    /**
     To get attributed underline text
     
     - Returns: attributed underline text
     */
    func addUnderline() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}

typealias AlertActionHandlerd = ((UIAlertAction) -> Void)

class StringResourceUtility {
    static func Localizer() -> (_ key: String, _ params: CVaListPointer) -> String {
        return { (key: String, params: CVaListPointer) in
            let content = NSLocalizedString(key, tableName: nil, bundle: Bundle.main.getBundleName(), value: "", comment: "")
            return NSString(format: content, arguments: params) as String
        }
    }
}

extension String {
    func numberToLocale(localeIdentifier: String = "EN") -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        guard let resultNumber = numberFormatter.number(from: self) else{
            return self
        }
        return resultNumber.stringValue
    }
}

// -----------------------------------------------------------------------------------------------------------------------------

// MARK: - Width Of String -

extension String {
    func heightForText(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension String {
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

extension String {
    var digits: String {
        return String(filter(("0"..."9").contains))
    }
    
//    func applyPatternOnNumbers(pattern: String = kPhonePattern, replacmentCharacter: Character = kPhonePatternReplaceChar) -> String {
//        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
//        for index in 0 ..< pattern.count {
//            guard index < pureNumber.count else { return pureNumber }
//            let stringIndex = String.Index(utf16Offset: index, in: self)
//            let patternCharacter = pattern[stringIndex]
//            guard patternCharacter != replacmentCharacter else { continue }
//            pureNumber.insert(patternCharacter, at: stringIndex)
//        }
//        return pureNumber
//    }
}

extension String {
    /**
     Get attributed string from html string
     */
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    /**
     Get string from html string
     */
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension String {
    
    /// To get array from HTML text and separate by <li> tag.
    var htmlToStringArray: [String] {
        self.components(separatedBy: "<li>").map({$0.withoutHtmlTags.trim()}).filter({!$0.isEmpty})
        
    }
    
    /// To get pure string remove all HTML text from string
    var withoutHtmlTags: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with: " ", options:.regularExpression, range: nil)
    }
}
