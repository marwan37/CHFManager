////
////  DeleteCoreDataElement.swift
////  Golgi-Splash
////
////  Created by Deeb Zaarab on 2020-12-17.
////
//
import SwiftUI
import CoreData
struct DeleteCoreDataElement: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Score.entity(), sortDescriptors: []) var scoreItems: FetchedResults<Score>
    @FetchRequest(entity: Weight.entity(), sortDescriptors: []) var weightItems: FetchedResults<Weight>
    @State var scoreArray = [Int]()
    @State var indexArray = [Int]()
    @State var remove = false
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ScrollView{
            VStack(spacing:5){
                HStack{
                    Text("Weight Check & Questionnaire Scores")
                    Spacer()
                }
                .font(.system(size: 14, weight: .regular, design: .rounded))
                
                
                //images/icons
                HStack{
                    HStack{
                        Image(systemName: "heart.text.square")
                        Image(systemName: "grid.circle")
                    } .padding(.leading, 10)
                    Spacer()
                    Image(systemName: "scalemass")
                    Image(systemName: "calendar")
                    Spacer()
                    Button(action: {
                        self.remove.toggle()
                        
                    }) {
                        
                        Image(systemName: self.remove ? "xmark.circle" : "trash")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red)
                        
                        
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                //DATA
                HStack{
                    
                    //score
                    VStack{
                        
                        HStack(spacing:5){
                            ForEach(scoreItems, id:\.self.id){collection in
                                Text("\(Int(collection.score))").fontWeight(.semibold)
                                Text("[\(collection.month?.uppercased() ?? "")\(collection.scoreIndex + 1)]")
                                Button(action: {
                                    DispatchQueue.main.async {
                                        moc.delete(collection)
                                        saveMoc()
                                    }
                                    
                                }) {
                                    
                                    Image(systemName: self.remove ? "minus.circle.fill" : "")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.red)
                                }.buttonStyle(BorderlessButtonStyle())
                                
                            }
                        }.font(.system(size: 12, weight: .thin, design: .monospaced))
                        .padding(.leading, 7)
                    }
                    Spacer()
                    //calendar + weight
                    
                    VStack{
                    ForEach(weightItems, id:\.self.id){ pound in
                       
                            HStack{
                                Text("\(Int(pound.weight)) lbs").fontWeight(.semibold)
                                Text("[\(pound.month)\(pound.weightIndex)]")
                                Button(action: {
                                    DispatchQueue.main.async {
                                        moc.delete(pound)
                                        saveMoc()
                                    }
                                }) {
                                    Image(systemName: self.remove ? "minus.circle.fill" : "")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(.red)
                                }.buttonStyle(BorderlessButtonStyle())
                                
                            }.font(.system(size: 12, weight: .thin, design: .monospaced))
                        }
                        }
                    Spacer()
                    }
                }
                
            }
        }
        
        //        func deleteItems() {
        //            let offsets: IndexSet
        //            withAnimation{
        //                offsets.map { dayItems[$0] }.forEach(moc.delete)
        //                saveMoc()
        //            }
        //        }
        func saveMoc() {
            do {
                try moc.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved Error: \(error)")
            }
        }
        
    }
    
    struct DeleteCoreDataElement_Previews: PreviewProvider {
        static var previews: some View {
            DeleteCoreDataElement()
        }
    }
    
    var profileView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 122, height: 122)
            .mask(
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
            )
    }
    var starView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 25, height: 25)
            .mask(
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
            )
    }
    var calendarView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 25, height: 25)
            .mask(
                Image(systemName: "calendar")
                    .resizable()
                    .scaledToFit()
            )
    }
    var medsView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 25, height: 25)
            .mask(
                Image(systemName: "pills.fill")
                    .resizable()
                    .scaledToFit()
            )
    }
    var crossView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 25, height: 25)
            .mask(
                Image(systemName: "cross.fill")
                    .resizable()
                    .scaledToFit()
            )
    }
    var dropView: some View {
        LinearGradient.lairHorizontalDark
            .frame(width: 25, height: 25)
            .mask(
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
            )
    }
    var checkView: some View {
        
        Image("check3d")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
//
/////list view extras below
////MARK: FUNC for Navigation buttons
//
////    var newCompletion : some View {
////        Button(action: {
////                self.modalIsPresented = true
////            self.docID = self.data.id
////            self.newCollection = true
////        })  {
////            ZStack{
////                Image(systemName: "plus")
////                    .font(.system(size: 14, weight: .bold))
////                    .foregroundColor(.white)
////
////            }.frame(width: 12, height: 12)
////             }.buttonStyle(SimpleButtonStyle())
////        .offset(x: -7, y: -9)
////        .sheet(isPresented: $modalIsPresented, content: {
////            Master(docID: $docID, isPresented: $modalIsPresented, masterDate: $masterDate)
////                    .environmentObject(PartialSheetManager())
////                .environmentObject(DayData())
////                    .environment(\.managedObjectContext, self.moc)
////             })
////    }
//
////    var refreshButton : some View {
////        Button(action: {
////
////            self.remove.toggle()
////
////            if self.remove {
////
////                self.width = UIScreen.main.bounds.width / 5 - 15
////                self.minusOffset = -5
////            }
////
////            else {
////                self.width = UIScreen.main.bounds.width / 5 - 10
////                self.minusOffset = 0
////            }
////
////        }) {
////            ZStack{
////            Image(systemName: self.remove ? "xmark.circle" : "trash")
////                .font(.system(size: 14, weight: .bold))
////                .foregroundColor(.red)
////
////        }.frame(width: 12, height: 12)
////        }.buttonStyle(SimpleButtonStyle())
////        .offset(x: 7, y: -9)
////    }
//
//
////    func deleteItems() {
////        let offsets: IndexSet
////        withAnimation{
////            offsets.map { dayItems[$0] }.forEach(moc.delete)
////            saveMoc()
////            self.firedata.allData.remove(atOffsets: offsets)
////        }
////    }
//
//
//
//
//
////    @ObservedObject var firedata = FireData()
//
////    @State var remove = false
////    @State var docID = ""
////    @State var newCollection = false
////    @State var masterDateString = ""
////    @State var masterDate = Date()
////    @State var modalIsPresented = false
////    @State private var isToggled = false
//
//
//
////MARK: If want to delete (CODE)
////                                if self.remove{
////
////                                    VStack(spacing: 20){
////                                        Button(action: {
////                                            DispatchQueue.main.async {
////                                                moc.delete(collection)
////
////                                                 saveMoc()
////                                                let db = Firestore.firestore()
////
////                                                db.collection("final-Day").document(docID).delete()
////
////
////
////
////                                            }
////
////
////                                        }) {
////
////                                            Image(systemName: "minus.circle.fill")
////                                            .resizable()
////                                            .frame(width: 12, height: 12)
////                                            .foregroundColor(.red)
////                                        }.buttonStyle(BorderlessButtonStyle())
////                                    }.frame(width: 20)
////                                }
//
//
