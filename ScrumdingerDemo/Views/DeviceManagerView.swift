//
//  DeviceManagerView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import SwiftUI

struct DeviceManagerView: View {
    @ObservedObject var viewState: ViewStateHandler
    @EnvironmentObject var sharedData: SharedData
    
    
    let itemsString = "Item 1, Item 2, Item 3, Item 4, Item 5"
    let delimiter = ", "
    
    
    var body: some View {
        List(sharedData.devices) { device in
            Button(action: {
                viewState.state = .deviceOverview
            }) {
                DeviceCardView(device: device)
                    .listRowBackground(device.theme.mainColor)
            }
            
        }
    }
    
    var devicesArray: [Device] {
        do {
            let jsonData = itemsString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let devices = try decoder.decode([Device].self, from: jsonData)
            return devices
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceManagerView(viewState: ViewStateHandler())
    }
}
