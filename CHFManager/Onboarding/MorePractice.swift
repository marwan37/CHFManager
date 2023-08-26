//
//  MorePractice.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-11.
//

import SwiftUI
import PartialSheet



struct Beverages: View {
    @Environment(\.colorScheme) var cs
    private var gridItemLayout = [GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70)), GridItem(.adaptive(minimum: 70)),GridItem(.adaptive(minimum: 70)) ]
    private var beverage = ["Water Glass", "Milk", "Coffee", "Water Bottle", "Capuccino", "Juice Carton", "Yogurt", "Beer Pint", "Juice Bottle", "Beer Can", "Soda Bottle", "Smoothie", "Soda Can", "Tea"]
    private var foods = ["Apple", "Avocado", "Banana", "Watermelon", "32 Grapes", "Popsicle", "Ice Cream Cone", "Orange", "Peach", "Grapefruit", "1/3 Pineapple", "Pomegrenate","Pear",  "Soup Bowl","Pudding"]
    @State var show = 0
    private var sizes = [8,8,12,16,6,4, 8, 16, 10, 12, 20, 12, 16, 8, 8]
    private var foodSize = [4,6,4,6,4,5,4,4,6,8,8,8,4,12,6]
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack{
            Picker("", selection:$show) {
                Text("Liquids").tag(0)
                Text("Solids").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)
        ZStack{

            BooZ.isHidden(self.show != 0)
            FooD.isHidden(self.show != 1)
                
            }.padding(.vertical)
        }.padding(.bottom,50)
    }
          
        
    var BooZ : some View {
        
      
            
            LazyVGrid(columns: gridItemLayout, alignment:.center, spacing: 20) {
                ForEach(beverage.indices) { i in
                    
                    VStack{
                        Image("bev\(i+1)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                            .offset(y: (i == 4 || i == 13 ) ? 15 : 0)
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
                        Text(beverage[i])
                        Text("\(sizes[i])oz")
                    }.font(.system(size: 14, weight: .regular, design: .rounded))
                }
                
            }
            .foregroundColor(Color.textColor(for: cs))
            
        
    }
    var FooD : some View {
        LazyVGrid(columns: gridItemLayout, alignment:.center, spacing: 20) {
            ForEach(foods.indices) { i in
                VStack{
                    Image("food\(i+1)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: i == 9 ? 120 : 70, height: i == 9 ? 120 : 70)
                        .offset(y: i == 9 ? 5 : 0)
                        .cornerRadius(10)
                      
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
                    Text(foods[i]) .offset(y: i == 9 ? -24 : 0)
                    Text("\(foodSize[i])oz") .offset(y: i == 9 ? -24 : 0)
                } .font(.system(size: 14, weight: .regular, design: .rounded))
                
            }.foregroundColor(Color.textColor(for: cs))
           
        }
    }
}




//struct MorePractice: View {
//    @Environment(\.colorScheme) var cs
//    private var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
//    private var symbols = ["questionnaire", "dailyCompletion", "settings"]
//    private var colors: [Color] = [.yellow, .purple, .green, .white]
//    @Environment(\.managedObjectContext) var moc
//    @State var size : CGFloat = 50
//    var body: some View {
//
//        VStack(alignment:.leading,spacing: 20) {
//
//            Divider()
//            NavigationLink(destination:
//                            NYHAView()
//                            .environment(\.managedObjectContext, self.moc))
//            {
//                HStack{
//                Image(systemName: "heart.text.square")
//                    .font(.system(size: 30))
//                    .frame(width: size, height: size)
//                    .background(colors[3]).opacity(0.7)
//                    .shadow(color: cs == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6), radius: 2, x: -2, y: -3)
//                    .cornerRadius(10)
//
//
//                Text("Daily Completion Log")
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                }
//            }
//            Divider()
//            NavigationLink(destination:
//                            ListView().environment(\.managedObjectContext, self.moc))
//            {
//                HStack{
//                Image(systemName: "star.circle")
//                    .font(.system(size: 30))
//                    .frame(width: size, height: size)
//                    .background(colors[3]).opacity(0.7)
//
//                    .shadow(color: cs == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6), radius: 2, x: -2, y: -3)
//                    .cornerRadius(10)
//
//
//                Text("Questionnaires/Scores")
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                }
//            }
//            Divider()
//            NavigationLink(destination:
//                            Home().environmentObject(PartialSheetManager()))
//            {
//                HStack{
//                Image(systemName: "gear")
//                    .font(.system(size: 30))
//                    .frame(width: size, height: size)
//                    .background(colors[3]).opacity(0.7)
//                    .shadow(color: cs == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6), radius: 2, x: -2, y: -3)
//                    .cornerRadius(10)
//
//
//
//                    Text("Account Setttings")
//                    Spacer()
//                    Image(systemName: "chevron.right")
//            }
//            }
//            Divider()
//        }.foregroundColor(Color.textColor(for: cs))
//        .font(.system(size: 15, weight:.light, design: .monospaced))
//        .padding(.horizontal, 30)
//    }
//}

//struct MorePractice_Previews: PreviewProvider {
//    static var previews: some View {
//        MorePractice()
//    }
//}

struct FluidNumbers : View {
    private var sizes = [2,4,6,8]
    @State var tapped = 3
   
  @State private var sel = 0
    var body: some View {
        LazyHGrid(rows: [GridItem(.flexible())]){
            ForEach(0..<sizes.count){ i in
                Button(action:{
                    self.tapped = i
                })
                {
                Image(systemName: "\(sizes[i]).square.fill")
                    .font(.system(size: 40))
                    .frame(width: 50, height: 50)
                    .foregroundColor(self.tapped == i ? .lightGray : .white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(self.tapped == i ? 0 : 0.6), radius: 2, x: -2, y: -2)
                }
            }
        }
    }
}
