//
//  RxComplianceView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-12.
//

import SwiftUI

struct AddRxView: View {
    
    @Environment(\.managedObjectContext) var moc
    let cols = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.fixed(50))]
    @State private var mainList = [RxModel]()
    @State private var searchedList = [RxModel]()
    @State private var searching = false
    @State var allMeds = Bundle.main.decode(
        [RxModel].self, from: "HFmeds.json")
    @StateObject var searchMeds = SearchMeds()
    @State var showingRxDetails = false
    @State var showingOther = false
    @State var rxTapped : [String] = []
    var body: some View {
        
        NavigationView{
            
            ScrollView{
                CustomSearchBar(searchData: searchMeds, isEditing: $searching, searchedList: $searchedList, mainList: $allMeds)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                  
                LazyVGrid(columns:cols, alignment: .leading){
                Text("Generic name")
                    Text("Brand name")
                    Text("Class")
            }.font(.system(size: 14, weight: .regular, design: .rounded))
            
               
                ForEach(searching ? (0..<searchedList.count) : (0..<mainList.count), id: \.self) { i in
                        LazyVGrid(columns:cols, alignment: .leading){
                            Text(searching ? self.searchedList[i].generic : mainList[i].generic)
                            Text(searching ? self.searchedList[i].brand : mainList[i].brand)
                            Text(searching ? self.searchedList[i].type : mainList[i].type)
                            Button(action:{
                                DispatchQueue.main.async {
                                    if searching {
                                        searchMeds.gen = searchedList[i].generic
                                        searchMeds.brand = searchedList[i].brand
                                        searchMeds.type = searchedList[i].type
                                    } else {
                                        searchMeds.gen = mainList[i].generic
                                        searchMeds.brand = mainList[i].brand
                                        searchMeds.type = mainList[i].type
                                    }
                                    self.showingRxDetails.toggle()
                                }
                                
                            })
                            {
                                HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    Text("Add")
                                }
                            }
                            
                        }
                        Divider()
            }.font(.system(size: 12, weight: .light, design: .rounded))
                .onAppear {
                    self.mainList = searchMeds.allMeds
                }
               
            }.sheet(isPresented: $showingRxDetails) {
                AddMed(gen: $searchMeds.gen, brand: $searchMeds.brand, type: $searchMeds.type).environment(\.managedObjectContext, self.moc)
            }
            
            .navigationTitle("Add Rx")
            .navigationBarItems(trailing: Button("Add Other") {
                self.showingOther.toggle()
            }.sheet(isPresented: $showingOther) {
                AddOtherMed().environment(\.managedObjectContext, self.moc)
            })
        }

            
        }


}
    


struct AddRxView_Previews: PreviewProvider {
    static var previews: some View {
        AddRxView()
    }
}
