//
//  Sweller.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-14.
//

import SwiftUI

struct Breather: View {
    @Environment(\.colorScheme) var cs
    var body: some View {
        GeometryReader { geo in
        VStack(alignment:.leading){
            Image("pulmedema")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:geo.size.width, height: geo.size.height/3)
               
                .opacity(1)
                .padding(.top, 50)
            Text("Changes in breathing could be a sign of worsening heart failure.").font(.title3)
                .padding(.top, 10)
           
 
            VStack(alignment:.leading, spacing: 20){
                Text("Ask yourself:").padding(.top, 10)
                    .font(.system(size:18, weight:.semibold))
                    Text("1. Can I breathe as well as I usually can?")

                    Text("2. Am I getting out of breath doing things I can normally do without a problem?")

                    Text("3. Am I coughing more than usual?")

                   Text("4. Did I use more pillows than usual to sleep last night?")
             
                }.font(.system(size:18, weight:.regular))
            .padding(.horizontal, 40)
                
            } .padding()
           
        }.foregroundColor(.textColor(for: cs))
        .background(Color.backgroundColor(for: cs)).edgesIgnoringSafeArea(.all)
        
        
    }
}

struct Breather_Previews: PreviewProvider {
    static var previews: some View {
        Fatiguer().preferredColorScheme(.light)
    }
}
let cocos = [GridItem(.adaptive(minimum: 300, maximum: 500)), GridItem(.adaptive(minimum: 80, maximum:120))]
struct Fatiguer: View {
    @Environment(\.colorScheme) var cs
    var body: some View {
        VStack(alignment:.leading, spacing: 20){
                Image("runheartrun")
                    .resizable()
                    .scaledToFit()
            Text("Changes in your ability to do everyday things.")
                  
                Text("Ask yourself:").padding(.top, 10)
                    .font(.system(size:18, weight:.semibold))
                
             
            VStack(alignment:.leading, spacing: 20){
                    
                        Text("1.Can I do all the things I normally do, such as get dressed on my own, make meals, or go for walks?")
                        Text("2. Do I feel dizzy or more tired than usual?")
                        Text("3. Do I have any new symptoms, like pressure or pain in my chest?")
                        Text("4. Does my heartbeat feel strange or irregular?")
                    
                        Text("5. Do I feel like I might pass out?")
                }
                }.font(.system(size:18, weight:.regular))
        .padding()
                
            
      
        .foregroundColor(.textColor(for: cs))
        .background(Color.backgroundColor(for: cs)).edgesIgnoringSafeArea(.all)
    }
}


struct Sweller: View {
    @Environment(\.colorScheme) var cs
    var body: some View {
        
        GeometryReader { geo in
        VStack(alignment:.leading){
            Image("swelling")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:geo.size.width, height: geo.size.height/3)
               
                .opacity(1)
                .padding(.top, 50)
            Text("New or worse swelling?").font(.title3)
                .padding(.top, 10)
           
 
            VStack(alignment:.leading, spacing: 20){
             
                  
                Text("Ask yourself:").padding(.top, 10)
                    .font(.system(size:18, weight:.semibold))
                    Text("1.Are my ankles more swollen than usual?")

                    Text("2. Do my socks or shoes feel tighter?")

                    Text("3. Do my clothes feel tighter at the waist?")

                   Text("4. Do my rings fit more snugly?")
             
                }.font(.system(size:18, weight:.regular))
            .padding(.horizontal, 40)
                
            }
        .padding()
        }.foregroundColor(.textColor(for: cs))
        .background(Color.backgroundColor(for: cs)).edgesIgnoringSafeArea(.all)
        
        
    }
}

struct Weighter : View {
    @Environment(\.colorScheme) var cs
    var body: some View {
        
                VStack{
                    HStack{
                       
                        Text("WEIGHT CHANGES")
                            .font(.system(size:28, weight:.semibold, design:.rounded)).padding(.vertical)
                        Image("scaleKing")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                           
                           
                            .shadow(color: Color.textColor(for: cs), radius: 5, x: -2, y: -1)
                            .opacity(0.65)
                        
                    }
                    ZStack{
                        GeometryReader { geo in
                       
                    
                VStack(alignment: .leading, spacing: 20){
                                
                       
                    Text("Weigh yourself every morning before urinating but before eating. Then ask yourself:")
                          
          
                    Text("Has my weight gone up or down compared to yesterday? If so, by how many pounds?")

                   Text("Has my weight gone up or down compared to a week ago? If so, by how many pounds?")
                 .font(.system(size: 18, weight:.regular, design:.rounded))
                }
              
                }
                    }
                } .foregroundColor(Color.white)
                .padding()
    }
}
