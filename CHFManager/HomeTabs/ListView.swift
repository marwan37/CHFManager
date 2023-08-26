//
//  ListView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-30.
//

import SwiftUI
import CoreData


struct ListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var dateFormat = "EEE, MMM d"
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    let rows = [
        GridItem(.flexible())
    ]
    @FetchRequest(fetchRequest : MasterData.getDayData()) var dayItems:FetchedResults<MasterData>
    @State var dateArray : [String?] = []
    @EnvironmentObject var data : DayData
  
    var circleColor : Color {
        if self.colorScheme == .dark {
            return  Color.neonRed
        } else {
            return Color.red
        }
    }
    var fatColor : Color {
        if self.colorScheme == .dark {
            return  Color.neonBlue
        } else {
            return Color.blue
        }
    }
    var dyspColor : Color {
        if self.colorScheme == .dark {
            return  Color.lilly
        } else {
            return Color.neonOrange
        }
    }
    var noFill : Color {
        if self.colorScheme == .dark {
            return  Color.lairWhite
        } else {
            return Color.lairBackgroundGray
        }
    }
    @State var medsCompliance = [Int]()
    @State var width: CGFloat = UIScreen.main.bounds.width / 5
    @State var widthy: CGFloat = UIScreen.main.bounds.width / 5 - 15
    @State var minusOffset:CGFloat = 0
    @Environment(\.horizontalSizeClass) var sizeClass
   
    let cols = [
        GridItem(.fixed(UIScreen.main.bounds.width / 4)),
        GridItem(.fixed(UIScreen.main.bounds.width * 0.75))]
   @State var shown = 0
    var body: some View {
//        NavigationView{
        
        VStack{

        VStack( alignment: .leading, spacing: 10){
            if self.dayItems.isEmpty {
                Spacer()
                Text("No Data !!!")
                Spacer()
            }
            else{
                
                
                    LazyVGrid(columns: columns){
                        Image(colorScheme == .light ? "menub0" : "menuc0")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height:30)
                        Image(colorScheme == .light ? "menu73" : "menu73c")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height:30)
                        Image(colorScheme == .light ? "menub1" : "menuc1")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height:30)
                        Image(colorScheme == .light ? "menub2" : "menuc2")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height:30)
                        Image(colorScheme == .light ? "menub4" : "menuc4")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 30, height:30)
                    }
                List{
//                    .font(.system(size: 20, weight: .ultraLight, design:.rounded))
//                    .opacity(0.6)
                            
                    ForEach(dayItems.indices) { i in
                        
                        LazyVGrid(columns: columns){
                            VStack(alignment: .leading, spacing: 20){
                                
                                Text("\(dayItems[i].date!.string(format: self.dateFormat.subStringAfterLastComma))")
                                    .font(.system(size: 14, weight: .regular, design:.rounded))
//                                    .opacity(0.7)
                            }.offset(x:-12)

                            VStack(spacing: 20){
                                ZStack{
                                    Text(dayItems[i].percentage > 0.97 ? "" : "\(Int(dayItems[i].percentage * 100))%")
                                        .font(.system(size: 14, weight: .regular, design:.rounded))
                                    Image(systemName: "checkmark")
                                        .isHidden(dayItems[i].percentage < 0.97)
                                    
                                }
//                                .opacity(0.8)
                            }.offset(x:-4)

                            VStack(spacing: 20){
                                HStack(spacing:0){
                                    if self.medsCompliance.isEmpty == false {
                                        if medsCompliance[i] < 100 {
                                            Text("\(self.medsCompliance[i])%")
                                                .font(.system(size: 14, weight: .regular, design:.rounded))
                                        } else {
                                            Image(systemName: "checkmark")
                                                
                                                .font(.system(size: 14, weight: .regular))
                                                
                                            
                                        }
                                        
                                    }
                                }
//                                .opacity(0.8)
                            }

                            VStack(spacing: 20){
                                HStack(spacing:5){
                                    Image(systemName: dayItems[i].swelling ==  1 ? "s.circle.fill" : "s.circle"  )
                                        .foregroundColor(dayItems[i].swelling == 1 ? circleColor : noFill )
                                        .opacity(dayItems[i].swelling == 1 ? 1 : 0.2)
                                        .frame(width: 12, height: 12)
                                    
                                    
                                    Image(systemName: dayItems[i].fatigue == 1 ? "f.square.fill" : "f.square"  )
                                        .foregroundColor(dayItems[i].fatigue == 1 ? fatColor : noFill )
                                        .opacity(dayItems[i].fatigue == 1 ? 1 : 0.2)
                                        .frame(width: 12, height: 12)
                                    
                                    
                                    Image(systemName: dayItems[i].dyspnea == 1 ? "d.circle.fill" : "d.circle"  )
                                        .foregroundColor(dayItems[i].dyspnea == 1 ? dyspColor : noFill )
                                        .opacity(dayItems[i].dyspnea == 1 ? 1 : 0.2)
                                        .frame(width: 12, height: 12)
                                    
                                    
                                }.opacity(0.8).colorInvert()
                            }.offset(x:6)

                            VStack(spacing: 20){
                                Text("\(Int(dayItems[i].liquids))oz")
                                    .font(.system(size: 14, weight: .regular, design:.rounded))
//                                    .opacity(0.6)
                            }.offset(x:15)
                            
                            
                        }.font(.system(size: 14, weight: .regular))
                        
                    }
                }.navigationBarTitle("Daily Completion")
//                .navigationBarHidden(true)
//                .navigationBarBackButtonHidden(true)
                .listStyle(InsetListStyle())
                .listRowBackground(self.colorScheme == .dark ? Color.lilly : Color.white)
//                .id(UUID())
            }
        }
        .onAppear{
            DispatchQueue.main.async{
//                if self.medsCompliance.isEmpty {
//                    for _ in 0..<dayItems.count {
//                        self.medsCompliance.append(0)
//                    }
//                }
                self.medsCompliance = []
                
                self.fetchTheGuestList()
                self.fetchMedsCompliance()
            }
        }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//        }
        .padding()
        .padding(.top, 10)
    }
    func fetchMedsCompliance() {
        
        if dayItems.count > 0 {
        for i in 0..<dayItems.count {
            let temp = dayItems[i].rxComp
            print("rxcomp temp = \(temp)")
            let percent = (temp / 4) * 100
            let intPercent = Int(percent)
            self.medsCompliance.append(intPercent)
         
         
        }
            print("medsComplianceListView: \(medsCompliance)")
        }
    }

    func fetchTheGuestList() {
        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date?.string(format: self.dateFormat)}
            self.dateArray = dateArray
            
        } catch {
            print("Could not fetch. \(error)")
        }
        
        
    }
    
    func saveMoc() {
        do {
            try moc.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
  
    
    
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(DayData())
    }
}

//    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
//        {
//        let db = Firestore.firestore()
//       db.collection("dayDatas").getDocuments() { (snapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//          for document in snapshot!.documents {
//            document.reference.delete()
//          }
//        }
//       }
//
//            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MasterData")
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//            do
//            {
//                try moc.execute(deleteRequest)
//                try moc.save()
//            }
//            catch
//            {
//                print ("There was an error")
//            }
//        }
    

