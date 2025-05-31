//
//  MessageHTTPBody.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import Foundation

struct MessageHTTPBody: BodyEncodable {
    let text: String
    let sender: Message.Sender
}

