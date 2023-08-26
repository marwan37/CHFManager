import SwiftUI
import CoreData
import Grid
struct Master: View {
    @Environment(\.colorScheme) var cs
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @Binding var docID: String
    var keyStore = NSUbiquitousKeyValueStore()
    @EnvironmentObject var data : DayData
    @State var isOn: Bool = false
    @State var isSheetShown = false
    @State var mcv = MasterCalendarView()
    @FetchRequest(fetchRequest : RxData.getRx()) var rxData:FetchedResults<RxData>
    @State var pillsPushed = false
    var dateFormat = "EEEE, MMM d"
    @State var dateArray: [String] = []
    @State var masterDate: Date
    @State var infoButtonTapped = false
  @State var name = ""
    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let columns2 = [
        GridItem(.fixed(UIScreen.main.bounds.midX - 25)),
        GridItem(.fixed(UIScreen.main.bounds.midX - 25))
    ]
    //MARK: colors
    var colored = Color.blue
    @State var colorIndex = "light"
    var textColor: Color {
        return colorIndex == "light" ? Color.grayText : Color.white
    }
    
    //MARK: LazyVGrid Columns
    let columns3 = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State var saved = false
    var body: some View {
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack{
                    //MARK: TITLE
                        LazyVGrid(columns: columns3, spacing: 20) {
                            VStack(alignment:.leading, spacing: 8){
                               
                                Text("Daily Completion")
                                .font(.system(size: 18, weight: .semibold, design:.rounded))
                                .foregroundColor(.trackColor)
                        
                                Text(masterDate.string(format: self.dateFormat))
                                .font(.system(size: 16, weight: .regular, design:.rounded))
                                .foregroundColor(textColor)
                          
                                Button(action:{self.presentationMode.wrappedValue.dismiss()}) {
                                    
                                    Text("Return to Calendar") .font(.system(size: 16, weight: .regular, design:.rounded))
                                }
                               
                        }
                       VStack{
                            ArcView()
                        }
                    }
                }
                .padding(.top, 25)
                .padding(.bottom, 15)
                Divider().padding()
//MARK: MEDS TASK VIEW
                HStack(spacing: 5){
                        Text("Medication Compliance")
                        .font(.system(size: 16, weight: .regular, design:.rounded))
                            .padding(.leading, 27)
                }.padding(.top, 10)
                .frame(width: UIScreen.main.bounds.width-50, height: 30, alignment: .leading).offset(x: -23)
                .onAppear {
                    self.checkRx()
                }
                if rxData.count > 0 {
                Grid(rxData.indices){ rx in
                    if rxData[rx].qty > 0 {
                    MedsTaskView(gen: rxData[rx].gen, type: rxData[rx].type, qty: rxData[rx].qty)
                    }
                }.padding(.horizontal, 30)
                .gridStyle(
                    ModularGridStyle(.vertical, columns: ultra > 400 ? 2 : 1, rows: .fixed(hulk > 700 ? 85 : 85))
                )
                } else {
                    HStack(spacing: 5){
                        Text("No medications added.").foregroundColor(.gray)
                    Button(action:{pillsPushed.toggle()}) {
                        Text("Tap here to add medications.")
                    }.sheet(isPresented: $pillsPushed) {
                        PillsView(pushed: $pillsPushed)
                            .environment(\.managedObjectContext, self.moc)
                            .navigationTitle("")
                    }
                        
                    }.font(.caption).padding(.top, 5)
                    .frame(width: UIScreen.main.bounds.width-65, alignment: .leading)
                }
            
            Divider().padding()
         //MARK: SYMPTOM TRACKER VIEW
        HStack{
            (Text("Symptom Tracker") + Text("  (signs to watch for)").font(.system(size: 14, weight: .thin, design: .rounded)))
            .font(.system(size: 16, weight: .regular, design:.rounded))
                .padding(.leading, 29)
            Spacer()
            }
            ThreeSymptomsView()
                .padding(.horizontal)
                .padding(.top, 10)
            Divider().padding(.vertical)
                
        //MARK: SAVE BUTTON
           Button(action:{
            fetchDateCompletion()
              //CORE DATA STORAGE
                let dayData = MasterData(context: self.moc)
                dayData.id = self.docID
                dayData.date = self.masterDate
                dayData.percentage = self.data.percentage
                dayData.swelling = data.swelling
                dayData.fatigue = data.fatigue
                dayData.dyspnea = data.dyspnea
                dayData.rxComp = data.howMany.rounded()
            
            let user = Userdetails(context: self.moc)
            user.addToMasterData(dayData)
            self.saveMoc()
            
            let waterShared = Int(self.data.liquids)
            UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!.set("\(waterShared)", forKey: "waterShared")
            //CLOUD KIT STORAGE
            let newItem = DayCellModel(
                date: self.masterDate,
                id: self.docID,
                percentage: self.data.percentage,
                swelling: dayData.swelling,
                fatigue: dayData.fatigue,
                dyspnea: dayData.dyspnea,
                rxComp: Double(self.data.howMany))
            CloudKitHelper.save(item: newItem) { (result) in
                switch result {
                case .success(let newItem):
                    self.data.items.insert(newItem, at: 0)
                    print("Successfully added item")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            mcv.fetchDateCompletion()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                    HStack(spacing: 1){
                        Image(systemName: self.isOn ? "square.and.arrow.down.fill" : "square.and.arrow.down")
                        Text("Save ")
                    }.font(.system(size: 16, weight: .regular, design:.monospaced))
                    .foregroundColor(.blue)
           }.sheet(isPresented: $saved) {
            TransitionView()
           }
                Divider().padding(.vertical)
        
    //MARK: END OF SAVE BUTTION
                    }.navigationBarTitle("")
        .navigationBarHidden(true)
            .padding(.top, 20)
        }
    }
    
    
    func fetchDateCompletion() {
        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
        do{
            let result = try moc.fetch(fetchRequest)
            self.dateArray = result.map {$0.date!.string(format: self.dateFormat)}
        } catch {
            print("Could not fetch. \(error)")
        }

    }

    func checkRx() {
        var medCountNonPrn: Double = 0
        for i in 0..<rxData.count {
            if rxData[i].qty > 0 {
                medCountNonPrn += 1
            }
        }
        let rxQty = 0.4 / medCountNonPrn
        self.data.rxQty = rxQty
        self.data.rxCount = medCountNonPrn
    }
    
    func saveMoc() {
        do {
            try moc.save()
            
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func medsProgress() -> Bool {
       var result: Bool = false
        if self.data.howMany == 4 {
           result = true
        }
      return result
    }
 
    func waterProgress() -> Bool {
        var result: Bool = false
        if self.data.liquids == 8 {
            result = true
        }
        return result
    }
    
    func save() {
        self.moc.performAndWait {
            if self.moc.hasChanges {
                do {
                    try moc.save()
                }
                 catch {
                    let error = error as NSError
                    fatalError("Unresolved Error: \(error)")
                }
            }
        }
    }

}



extension VerticalAlignment {
    struct CustomAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[VerticalAlignment.center]
        }
    }

    static let custom = VerticalAlignment(CustomAlignment.self)
}


struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        Master(docID: .constant(""), masterDate: Date())
//            .environmentObject(PartialSheetManager())
            .environmentObject(DayData())


    }
}
