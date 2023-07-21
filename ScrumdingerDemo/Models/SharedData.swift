//
//  SharedData.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import Foundation

class SharedData: ObservableObject {
    @Published var devices: [Device] = Device.sampleData
}
