//
//  CategoryCollectionItem.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct FlexibleWrapGridItemView<Item: FlexibleWrapGridItemProtocol>: View {
    //MARK: - Properties
    
    let item: Item
    let isSelected: Bool
    let font: Font
    let hPadding: CGFloat
    
    //MARK: - Body
    
    var body: some View {
        Text(item.gridItemText)
            .font(font)
            .foregroundStyle(isSelected ? .white : .textMain)
            .padding(.vertical, 10)
            .padding(.horizontal, hPadding)
            .background(
                RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                    .foregroundStyle(isSelected ? Color(.secondary) : .white)
                    .shadow(radius: 1.5)
            )
            .animation(.default, value: isSelected)
    }
}

