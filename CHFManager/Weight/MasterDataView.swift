//
//  MasterDataView.swift
//  CHFManager
//
//  Created by Deeb Zaarab on 2021-02-02.
//

import SwiftUI
import CoreData

struct MasterDataView: View {
    @Environment(\.colorScheme) private var cs
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(fetchRequest : MasterData.getDayData()) var dayItems:FetchedResults<MasterData>
    var dateFormat = "EEEE, MMM d"

    var circleColor : Color {
        if self.cs == .dark {
            return  Color.neonRed
        } else {
            return Color.red
        }
    }
    var fatColor : Color {
        if self.cs == .dark {
            return  Color.neonBlue
        } else {
            return Color.blue
        }
    }
    var dyspColor : Color {
        if self.cs == .dark {
            return  Color.neonPurple
        } else {
            return Color.purple
        }
    }
    var noFill : Color {
        if self.cs == .dark {
            return  Color.lairWhite
        } else {
            return Color.lairBackgroundGray
        }
    }
    @ObservedObject var wmd = WeightModel()

    @State var dateOG : Date
    @State var date : String
    var body: some View {
        VStack(spacing: 20){
            let day = Int(dateOG.string(format: "d"))
            WeightCalView(weight: Double(wmd.weight) ?? 0, index: day!, monthString: dateOG.string(format: "MMM"))
            DryWeightView(month: dateOG).padding(.trailing, 25)
                .padding(.vertical, 15)
          
 
        }
        
    }
    
  
}

//struct MasterDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        MasterDataView(date: "")
//    }
//}
