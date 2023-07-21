//
//  DeviceOverview.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import SwiftUI

struct DeviceOverview: View {
    @ObservedObject var viewState: ViewStateHandler
    var device: Device
    
    var body: some View {
        Text("Device Overview")
    }
}

struct DeviceOverview_Previews: PreviewProvider {
    static var previews: some View {
        DeviceOverview(viewState: ViewStateHandler(), device: Device.sampleData[0])
    }
}
