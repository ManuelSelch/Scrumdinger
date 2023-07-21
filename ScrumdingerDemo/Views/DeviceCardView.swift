//
//  DeviceCardView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import SwiftUI

struct DeviceCardView: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(device.title)
                .font(.headline)
        }
        .padding()
        .foregroundColor(device.theme.accentColor)
    }
}

struct DeviceCardView_Previews: PreviewProvider {
    static var device = Device.sampleData[0]
        static var previews: some View {
            DeviceCardView(device: device)
                .background(device.theme.mainColor)
                .previewLayout(.fixed(width: 400, height: 60))
        }
}
