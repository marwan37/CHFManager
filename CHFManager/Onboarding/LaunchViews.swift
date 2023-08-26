//
//  GifController.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2021-01-02.
//

import SwiftUI
import WebKit

struct OnboardingView: View {
    @State var tapped = 0
    var advHF = ["Exercise intolerance", "Unintentional weight loss", "Arrhythmias", "Hypotension" ]
    var symptoms = ["Dyspnea", "Fatigue", "Swelling", "Exercise Intolerance"]
    let cols = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack{
            Color.lairBackgroundGray.edgesIgnoringSafeArea(.all)
            
            
            VStack{
                ScrollView {
                    Text("What is Heart Failure?")
                        .font(.system(size: 30, weight: .thin, design: .rounded))
                        .foregroundColor(.neonRed)
                    
                    Text("Heart failure occurs when your heart isn’t pumping as well as it should be. This means you may feel tired or short of breath because your heart can’t deliver enough oxygen and nutrients to your body. Heart failure can also cause fluid to build up in your lungs and in other places, like your ankles.\n\nHeart failure is a serious condition with no cure. Learning you have heart failure can feel scary, and living with heart failure can be hard on you and your family and caregivers, both physically and emotionally.")
                        .font(.system(size: 16, weight: .thin, design: .rounded))
                        .padding()
                    
                    
                    
                }
            }
        }
    }
    
}



struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct WebView: UIViewRepresentable {
    
//    let request: URLRequest
    var url: URL?
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = url else {
        return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
        
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.load(request)
    }
    
    
}


//When severe symptoms begin to interfere with daily life despite maximum evidence-based medical therapy, patients are described as having advanced or refractory heart failure.

/*
 Text("Signs & Symptoms")
     .font(.system(size: 23, weight: .thin, design: .rounded))
     .foregroundColor(.neonRed)
 
 LazyVGrid(columns: cols){
     VStack(alignment: .leading){
         Text("Heart Failure")
             .font(.system(size: 22, weight: .thin, design: .rounded))
             .foregroundColor(.darkRed)
             ForEach(symptoms.indices) {index in
                 Text("❍ \(symptoms[index])")
                     .font(.system(size: 16, weight: .thin, design: .rounded))
             }
         }
     
     VStack(alignment: .leading){
         
         Text("Advanced HF")
             .font(.system(size: 22, weight: .thin, design: .rounded))
             .foregroundColor(.darkRed)
             
             ForEach(advHF.indices) {index in
                 Text("❍ \(advHF[index])")
                     .font(.system(size: 16, weight: .thin, design: .rounded))
             }
         }
     }
     
 
ZStack{

 WebView(url: "http://128.100.190.12/heartfailure/wp-content/uploads/reduced-ejection-fraction.gif")
     .clipShape(CustomShape())
     .isHidden(tapped != 1)
 
 WebView(url: "http://128.100.190.12/heartfailure/wp-content/uploads/normal-ejction-fraction.gif")
     .clipShape(CustomShape())
     .isHidden(tapped != 0)
}.frame(minWidth: UIScreen.main.bounds.width, minHeight: 420, maxHeight: 600)
 
 */
