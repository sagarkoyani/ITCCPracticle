//
//  UILabel + Exensions.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

// MARK: - Set Dynamic Font -

extension UILabel {
    
    // MARK: Life Cycle Methods
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }
        
        if let textValue = self.text {
            //print("NSLocalizedString UILabel :::::::::::::::: \(textValue)")
            self.text = textValue
        }
    }
    
    func setAttributedString(_ arrStr : [String] , attributes : [[NSAttributedString.Key : Any]]) {
        let str = self.text!
        
        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: self.font as Any])
        
        for index in 0...arrStr.count - 1 {
            
            let attr = attributes[index]
            attributedString.addAttributes(attr, range: (str as NSString).range(of: arrStr[index]))
        }
        
        self.attributedText = attributedString
    }
    
    func addImage(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString(string: " " + text, attributes: [.font: self.font ?? UIFont.systemFont(ofSize: 10)])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }
}



extension UILabel {
    /**
     Add Line Spacing
     - Parameter spacing: Add space between lines. Default 3
     */
    func addLineSpacing(_ spacing: CGFloat = 3) {
        
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = spacing
            //            paragraphStyle.alignment = alignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            attributedText = attributedString
        }
    }
    
    /**
     Add character Spacing
     - Parameter kernValue: Add space between characters. Default 1.15
     */
    func addCharacterSpacing(_ kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
