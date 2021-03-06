//
//  MessageInteractor.swift
//  TelegramClone
//
//  Created by talgar osmonov on 17/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit



protocol MessageInteractorProtocol {
    func sendMessage(chatId: String, text: String, membersId: [String])
    func fetchMessages(chatId: String)
    func createMessage(message: RealmMessage) -> MKMessage?
    func getForOldChats(documentId: String, collectionId: String)
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date)
}

protocol MessageInteractorOutput: AnyObject {
    func fetchMessageResult(result: ResultRealmMessages)
    func sendMessageRealmResult(realmResult: ResultEnum)
    func sendMessageFirestoreResult(firestoreResult: ResultEnum)
    func getForOldChatsResult(result: ResultEnum)
    func listenForNewChatsResult(result: ResultEnum)
}

final class MessageInteractor {
    private let dataProvider: MessageDataProviderProtocol = MessageDataProvider()
    weak var output: MessageInteractorOutput?

}


// MARK: - MessageInteractorProtocol

extension MessageInteractor: MessageInteractorProtocol {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date) {
        dataProvider.listenForNewChats(documentId: documentId, collectionId: collectionId, lastMessageDate: lastMessageDate) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.listenForNewChatsResult(result: .success(nil))
            case .failure(_):
                self?.output?.listenForNewChatsResult(result: .error)
            }
        }
    }
    func getForOldChats(documentId: String, collectionId: String) {
        dataProvider.getForOldChats(documentId: documentId, collectionId: collectionId) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.getForOldChatsResult(result: .success(nil))
            case .failure(_):
                self?.output?.getForOldChatsResult(result: .error)
            }
        }
    }
    func createMessage(message: RealmMessage) -> MKMessage? {
        dataProvider.createMeessage(message: message)
    }
    
    func fetchMessages(chatId: String) {
        dataProvider.fetchMessages(chatId: chatId) { [weak self] result in
            switch result {
            case .success(let data):
                self?.output?.fetchMessageResult(result: .success(data))
            case .failure(_):
                self?.output?.fetchMessageResult(result: .error)
            }
        }
    }
    
    func sendMessage(chatId: String, text: String, membersId: [String]) {
        dataProvider.sendMessage(chatId: chatId, text: text, membersId: membersId) { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.sendMessageRealmResult(realmResult: .success(nil))
            case .failure(_):
                self?.output?.sendMessageRealmResult(realmResult: .error)
            }
        } firestoreCompletion: { [weak self] result in
            switch result {
            case .success(_):
                self?.output?.sendMessageFirestoreResult(firestoreResult: .success(nil))
            case .failure(_):
                self?.output?.sendMessageFirestoreResult(firestoreResult: .error)
            }
        }

    }
}
