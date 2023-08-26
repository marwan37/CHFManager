//
//  Home.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-28.
//

import SwiftUI
import CoreData
//import Firebase
import PartialSheet
import Combine
//import GoogleSignIn
//import FBSDKLoginKit

let ultra = UIScreen.main.bounds.width
final class SomeObservable: ObservableObject {
    @Published var isBlurred = false
}
struct Home: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var sheetManager: PartialSheetManager
    @FetchRequest(fetchRequest : MasterData.getDayData()) var dayItems:FetchedResults<MasterData>
   @State var goToLogin = false
    @State var completionAverage : Int = 0
    @State var medsComplianceAverage: Int = 0
    @State var medsCompliance = [Int]()
    @State var symptomAverage: Int = 0
    @State var nyhaAverage: Double = 0
    @State var weight: Double? = 0
    @State var score: Int? = 0
    @State var damageAverage = [Int]()
    @State var gender = ""
    @State var name = ""
    @State var age = ""
    @State var isSheetShown = false
    @State var isSheetShown2 = false
    @State var isSheetShown3 = false
    @State var show = false
    @State var result : Any? = ["",1,""]
    let characterLimit = 2
    @State var image = "Neutral"
//    @ObservedObject var userSettings = UserSettings()
    @AppStorage("logged") var logged = false
    @AppStorage("email") var email = ""
    @AppStorage("status") var status = true
    @AppStorage("log_Status") var logStatus = false
    @AppStorage("apple_status") var appleStatus = false

//    @State var user = Auth.auth().currentUser

    var body: some View {
        ZStack{
            LinearGradient.overall(for: colorScheme).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
        VStack{
        VStack{
            HStack{
               Image("patient")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: ultra > 400 ? 122 : ultra / 4.2, height: 122)
                .padding()
              Spacer()
                ZStack{
        
                    
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, style: StrokeStyle())
                    .frame(width: ultra / 2 , height: 100)
                    
                    .foregroundColor(Color.backgroundColor(for: colorScheme))
                    
                }.padding(.trailing, 20)
            }
            
            Divider().padding()
            VStack(spacing: 15){
                
                HStack{
                    Image("Daily Log2")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                    Text("Statistics").font(.system(size: 15, weight: .regular, design: .rounded))
                    Spacer()
                }
                VStack(spacing: 15){
                HStack{
//                    Image("Daily Log2")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 22)
                   
                    Text("Average Daily Completion:")
                    Spacer()
                    Text("\(self.completionAverage)%")
                    
                }
                HStack{
//                    Image("Rx2")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 22)
                    Text("Average Medication Compliance:")
                    Spacer()
                    Text("\(self.medsComplianceAverage)%")
                    
                }
                HStack{
//                    Image("bandage")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 22)
                    Text("Average Symptom Occurence:")
                    Spacer()
                    Text("\(self.symptomAverage)%")
                    
                }
                HStack{
//                    Image("Weight2")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 22)
                    Text("Last Weight:")
                    Spacer()
                    Text("\(Int(self.weight!)) lbs")
                    
                }
                HStack{
//                    Image("Questionnaires2")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 22)
                    Text("Last Questionnaire Score:")
                    Spacer()
                    Text("\(Int(self.score!))")
                    
                }
                }.padding(.leading, 10)
            }.font(.system(size: 15, weight: .thin, design: .rounded))
            .padding()
            
//            Divider()
//            DeleteCoreDataElement().environment(\.managedObjectContext, self.moc) 
//            
            
            
        } .foregroundColor(self.colorScheme == .dark ? .white : .black)
        //        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .frame(width:UIScreen.main.bounds.width - 20)
        Divider()
            .padding()
        
            Spacer()
                
        .onAppear{
            DispatchQueue.main.async{

                if self.medsCompliance.isEmpty {
                    for _ in 0..<dayItems.count {
                        self.medsCompliance.append(0)
                    }
                }
                if self.damageAverage.isEmpty {
                    for _ in 0..<dayItems.count {
                        self.damageAverage.append(0)
                    }
                }

                self.fetchMedsCompliance()
                self.fetchAverages()
                self.fetchDamage()
                self.fetchWeightData()
                self.fetchScoreData()

            }
        }
          
//MARK: LOGOUT BUTTON / REGISTER/ SIGNIN &&*&&******
            
        }

        }
        }
    
.navigationTitle("")
}
//        func limitD(_ upper: Int) {
//                if userSettings.age.count > upper {
//                    userSettings.age = String(userSettings.age.prefix(upper))
//                }
//            }
func fetchMedsCompliance() {
    var num : Double = 0
    var percent: Double = 0.0
    if dayItems.count > 0 {
        for i in 0..<dayItems.count {
            num = dayItems[i].rxComp
            percent = (num / 4) * 100
            self.medsCompliance.append(Int(percent))
            
            
            num = 0
            percent = 0
            
            
        }
        let temp = medsCompliance.reduce(0, +)
        self.medsComplianceAverage = temp / (dayItems.count * 4)
    }
}

func fetchDamage() {
   
    if dayItems.count > 0 {
        for i in 0..<dayItems.count {
            
            let num = dayItems[i].swelling + dayItems[i].fatigue + dayItems[i].dyspnea
            let doubleNum = Double(num) / 3
            let percent = doubleNum * 100
            
            self.damageAverage.append(Int(percent))
         
        }
        let temp = damageAverage.reduce(0, +)
        self.symptomAverage = temp / (dayItems.count * 3)
    }
}

func fetchAverages() {
    var comp: Double = 0
    if dayItems.count > 0 {
        for i in 0..<dayItems.count {
            let temp = dayItems[i].percentage
            comp += temp
        }
        let temp2 = (comp/Double(dayItems.count)) * 100
        self.completionAverage = Int(temp2)
        print("self.completionAverage = \(self.completionAverage)")
    }
}

func fetchWeightData() {
    let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")
    do{
        let result = try moc.fetch(fetchRequest)
        let weightArray = result.map{$0.weight}
        for i in weightArray.indices{
            if weightArray[i] != 0 {
                self.weight = weightArray[i]
            }
        }
     
    } catch {
        print("Could not fetch \(error)")
    }
}
    
    func fetchScoreData() {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        do{
            let result = try moc.fetch(fetchRequest)
            let scoreArray = result.map{$0.score}
            for i in scoreArray.indices {
                if scoreArray[i] != 0 {
                    self.score = scoreArray[i] 
                }
            }
        } catch {
            print("Could not fetch \(error)")
        }
    }
   
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(PartialSheetManager())
    }
}
