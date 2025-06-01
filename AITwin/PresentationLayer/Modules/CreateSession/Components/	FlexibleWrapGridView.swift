//
//  CategoriesCollection.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

protocol FlexibleWrapGridItemProtocol: Identifiable, Hashable {
    var gridItemText: String { get }
}

struct FlexibleWrapGridView<Item: FlexibleWrapGridItemProtocol>: View {
    let items: [Item]
    
    var body: some View {
        ScrollView {
            FlexibleWrapGridFlowLayout(items: items)
                .padding(15)
        }
    }
}

#Preview {
    FlexibleWrapGridView(items: SessionCategory.allCases)
        .mainBg()
}
