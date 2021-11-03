//
//  TypingListenerAPI.swift
//  TelegramClone
//
//  Created by talgar osmonov on 12/7/21.
//

import Foundation
import Firebase


protocol TypingListenerAPIProtocol {
    func createTypingObserver(chatRoomId: String, completion: @escaping(_ isTyping: Bool) -> Void)
}


class TypingListenerAPI {
    static let shared: TypingListenerAPIProtocol = TypingListenerAPI()
    var typingListener: ListenerRegistration?
}

extension TypingListenerAPI: TypingListenerAPIProtocol {
    func removeTypingListener() {
        self.typingListener?.remove()
    }
    func saveTypingCounter(isTyping: Bool, chatRoomId: String) {
        typingCollection.document(chatRoomId).updateData([currentUID : isTyping])
    }
    func createTypingObserver(chatRoomId: String, completion: @escaping (Bool) -> Void) {
        typingListener = typingCollection.document(chatRoomId).addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else {return}
            if snapshot.exists {
                for data in snapshot.data()! {
                    if data.key != currentUID {
                        completion(data.value as! Bool)
                    }
                }
            } else {
                completion(false)
                typingCollection.document(chatRoomId).setData([currentUID : false])
            }
        })
    }
}
