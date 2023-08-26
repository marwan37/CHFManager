//
//  Practice.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-11.
//

import SwiftUI
struct WeightTable: View {
  
    @Binding var month : [String?]
    @Binding var weightIndex : [Int]
    @Binding var weight : [Double]
  
    var body: some View {
        
        VStack{
           
         
            ForEach(0..<weight.count, id:\.self) { i in
                    ScrollView(.horizontal, showsIndicators: false){
                      
                            HStack{
                              
                                    HStack{
                                        VStack{
                                            ZStack{
                                            Text("Jan 30").hidden()
                                                Text("\(month[i]!) \(weightIndex[i])")
                                            }
                                            Text("\(weight[i])")
                                                
                                            } .font(.system(size: 12, weight: .light, design: .monospaced))
                                            .foregroundColor(.black)

                                        }
   
                               
                            }
//                            .padding()
                     
                        
                    }.frame(width:UIScreen.main.bounds.width-20)
                    
                    Divider()
                    
                }
            Spacer()
        }
    }
}






struct Practice: View {
    let waterMonthly : [[String]] = [["Jan 3", "Jan 4","Jan 15", "Jan 13", "Jan 23", "Jan 7", "Jan 9", "Jan 10", "Jan 29"], ["Feb 3", "Feb 13", "Feb 23", "Feb 25"]]
   
    let values : [[Int]] = [[32, 32, 42, 42, 52, 64, 42, 52, 64], [48, 16, 24, 16]]
    var body: some View {
        
        VStack{
           
         
                ForEach(waterMonthly.indices) { monthIndex in
                    let sorted = waterMonthly[monthIndex].sorted {$0.localizedStandardCompare($1) == .orderedAscending}
                    ScrollView(.horizontal, showsIndicators: false){
                      
                            HStack{
                                ForEach(waterMonthly[monthIndex].indices, id: \.self) { indexOfValue in
      
                                        
                                    HStack{
                                        VStack{
                                            ZStack{
                                            Text("Jan 30").hidden()
                                            Text(sorted[indexOfValue])
                                            }
                                                Text("\(values[monthIndex][indexOfValue])")
                                                
                                            } .font(.system(size: 12, weight: .light, design: .monospaced))
                                            .foregroundColor(.black)

                                        }
   
                                }
                            }
//                            .padding()
                     
                        
                    }.frame(width:UIScreen.main.bounds.width-20)
                    
                    Divider()
                    
                }
            Spacer()
        }
    }
}

struct Practice_Previews: PreviewProvider {
    static var previews: some View {
        MoreInformation()
    }
}

struct MoreInformation : View {
    @Environment(\.colorScheme) var cs
    let columns4 = [
        GridItem(.adaptive(minimum: 200, maximum: 400)),
        GridItem(.adaptive(minimum: 100, maximum: 200)),
        GridItem(.adaptive(minimum: 100, maximum: 200))
    ]
    let colude = [
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: .infinity)),
    ]
    var body: some View {
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
        
        ScrollView{
        
        VStack(alignment: .leading){
            Text("Tracking Fluids")
                .font(.system(size: 18, weight: .regular, design:.rounded))
            (Text("It is important to keep track of all fluids you have each day so you don’t go over your limit. \n\nYou can track your your daily intake by customizing the configuration in the settings tab. Keep the app handy, and every time you have a fluid, tap the ") + Text(" +").foregroundColor(Color.neonBlue).bold() + Text(" button. When the container fills completely, you have reached your daily fluid limit."))
                .padding(.top, 5)
            Text("At first, you may find it useful to use a measuring cup to see how much fluid your drinking glasses, tea or coffee cup, and soup bowl holds. Knowing how much fluid they hold will help you to plan how much fluid you can drink for the day.\n\nKeep a daily log until you are able to keep track of fluids without measuring.")
                .padding(.top, 5)
            
            //
            HStack{
            Text("Common Sizes for Fluids")
               
                NavigationLink(destination: FluidSizes().navigationTitle("").navigationBarHidden(true)) {
                    
                    Image(systemName: "chevron.right.circle")
                }
            } .font(.system(size: 15, weight: .regular, design:.rounded))
            .padding(.top, 10)
            LazyVGrid(columns: columns4){
             
                 
                VStack(alignment:.leading){
                    Text("Coffee cup")
                    Text("Soup bowl")
                    Text("Juice")
                    Text("Milk carton")
                    Text("Small milk carton")
                    Text("1/2 Ice cream cup")
                    Text("Popsicle")
                  
                                   
                }
                VStack(alignment:.leading){
                    Text("12 oz")
                    Text("12 oz")
                    Text("8  oz")
                    Text("8  oz")
                    Text("4  oz")
                    Text("4  oz")
                    Text("4  oz")
                }
                
                VStack(alignment:.leading){
                    
                    Text("350 cc")
                    Text("350 cc")
                    Text("240 cc")
                    Text("240 cc")
                    Text("120 cc")
                    Text("120 cc")
                    Text("120 cc")
                    
                }
            }
      
            
       
            Text("How to feel less thirsty")
            .font(.system(size: 15, weight: .regular, design:.rounded))
                .padding(.vertical, 10)
//            ZStack{
//                Image("daco")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .opacity(0.3)
//                    .offset(x: 70)
            VStack(alignment:.leading,spacing:20){
                  
                    Text("Brush your teeth more often or, rinse your mouth with water, but do not swallow it. Be sure not to over-brush.")
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Keep your mouth cool and fresh by rinsing with cold mouthwash.")
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Lemon wedges, hard sour candies, chewing gum, breath mints or breath spray may help to keep your mouth from drying out.")
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Add lemon or lime to your water or ice.")
                        .fixedSize(horizontal: false, vertical: true)
                      
                    }
                   
            .padding(.horizontal, 10)
//            }
           
            
            
        }.modifier(TPMod())
//        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .font(.system(size: 14, weight: .light, design: .rounded)).opacity(1)
        .padding(.horizontal)
        .padding(.top, 10)
        .foregroundColor(cs == .light ? .grayText : Color.lairWhite)
        .frame(width: UIScreen.main.bounds.width-20, alignment: .trailing)
//        .offset(x:-5, y: -45)
        }
    }.navigationTitle("")
    }
}

struct ImageInfo : View {
    @State var image : String
    @State var info : String
    var body: some View {
        
        GeometryReader { geo in
            HStack{
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width/7, height: 50)
                Text(info)
                    .font(.system(size: 13, weight: .light, design: .rounded)).opacity(1)
                    .padding(.top, 3)
            }
        
        }
    }
}

struct FluidSizes : View {
    
    var body: some View {
        ZStack{
            Color("ColorNeuro").opacity(0.90).edgesIgnoringSafeArea(.all)
        GeometryReader { geo in
        ScrollView(.vertical){
        
            VStack{
                Image("cup1")
                    
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: 200)
                Image("cup2")
                    
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: 200)
                Image("cup3")
                    
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width, height: 200)
          Image("3-cups")
              
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: geo.size.width, height: 200)
//            Image("containers")
//
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: geo.size.width, height: 250)
            }
         }.padding(.top, 20)
        }
        }
    }
}
