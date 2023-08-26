import SwiftUI


struct TabButton : View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Binding var selected : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View{
        
        Button(action: {
            
            withAnimation(.spring()){
                
                selected = title
            }
            
        }) {
            
            ZStack{
                
                // Capsule And Sliding Effect...
                
                Capsule()
                    .fill(Color.clear)
                    .frame(height: 35)
                if selected == title{
                    
                    Capsule()
                        .fill(self.colorScheme == .dark ? Color.white : Color.offWhite)
                        .frame(height: 35)
                    // Mathced Geometry Effect...
                        .matchedGeometryEffect(id: "Tab", in: animation)
                       
                }
                
                Text(title)
                    .foregroundColor(self.colorScheme == .dark ? (selected == title ? .black : .white) : (selected == title ? .white : .gray))
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
    }
}

struct AccessoryViews: View {
  let uuid = UUID()
  var title: String
  var image: String
    var data: [Double]
    var points: [Double] = [8,23,54,32,12,37,7,23,43]
    let chartStyle: ChartStyle
    let chartStyle1 = ChartStyle(
        backgroundColor: Color.clear,
        accentColor: Color.neonBlue,
        secondGradientColor: Color.neonBlue,
        textColor: Color.blue,
        legendTextColor: Color.white, dropShadowColor: .blue )
    
  var body: some View {
    ZStack {
      LinearGradient.lairHorizontalLight
        .frame(width: 240, height: 0)
        .padding(40)
        .font(.system(size: 150, weight: .thin))
        .shadow(color: .white, radius: 2, x: -3, y: -3)
        .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
        BarChartView(data: ChartData(points: data), title: title, style: chartStyle, form: ChartForm.extraLarge, cornerImage: Image(systemName: image))
//        Text("January").foregroundColor(.black).opacity(0.1)

    }
    .frame(width: 370, height: 300)
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 2)
    )
      .background(Color.lairBackgroundGray)
      .cornerRadius(20)
      .shadow(color: Color(white: 1.0).opacity(0.9), radius: 18, x: -18, y: -18)
      .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 14, x: 14, y: 14)
  }
}

struct AccessoryRowView: View {
  var items: [AccessoryViews]
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(items, id: \.uuid) { accessory in
          accessory.padding(.horizontal, 30)
        }
      }
      .padding(.top, 32)
      .padding(.bottom, 38)
    }
  }
}

struct AccessoryRowView_Previews: PreviewProvider {
   
  static var previews: some View {
    AccessoryRowView(items: [
        AccessoryViews(title: "Control Room", image: "lightbulb", data: poinchartats, chartStyle: chartStyle1),
        AccessoryViews(title: "Dungeon", image: "lock.shield", data: poinchartats, chartStyle: chartStyle1),
        AccessoryViews(title: "Laser", image:"scope", data: poinchartats, chartStyle: chartStyle1),
        AccessoryViews(title: "Periscope", image: "eye", data: poinchartats, chartStyle: chartStyle1)
    ])
  }
}
var poinchartats: [Double] = [8,23,54,32,12,37,7,23,43]
let chartStyle1 = ChartStyle(
    backgroundColor: Color.clear,
    accentColor: Color.neonBlue,
    secondGradientColor: Color.neonBlue,
    textColor: Color.blue,
    legendTextColor: Color.white, dropShadowColor: .blue )

let chartStyle2 = ChartStyle(
    backgroundColor: Color.clear,
    accentColor: Color.neonOrange,
    secondGradientColor: Color.neonOrange,
    textColor: Color.orange,
    legendTextColor: Color.white, dropShadowColor: .orange )
