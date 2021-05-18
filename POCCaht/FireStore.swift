//
//  FireStore.swift
//  POCChat
//
//  Created by KANJANAPORN LANKUA on 14/5/2564 BE.
//
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseDatabase
import FirebaseFirestoreSwift

struct Model: Codable {
  var chat : [Chat]
  
  init(chat: [Chat]) {
    self.chat = chat
  }
}

struct Chat: Codable {
  let sendAt: String
  let sendBy: String
  let text: String
  
  init(sendBy: String,
       text: String,
       sendAt: String) {
    self.sendBy = sendBy
    self.text = text
    self.sendAt = sendAt
  }
}

enum Type: String, Codable, Equatable {
  case ball = "ball"
  case bam = "bam"
}

class FireStore {
  static let shared = FireStore()
  enum FirestoreDatabaseError: Error {
    case fetchingDocument(String?)
    case decodingError(Error)
    case documentNotFound
  }
  
  var chats: Model?
  let time = Date.getCurrentDate()
  public func subscribe(completion: @escaping((Result<Model, Error>) -> Void)) {
    Firestore.firestore().collection("collection_chat").addSnapshotListener { (querySnapshot, error) in
      do {
        let chat = try self.handleSnapshot(querySnapshot: querySnapshot)
        self.chats = chat.first
        completion(.success(self.chats ?? Model(chat: [Chat(sendBy: "ball", text: "", sendAt: self.time)])))
      } catch {
        #if DEBUG
        print("========Fire Store Error=======")
        print(error)
        print("================")
        #endif
        completion(Result.failure(error))
      }
    }
  }
  
  func sendMessage(text: String,
                   completion: @escaping((Result<Model, Error>) -> Void)) {
    chats?.chat.append(Chat(sendBy: "bam", text: text, sendAt: self.time))
  
    //update field message
    let newMessage = [["sendBy" : "bam" as Any,
                       "text" : text as Any,
                       "sendAt" : Date.getCurrentDate() as Any]]
    Firestore.firestore().collection("collection_chat")
      .document("document_chat").updateData(["chat" : FieldValue.arrayUnion(newMessage)])
  }
  
  private func handleSnapshot(querySnapshot: QuerySnapshot?) throws -> [Model] {
    #if DEBUG
    print("========Fire Store Data: =======")
    #endif
    guard let documents = querySnapshot?.documents else {
      throw FirestoreDatabaseError.fetchingDocument(nil)
    }
    #if DEBUG
    documents.forEach { (queryDocumentSnapshot) in
      print(queryDocumentSnapshot.data())
    }
    print("================")
    #endif
    let chats = try documents.compactMap { try $0.data(as: Model.self) }
    return chats
  }
}

extension Date {
  static func getCurrentDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return dateFormatter.string(from: Date())
  }
}
