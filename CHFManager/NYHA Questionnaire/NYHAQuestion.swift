//
//  NYHAQuestion.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-14.
//

import SwiftUI


class NYHAQuestions: ObservableObject {
    var id = UUID()
    @Published var questions : [String] = allQuestions
    @Published var scores : [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var isSubmitted = false
    var completed = false
    var color: Color = Color.clear
    @Published var sliderAnswer = ""
    @Published var NYHAindex = [1,2,3,4]
    @Published var currentIndex : Int = 0
    @Published var score = 0
    @Published var noData = false
    @Published var masterMonth = ""
}

let q1a = "How often do you walk up and down stairs? (8-12 steps)"

let q1b = "Do you avoid stairs because it makes you tired or short of breath?"

let q1c = "How often do you get short of breath or tired when you walk up or down a flight of stairs at a normal pace under normal conditions?"

let q1d = "How often do you get short of breath or tired when you walk up or down a flight of stairs quickly?"

let q2a = "How often do you engage in strenuous work or prolonged exertion at work or play?"
let q2b = "Do you think you would get short of breath or tired if you engaged in these activities?"

//6
let q2c = "How often do you get short of breath or tired doing strenuous work or prolonged exertion?"

let q3a = "How often do you go for walks, either outside or inside, on level ground at a normal pace under normal conditions?"

//8
let q3b = "Do you avoid walks because it will make you short of breath or tired?"

let q3c = "How often would you get short of breath or tired if you walked less than 1 block?"
let q3d = "How often would you get short of breath or tired if you walked less than 2 blocks?"
let q3e = "How often do you find yourself walking more slowly than usual?"

//12
let q4a = "How often do you get short of breath or tired when you are sitting doing nothing or when you are sleeping?"

//13
let q5a = "How often do you walk up hills?"
let q5b = "Do you avoid walking up hills because it makes you short of breath or tired?"
let q5c = "How often do you get short of breath or tired walking up hills in normal weather"

//16
let q6a = "How often do you go out in the cold/windy or hot/humid weather?"
let q6b = "Do you avoid cold/windy or hot/humid weather because it makes you short of breath or tired?"
let q6c = "How often do you get short of breath or tired when you go outside in the cold, windy or hot, humid weather?"

let q7a = "On a scale of 1-10, with 10 being perfectly normal and 0 being the worst imaginable health state, how would you rate yourself?"


let allQuestions = [q1a, q1b, q1c, q1d, q2a, q2b, q2c, q3a, q3b, q3c, q3d, q3e, q4a, q5a, q5b, q5c, q6a, q6b, q6c, q7a]


    
    //    @Published var allScores = [ScoresStructure]()
        
    //    let dbNY = Firestore.firestore()
        
    //    func readScoreData() {
    //        allScores = []
    //        dbNY.collection("scores-nyha").addSnapshotListener { (snap, err) in
    //
    //            if err != nil {
    //                print((err?.localizedDescription)!)
    //                self.noData = true
    //                return
    //            }
    //
    //            if (snap?.documentChanges.isEmpty)!{
    //
    //                self.noData = true
    //                return
    //            }
    //
    //            for i in snap!.documentChanges {
    //
    //                let id = i.document.documentID
    //                let scoreIndex = i.document.get("scoreIndex") as? Int16
    //                let score = i.document.get("score") as? Int16
    //
    //                self.allScores.append(ScoresStructure(id: id, scoreIndex: scoreIndex, score: score))
    //            }
    //
    //        }
    //
    //    }
    



    //struct ScoresStructure: Identifiable {
    //
    //    @DocumentID var id: String?
    //    var scoreIndex: Int16?
    //    var score: Int16?
    //
    //
    //}


