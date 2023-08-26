////
////  RxView.swift
////  Golgi-Splash
////
////  Created by Deeb Zaarab on 2021-01-13.
////
//
//import SwiftUI
//import Combine
//import CoreData
//struct RxView: View {
//    @FetchRequest(fetchRequest : RxData.getRx()) var rxData:FetchedResults<RxData>
//    @Environment(\.managedObjectContext) var moc
//    let cols2 = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()), GridItem(.fixed(40))]
//    @State var showAddView = false
//    @State var remove = false
//    var body: some View {
//        NavigationView{
//        VStack{
//            
////            Text("Your Prescriptions").font(.system(size: 20, weight: .regular, design: .monospaced))
//            
//            LazyVGrid(columns: cols2, alignment:.leading) {
//                Text("Generic")
//                Text("Brand")
//                Text("Type")
//                Text("Schedule")
//                Button(action:{
//                   self.remove.toggle()
//               }){
//                   Text(self.remove ? "Done" : "Edit")
//               }
//            }.font(.system(size: 14, weight: .regular, design: .monospaced))
//            
//            LazyVGrid(columns: cols2, alignment:.leading) {
//                ForEach(rxData, id:\.self.id) { rx in
//                    Text(rx.gen)
//                    Text(rx.brand)
//                    Text(rx.type)
//                    Text("\(rx.dose) \(rx.qty) \(rx.freq) ")
//                    Button(action: {
//                        DispatchQueue.main.async {
//                            moc.delete(rx)
//                            saveMoc()
//                        }
//                        
//                    }) {
//                        
//                        Image(systemName: self.remove ? "minus.circle.fill" : "")
//                            .resizable()
//                            .frame(width: 12, height: 12)
//                            .foregroundColor(.red)
//                    }.buttonStyle(BorderlessButtonStyle())
//                  
//                   
//                }.onDelete(perform: delete)
//                
//                
//            }.font(.system(size: 12, weight: .regular, design: .monospaced))
//            
//            
//            Divider()
//            
//            
//        }.onAppear{
//            self.fetchSymptomData()
//        }
//        .navigationTitle("Your Rx")
//        .navigationBarHidden(false)
//        .navigationBarItems(trailing: Button(action:{
//            self.showAddView.toggle()
//        }){
//            Text("Add")
//            }.sheet(isPresented: $showAddView) {
//                AddRxView()
//            })
//        }
//   
//    }
//    func delete(at offsets: IndexSet) {
//        
//        if let first = offsets.first {
//            moc.delete(rxData[first])
//            saveMoc()
//        }
//      }
//    func fetchSymptomData() {
//        let fetchRequest = NSFetchRequest<RxData>(entityName: "RxData")
//        do{
//            let result = try moc.fetch(fetchRequest)
//           
//            let genArray = result.map{$0.gen}
//            let brArray = result.map{$0.brand}
//            let tyArray = result.map{$0.type}
//            
//            print("FETCHRX\(genArray) \(brArray) \(tyArray)")
//
//        } catch {
//            print("Could not fetch. \(error)")
//        }
//        
//    }
//    
//    func saveMoc() {
//        do {
//            try moc.save()
//        } catch {
//            let error = error as NSError
//            fatalError("Unresolved Error: \(error)")
//        }
//    }
//}
//
//struct RxView_Previews: PreviewProvider {
//    static var previews: some View {
//        RxView()
//    }
//}
//
//
