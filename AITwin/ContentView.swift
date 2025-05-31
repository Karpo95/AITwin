//
//  ContentView.swift
//  AITwin
//
//  Created by Karpenko Bohdan on 31.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    private let networManager: NetworkService = NetworkService()
    @State var session: Session?
    @State var sessions: [Session] = []
    @State var messages: [Message] = []
    @State var message: Message?

    var body: some View {
        Text("Hello \(messages)")
            .font(.appFont(.regular))
            .task {
                do {
                    sessions = try await networManager.sessions()
                    messages = try await networManager.messages(sessionId: sessions.first!.id)
                } catch let error as NetworkError {
                    print(error)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .mainBg()
//            .loading(isLoading: true)
    }
}
