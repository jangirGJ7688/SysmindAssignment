//
//  ChatViewModel.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 03/05/25.
//

import Foundation
import Combine


class ChatViewModel {
    @Published var messages: [Message] = []
    @Published var pinnedMessages: [Message] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchMessages()
    }

    func fetchMessages() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .print("Debugging")
            .map(\.data)
            .decode(type: [APIMessage].self, decoder: JSONDecoder())
            .map { $0.prefix(30).map { Message(id: $0.id, title: $0.name, sender: $0.email, content: $0.body) } }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.messages = $0 }
            .store(in: &cancellables)
    }

    func togglePin(for message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages[index].isPinned.toggle()
        pinnedMessages = messages.filter { $0.isPinned }
    }
}
