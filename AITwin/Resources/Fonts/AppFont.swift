//
//  AppFont.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

enum AppFont: String {
    case regular = "HelveticaNeue"
    case semiBold = "HelveticaNeue-Medium"
    case bold = "HelveticaNeue-Bold"
    
    func font(size: CGFloat = 13) -> Font {
        Font.custom(rawValue, size: size)
    }
}
