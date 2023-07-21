//
//  Device.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import Foundation

struct Device: Identifiable, Codable {
    let id: UUID
    
    var title: String
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, theme: Theme) {
        self.id = id
        self.title = title
        self.theme = theme
    }
}

extension Device {
    static var emptyDevice: Device {
        Device(title: "", theme: .sky)
    }
}

extension Device {
    static let sampleData: [Device] =
    [
        Device(title: "Device 01",
                   theme: .yellow),
        Device(title: "Device 02",
                   theme: .orange),
        Device(title: "Device 03",
                   theme: .poppy)
    ]
    static let sampleData02: [Device] =
    [
        Device(title: "Device 11",
                   theme: .yellow),
        Device(title: "Device 12",
                   theme: .orange),
        Device(title: "Device 13",
                   theme: .poppy)
    ]
}

