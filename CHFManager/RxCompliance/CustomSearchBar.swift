//
//  CustomSearchBar.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-12.
//

import SwiftUI

struct CustomSearchBar: View {
    @ObservedObject var searchData : SearchMeds
    @Binding var isEditing : Bool
    @Binding var searchedList: [RxModel]
    @Binding var mainList: [RxModel]
    let cols = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        VStack(spacing:0){
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchData.query)
                    .autocapitalization(.none)
                    .onChange(of: searchData.query) { (newData) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            
                            searchedList = mainList.filter { $0.generic.contains(newData) || $0.brand.contains(newData) || $0.type.contains(newData) || $0.generic.lowercased().contains(newData) || $0.brand.lowercased().contains(newData) || $0.type.lowercased().contains(newData)}

                        }
                    }
                    .onTapGesture {
                        self.isEditing = true
                    }
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchData.query = ""
                        // Hide Keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }){
                        Text("Cancel")
                    }.padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }.padding(.vertical, 10)
//            .padding(.horizontal)
            
//            if !searchData.searchedMeds.isEmpty {
//                ScrollView(.vertical, showsIndicators: true) {
//                    ForEach(searchData.allMeds.filter({searchData.query.isEmpty ? true : $0.generic.contains(searchData.query )}))
//                            { p in
//                                    LazyVGrid(columns:cols, alignment: .leading){
//                                        Text(p.generic)
//                                Text(p.brand)
//                                Text(p.type)
//
//                            }
//                    }
//                        .padding(.horizontal)
//                }.padding(.top).frame(height: 240)
//            }
            
        }
        .background(Color.lairWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10))
//        .padding()
    }
}

