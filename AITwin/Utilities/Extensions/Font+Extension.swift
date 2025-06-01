//
//  Font+Extension.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

extension Font {
    static func appFont(_ type: AppFont, size: CGFloat = 13) -> Font {
        type.font(size: size)
    }
}
