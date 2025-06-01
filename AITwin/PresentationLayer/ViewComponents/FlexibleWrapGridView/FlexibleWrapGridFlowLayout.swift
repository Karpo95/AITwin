//
//  CategoriesFlowLayout.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct FlexibleWrapGridFlowLayout<Item: FlexibleWrapGridItemProtocol>: View {
    //MARK: - Properties
    
    let items: [Item]
    @Binding var selectedItem: Item?
    private let fontName: AppFont = .semiBold
    private let fontSize: CGFloat = 16
    private let insidePadding: CGFloat = 13
    private let hPadding: CGFloat  = 8
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            LazyVStack(alignment: .leading, spacing: 8) {
                let rows = computeRows(in: geometry.size.width)
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: hPadding) {
                        ForEach(row, id: \.self) { item in
                            FlexibleWrapGridItemView(
                                item: item,
                                isSelected: selectedItem == item,
                                font: fontName.font(size: fontSize),
                                hPadding: insidePadding
                            )
                            .onTapGesture {
                                selectedItem = item
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func computeRows(in availableWidth: CGFloat) -> [[Item]] {
        var rows: [[Item]] = []
        var currentRow: [Item] = []
        var currentWidth: CGFloat = 0
        for item in items {
            let itemWidth = item.gridItemText.widthOfString(usingFont: UIFont(name: fontName.rawValue, size: fontSize) ?? .systemFont(ofSize: fontSize)) + insidePadding * 2 + hPadding
            
            if currentWidth + itemWidth > availableWidth {
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = itemWidth
            } else {
                currentRow.append(item)
                currentWidth += itemWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
}
