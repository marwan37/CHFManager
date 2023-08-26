//
//  SideMenu.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-12-18.
//

import SwiftUI


struct Menu : View {
    @Binding var curved: Bool
    @Binding var straight: Bool
    @Binding var bar: Bool
    @Binding var pie: Bool
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    var width: CGFloat = 50
    var size: CGFloat = 12
    var rwidth: CGFloat = 50
    @Binding var showMenu: Bool
    var body: some View {
        
        VStack(spacing: 25) {
         
            Button(action:{
                self.curved.toggle()
                self.pie = false
                self.straight = false
                self.bar = false
                self.showMenu.toggle()
            })
            {
                VStack(spacing: 8) {
//
                            AccessoryView(image: Image(systemName: "scribble"))
                            

                    
                    Text("Curved")
                        .font(.system(size: size, weight: .thin))
                }
            }
            
            Button(action:{
                    self.straight.toggle()
                self.pie = false
                self.bar = false
                self.curved = false
                self.showMenu.toggle()
                
            })
            {
                VStack(spacing: 8) {

                            AccessoryView(image: Image(systemName: "line.diagonal"))
                                .frame(width: width, height: width)

                    Text("Straight")
                        .font(.system(size: size, weight: .thin))
                }
            }
            
            Button(action:{
                    self.bar.toggle()
                self.pie = false
                self.straight = false
                self.curved = false
                self.showMenu.toggle()
            })
            {
                VStack(spacing: 8) {

                            AccessoryView(image: Image(systemName: "chart.bar"))
                                .frame(width: width, height: width)

                    Text("Bar")
                        .font(.system(size: size, weight: .thin))
                }
            }
            
            Button(action:{
                    self.pie.toggle()
                self.bar = false
                self.straight = false
                self.curved = false
                self.showMenu.toggle()
            })
            {
                VStack(spacing: 8) {

                            AccessoryView(image: Image(systemName: "chart.pie"))
                                .frame(width: width, height: width)

                    Text("Pie") .font(.system(size: size, weight: .thin))
                    
                }
            }
            
            Spacer(minLength: 125)
            Text("")
            Spacer()
            Text("")
            Spacer()
            Text("")
        }
        .foregroundColor(self.colorScheme == .dark ? .lairWhite : .lairDarkGray)
        .background(Color.white).edgesIgnoringSafeArea(.bottom)
        .frame(width:50)
    }
}


struct LeadingMenu : View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State var rwidth: CGFloat = 50
    @State var width: CGFloat = 50
    @State var size: CGFloat = 10
    @Binding var symptoms: Bool
    @Binding var meds: Bool
    @Binding var liquide: Bool
    @Binding var showMenu2: Bool
    var body: some View {
        
        VStack(spacing: 25) {
            
            
           Spacer(minLength: 60)
            Button(action:{
                self.symptoms = true
                self.meds = false
                self.liquide = false
                self.showMenu2.toggle()
            })
            {
                VStack(spacing: 8) {
                            AccessoryView(image: Image(systemName: "cross"))
                                .frame(width: width, height: width)
                    Text("Symptoms")
                        .font(.system(size: size, weight: .thin))
                }
            }.buttonStyle(BorderlessButtonStyle())
            

            Button(action:{
                self.meds = true
                self.symptoms = false
                self.liquide = false
                self.showMenu2.toggle()
            })
            {
                VStack(spacing: 8) {

                            AccessoryView(image: Image(systemName: "pills"))
                                .frame(width: width, height: width)

                    Text("Meds")
                        .font(.system(size: size, weight: .thin))
                }
            }.buttonStyle(BorderlessButtonStyle())
                
                
            
            Button(action:{
                    self.liquide = true
                self.meds = false
                self.symptoms = false
                self.showMenu2.toggle()
                
            })
            {
                VStack(spacing: 8) {

                            AccessoryView(image: Image(systemName: "drop"))
                                .frame(width: width, height: width)

                    Text("Liquids")
                        .font(.system(size: size, weight: .thin))
                }
            }.buttonStyle(BorderlessButtonStyle())
            Spacer()
            Spacer(minLength: 125)
            Text("")
            Spacer()
           
            
            
        }
        .foregroundColor(self.colorScheme == .dark ? .lairWhite : .lairDarkGray)
        .background(Color.white).edgesIgnoringSafeArea(.all)
        .frame(width:50)
    }
}
