//
//  ChatBubble.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct ChatBubble: Shape {
    //MARK: - Properties
    
    private let tailWidth: CGFloat = 12
    private let cornerRadius: CGFloat = 12
    
    //MARK: - Path
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bubbleRect = CGRect(
            x: tailWidth,
            y: 0,
            width: rect.width - tailWidth,
            height: rect.height
        )
        path.addRoundedRect(
            in: bubbleRect,
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
        )
   
        let midY = rect.midY
        let tailTop = CGPoint(x: tailWidth, y: midY - 8)
        let tailPoint = CGPoint(x: 0, y: midY)
        let tailBottom = CGPoint(x: tailWidth, y: midY + 8)
        
        path.move(to: tailTop)
        path.addLine(to: tailPoint)
        path.addLine(to: tailBottom)
        path.closeSubpath()
        
        return path
    }
}
