//
//  DatabaseFacade.swift
//  tilQuiz
//
//  Created by Roy Levi on 16/05/2018.
//  Copyright © 2018 Mador Til. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

let notifCentre = NotificationCenter.default

/// Singelton class to access the local and online databases
class DatabaseFacade {
    // MARK: - Database
    
    /// The shared instance of the DatabaseFacade class
    static let shared = DatabaseFacade()
    
    private var databaseReference: DatabaseReference!
    private let localFilesURL = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                             in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: true)
    private init() {
        databaseReference = Database.database().reference()
    }
    
    /// Fetches the most up to date Schema first from the FileManager and then from the Firebase Database
    /// Updates the Schema stored in the FileManager to the Schema from the Firebase Database
    ///
    /// - Parameter schemaName: The name of the Schema you want to fetch
    
    // MARK: - Trivia
    
    /// This clients Trivia Questions. Gets stored locally but updates from the database
    private(set) var triviaQuestions: [TriviaQuestion]? {
        get {
            guard let triviaQuestionsURL = localFilesURL?.appendingPathComponent("TriviaQuestions.json"),
                let triviaQuestionsJsonData = try? Data(contentsOf: triviaQuestionsURL),
                let triviaQuestions = try? JSONDecoder().decode([TriviaQuestion].self, from: triviaQuestionsJsonData) else { return nil }
            return triviaQuestions
        }
        set {
            guard let triviaQuestionsURL = localFilesURL?.appendingPathComponent("TriviaQuestions.json"),
                let triviaQuestionsJsonData = try? JSONEncoder().encode(newValue) else { return }
            do {
                try triviaQuestionsJsonData.write(to: triviaQuestionsURL)
                // Notify only if changes were made
                notifCentre.post(name: .DatabaseFacadeTriviaQuestions, object: self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Fetches the most up to date Trivia Questions from the Firebase Database
    /// and updates the Trivia Questions stored in the FileManager
    func fetchTriviaQuestions() {
        databaseReference.child("TriviaQuestions").observeSingleEvent(of: .value) { [weak self] dataSnapshot in
            guard let jsonFromFirebase = dataSnapshot.value as? [Any] else { return }
            var triviaQuestions: [TriviaQuestion] = []
            jsonFromFirebase.forEach { singleQuestionJsonFromFirebase in
                guard let singleQuestionJsonData = try? JSONSerialization.data(withJSONObject: singleQuestionJsonFromFirebase, options: []),
                    let singleQuestion = try? JSONDecoder().decode(TriviaQuestion.self, from: singleQuestionJsonData) else { return }
                triviaQuestions.append(singleQuestion)
            }
            if self?.triviaQuestions != triviaQuestions {
                self?.triviaQuestions = triviaQuestions
            }
        }
    }
}
