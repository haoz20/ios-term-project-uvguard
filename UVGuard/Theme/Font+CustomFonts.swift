//
//  Font+CustomFonts.swift
//  UVGuard
//
//  Custom Montserrat font extensions using .custom()
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Font Extension
extension Font {
    
    // MARK: - Direct Font Access with .custom()
    
    /// Montserrat Regular font
    static func montserrat(_ size: CGFloat) -> Font {
        return .custom("Montserrat-Regular", size: size)
    }
    
    /// Montserrat Medium font
    static func montserratMedium(_ size: CGFloat) -> Font {
        return .custom("Montserrat-Medium", size: size)
    }
    
    /// Montserrat SemiBold font
    static func montserratSemiBold(_ size: CGFloat) -> Font {
        return .custom("Montserrat-SemiBold", size: size)
    }
    
    /// Montserrat Bold font
    static func montserratBold(_ size: CGFloat) -> Font {
        return .custom("Montserrat-Bold", size: size)
    }
    
    // MARK: - Semantic Font Styles
    // These match iOS system font hierarchy for easy replacement
    
    /// Large title style - 34pt Bold
    static var uvLargeTitle: Font {
        .custom("Montserrat-Bold", size: 34)
    }
    
    /// Title style - 28pt Bold
    static var uvTitle: Font {
        .custom("Montserrat-Bold", size: 28)
    }
    
    /// Title 2 style - 22pt Bold
    static var uvTitle2: Font {
        .custom("Montserrat-Bold", size: 22)
    }
    
    /// Title 3 style - 20pt SemiBold
    static var uvTitle3: Font {
        .custom("Montserrat-SemiBold", size: 20)
    }
    
    /// Headline style - 17pt SemiBold
    static var uvHeadline: Font {
        .custom("Montserrat-SemiBold", size: 17)
    }
    
    /// Body style - 17pt Regular
    static var uvBody: Font {
        .custom("Montserrat-Regular", size: 17)
    }
    
    /// Callout style - 16pt Regular
    static var uvCallout: Font {
        .custom("Montserrat-Regular", size: 16)
    }
    
    /// Subheadline style - 15pt Regular
    static var uvSubheadline: Font {
        .custom("Montserrat-Regular", size: 15)
    }
    
    /// Footnote style - 13pt Regular
    static var uvFootnote: Font {
        .custom("Montserrat-Regular", size: 13)
    }
    
    /// Caption style - 12pt Regular
    static var uvCaption: Font {
        .custom("Montserrat-Regular", size: 12)
    }
    
    /// Caption 2 style - 11pt Regular
    static var uvCaption2: Font {
        .custom("Montserrat-Regular", size: 11)
    }
    
    // MARK: - Special UV App Fonts
    
    /// Large UV index number - 48pt Bold
    static var uvIndexNumber: Font {
        .custom("Montserrat-Bold", size: 48)
    }
    
    /// Extra large UV index - 72pt Bold
    static var uvIndexLarge: Font {
        .custom("Montserrat-Bold", size: 72)
    }
    
    /// Medium UV number - 56pt Regular (thin alternative)
    static var uvIndexMedium: Font {
        .custom("Montserrat-Regular", size: 56)
    }
}

// MARK: - UIFont Extension for UIKit components
extension UIFont {
    
    /// Montserrat Regular font for UIKit
    static func montserrat(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    /// Montserrat Medium font for UIKit
    static func montserratMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }
    
    /// Montserrat SemiBold font for UIKit
    static func montserratSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }
    
    /// Montserrat Bold font for UIKit
    static func montserratBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size) ?? .boldSystemFont(ofSize: size)
    }
}
