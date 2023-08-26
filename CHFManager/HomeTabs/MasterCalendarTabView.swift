//
//  MasterCalendarTabView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-24.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    var url: URL
    var body: some View {
        PDFKitRepresentedView(url)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
struct MasterCalendarTabView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var cs
    @State var sel = 0
    @Binding var pushed: Bool
    var body: some View {
        TabView{
            
            MasterCalendarView()
                            .environmentObject(DayData())
                            .environment(\.managedObjectContext, self.moc)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "calendar")
                }
            
            ListView()
                .environmentObject(DayData())
                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "heart.text.square")
                }
            
            DailyCompInfo()
                .tabItem { Image(systemName: "info") }
                .navigationTitle("")
                .navigationBarHidden(true)
                .modifier(TPMod())
        }
    }
}

struct MasterCalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
//        MasterCalendarTabView(pushed: .constant(true))
        DailyCompInfo()
    }
}

struct DailyCompInfo : View {
    @Environment(\.colorScheme) var cs
    let fileUrl = Bundle.main.url(forResource: "CHFSymptomTracker", withExtension: "pdf")!
    @State var showPDF = false
    var body: some View {
        GeometryReader { geo in
            ZStack{
                LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    
        VStack(alignment:.leading,spacing: 10){
           
                (Text("daily ").bold() + Text("completion"))
               
                .opacity(0.7)
                .font(.system(size: 20, weight: .thin, design: .rounded))

            VStack(alignment:.leading, spacing: 10){
                Text("goal").fontWeight(.semibold)
                    .opacity(0.7)
                    .font(.system(size: 14, weight: .light, design: .rounded))
                .font(.system(size: 15, weight: .light, design: .rounded))
                Text("track symptom progression and medication compliance")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 13, weight: .light, design: .rounded))
            }.opacity(0.7)
            .padding(.top, 10)
            VStack(alignment:.leading, spacing: 10){
                Text("benefits of tracking").fontWeight(.semibold)
                    .opacity(0.7)
                    .font(.system(size: 14, weight: .light, design: .rounded))
                .font(.system(size: 15, weight: .light, design: .rounded))
                Text("when you’re aware of the changes, you're more likely to take action and make the small changes in your lifestyle that can help you live your longest and healthiest life.")
                    .font(.system(size: 13, weight: .light, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                
            }.opacity(0.7)
            .padding(.top, 10)

            GeometryReader {  g in
                HStack{
            Image("calb")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: g.size.width / 2)
                Image("calx")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: g.size.width / 2)
                }
            }.frame(height: 200)
            .padding(.top, 10)
            VStack(alignment:.leading, spacing: 10){
                Text("how does it work?").fontWeight(.semibold)
                    .opacity(0.7)
               
                .font(.system(size: 15, weight: .light, design: .rounded))
                Text("each day on the calendar is tappable and will open up a short form to complete. Blue/Red indicates the current date. An 'X' mark means you have successfully logged and saved an entry for the day.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 13, weight: .light, design: .rounded))
            }.opacity(0.7) .font(.system(size: 14, weight: .light, design: .rounded))
          

            VStack(alignment:.leading, spacing: 10){
                Text("what if my symptoms change?").fontWeight(.semibold)
                    .opacity(0.7)
                Text("consult the PDF below by the AHA for more information on what signs to look for and when you should consider calling your physician.")
                    .fixedSize(horizontal: false, vertical: true)
                   
                
          Button(action: {
                self.showPDF.toggle()
                   }) {
                       Image("ahacheck")
                        .resizable().aspectRatio(contentMode: .fit)
          }.buttonStyle(ButtonModifier())
          .sheet(isPresented: $showPDF) {
                PDFKitView(url: self.fileUrl)
            }
//          .padding()
          .padding(.top, 10)
            }.opacity(0.7) .font(.system(size: 14, weight: .light, design: .rounded)) .padding(.top, 20)
            
        }  .font(.system(size: 16, weight: .light, design: .rounded))
        
        .foregroundColor(Color.textColor(for: cs))
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .frame(width: ultra - 50)
                }
        
            }.frame(height: geo.size.height)
        }
    }
}
