//
//  IndicatorPoint.swift
//  iLineChart
//
//  Created by András Samu on 2019. 09. 03..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI


struct IndicatorPoint: View {
    var indicatorKnob: Color = Color.neonPink
    
    var body: some View {
        ZStack{
            Circle()
                .fill(self.indicatorKnob)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 14, height: 14)
        .shadow(color: Color.lightGray, radius: 6, x: 0, y: 6)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}
