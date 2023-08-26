//
//  TransitionView.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-02-02.
//

import SwiftUI

struct TransitionView: View {
    @ObservedObject var data = DayData()
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        VStack(spacing:15){
          
            Text("Successfully saved entry!")
                .font(.system(size: 20, weight: .semibold, design: .rounded))

            HStack{
            Text("Medication Compliance:")
                let comp = data.howMany.rounded()
                Text(data.rxCount > 0 ? "\(Int((comp/data.rxCount)*100))%" : "")
               
                
            } .font(.system(size: 18, weight: .light, design: .rounded))
            
                VStack{
                    Text("Swelling: \(data.swelling > 0 ? "Yes" : "No")")
                    Text("Dyspnea: \(data.dyspnea > 0 ? "Yes" : "No")")
                    Text("Fatigue: \(data.fatigue > 0 ? "Yes" : "No")")
                }.font(.system(size: 18, weight: .light, design: .rounded))
            
            NavigationLink(destination: MasterCalendarTabView(pushed: .constant(true))
                            .environmentObject(DayData())
                            .environment(\.managedObjectContext, self.moc)
                            .navigationTitle("")
                            .navigationBarHidden(true)) {
                Text("Go back to calendar")
            }
        } .font(.system(size: 14, weight: .light, design: .rounded))
    }
}

struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}
