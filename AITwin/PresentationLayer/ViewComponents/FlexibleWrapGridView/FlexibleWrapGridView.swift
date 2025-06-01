//
//  FlexibleWrapGridView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

protocol FlexibleWrapGridItemProtocol: Identifiable, Hashable {
    var gridItemText: String { get }
}

struct FlexibleWrapGridView<Item: FlexibleWrapGridItemProtocol>: View {
    //MARK: - Properties
    let items: [Item]
    @Binding var selectedItem: Item?
    
    //MARK: - Body
    var body: some View {
        ScrollView {
            FlexibleWrapGridFlowLayout(items: items, selectedItem: $selectedItem)
                .padding(15)
        }
    }
}
