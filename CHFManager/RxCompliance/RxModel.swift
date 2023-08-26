//
//  RxModel.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-12.
//


import SwiftUI

struct RxModel: Identifiable, Decodable {
    public var id: Int
    public var generic : String
    public var brand: String
    public var type: String
}


struct PillModelTesting: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var cs
    @Environment(\.managedObjectContext) var moc
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var colors: [Color] = [.yellow, .white, .green, .lightEnd, .pulsatingColor]
    //    @State var gen: String
    //    @State var brand: String
    //    @State var type: String
    //    @State var dose: String
    //    @State var qty: Int
    //    @State var freq: String
    
    let characterLimit = 4
    @State var isSheetShown = false
    @State var isSheetShown2 = false
    @State var isSheetShown3 = false
    @State var remove = false
    @State var selection = 0
    var frequencies = ["q24h","q12h", "q8h", "q6h", "prn", "qhs", "qod"]
    @State var newField = ""
    let uwd = UIScreen.main.bounds.width
    let uhd = UIScreen.main.bounds.height
    var body: some View { 
        
        
        ZStack{
        Rectangle()
            .cornerRadius(10)
            .frame(width: hulk > 700 ? uwd / 2 - 35 : uwd / 2 - 20, height: hulk > 700 ? uhd / 5 : uhd / 4)
            .foregroundColor(cs == .light ? Color.lairWhite : Color.darkBG)
                        .shadow(color: cs == .dark ? Color.darkBG.opacity(0.6) : Color.black.opacity(0.3), radius: 2, x: -2, y: 3)
            .overlay(
                VStack{
                    VStack{
                        HStack{
                            
                            Text("Lisinopril")
                                .font(.system(size: hulk > 700 ? 16 : 14, weight: .regular, design: .rounded ))
                            
                            Spacer()
                            Button(action: {
                                self.remove.toggle()
                                
                            }) {
                                
                                Image(systemName: "square.and.pencil")
                                   
                                    .frame(width: 20, height: 20)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                        HStack{
                            Text("(Brand name here)").font(.system(size: hulk > 700 ? 11 : 10, weight: .light, design: .rounded ))
                            
                        Spacer()
                        }
//                        HStack{
//                            Spacer()
//                            Text("\(rx.type)").font(.system(size: 11, weight: .light, design: .rounded ))
//
//                        }
                    }.padding(.horizontal, 10).padding(.top, 15)
                    
                    VStack(spacing: hulk > 700 ? 10 : 5){
                        HStack{
                            Text("Dose:").fontWeight(.regular)
                            Spacer()
                            Button(action: {
                                self.isSheetShown = true
                                
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                  
                                    .frame(width: 20, height: 20)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            
                            Text("20 mg")
                        }
                        
                        
                        HStack{
                            Text("Quantity:").fontWeight(.regular)
                            Spacer()
                            Button(action: {
                                
                                self.isSheetShown2 = true
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                    
                                 
                                    
                                    .frame(width: 20, height: 20)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            
                            
                            
                            Text("2")
                        }
                        
                        
                        HStack{
                            Image(systemName: "clock")
                            Spacer()
                            Button(action: {
                                self.isSheetShown3 = true
                                
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                  
                                    
                                    .frame(width: 20, height: 20)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            
                            
                            Text("daily")
                        }
                    }.foregroundColor(Color.textColor(for: cs))
                    .padding(.top, hulk > 700 ? 10 : 0)
                    .padding(.horizontal, 15)
                    
                    
//                    Spacer()
                    HStack{
                        Spacer()
                        ZStack{
                        Image(systemName: "pills.fill")
                            
                            .font(.system(size: hulk > 700 ? 12 : 10))
                            .frame(width: 30, height: 30)
                            .cornerRadius(10)
                            .shadow(color: cs == .dark ? Color.sand.opacity(0.2) : Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                            .offset(x: self.remove ? -25 : 0)
                        Button(action: {
                        }) {
                            
                            Image(systemName: self.remove ? "minus.circle.fill" : "")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: hulk > 700 ? 15 : 12, height: hulk > 700 ? 15 : 12)
                                
                        }
                        }
                    }.offset(y: hulk > 700 ? 0 : -5)
                    
                }.font(.system(size: hulk > 700 ? 14 : 12, weight: .light, design: .rounded ))
                .foregroundColor(Color.textColor(for: cs)) .opacity(0.7)
            )
        }
            .padding(.horizontal)
           
    }
    
    func limitD(_ upper: Int) {
        if newField.count > upper {
            newField = String(newField.prefix(upper))
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
extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

class SearchMeds: ObservableObject {
    @Published var searchedMeds: [RxModel] = []
    @Published var query = ""
    @Published var allMeds = Bundle.main.decode([RxModel].self, from: "HFmeds.json")
    @Published var page = 1
    @Published var searchedInFull : [String] = []
   @Published var gen = ""
    @Published var brand = ""
    @Published var type = ""
    
    @Published var dose = "" {
        didSet {
            let filtered = dose.filter { $0.isNumber || $0.isPunctuation }
            
            if dose != filtered {
                dose = filtered
            }
        }
    }
    @Published var freq = "" {
        didSet {
            let filtered = freq.filter { $0.isNumber }
            
            if freq != filtered {
                freq = filtered
            }
        }
    }
    @Published var qty = "" {
        didSet {
            let filtered = qty.filter { $0.isNumber }
            
            if qty != filtered {
                qty = filtered
            }
        }
    }
//    func find() {
//       
//        let data = self.allMeds
//        if self.page == 1 {
//            self.searchedMeds.removeAll()
//        }
//        self.searchedMeds.append(contentsOf: data)
//    }
    
}
