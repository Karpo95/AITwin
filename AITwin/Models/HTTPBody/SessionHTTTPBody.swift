//
//  SessionHTTTPBody.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct SessionHTTTPBody: BodyEncodable {
    let title: String
    let category: SessionCategory
}
