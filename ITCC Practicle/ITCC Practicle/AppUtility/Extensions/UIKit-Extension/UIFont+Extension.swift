//
//  GExtension+UIFont.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 22/09/20.
//  Copyright © 2020 KISHAN_RAJA. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontType: String {
        case thin                    = "Roboto-Thin"
        case thinItalic              = "Roboto-ThinItalic"
        case italic                  = "Roboto-Italic"
        case regular                 = "Roboto-Regular"
        case light                   = "Roboto-Light"
        case lightItalic             = "Roboto-LightItalic"
        case medium                  = "Roboto-Medium"
        case mediumItalic            = "Roboto-MediumItalic"
        case bold                    = "Roboto-Bold"
        case boldItalic              = "Roboto-BoldItalic"
        case black                   = "Roboto-Black"
        case blackItalic             = "Roboto-BlackItalic"
    }
    
    /// Set custom font
    /// - Parameters:
    ///   - type: Font type.
    ///   - size: Size of font.
    ///   - isRatio: Whether set font size ratio or not. Default true.
    /// - Returns: Return font.
    class func customFont(ofType type: FontType, withSize size: CGFloat, enableAspectRatio isRatio: Bool = true) -> UIFont {
        return UIFont(name: type.rawValue, size: isRatio ? size * ScreenSize.fontAspectRatio : size) ?? UIFont.systemFont(ofSize: size)
    }
}

