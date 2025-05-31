//
//  SessionItemView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct SessionItemView: View {
    //MARK: - Properties
    
    let session: Session
    
    //MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            title
            HStack {
                category
                Spacer()
                date
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .shadow(radius: 2)
        }
    }
    
    //MARK: - Subviews
    
    private var title: some View {
        Text(session.title)
            .font(.appFont(.semiBold, size: 15))
            .foregroundStyle(.textMain)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var category: some View {
        Text(session.category.displayName)
            .font(.appFont(.regular, size: 12))
            .foregroundStyle(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                    .foregroundStyle(.accent)
            }
    }
    
    private var date: some View {
        Text(session.formattedDateString)
            .font(.appFont(.regular, size: 12))
            .foregroundStyle(.textMain)
    }
}
