//
//  ViewStateHandler.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import Foundation

class ViewStateHandler: ObservableObject {
    @Published var state: ViewState = .login
    var sharedData: SharedData = SharedData()
    
    /*init(sharedData: SharedData) {
        self.sharedData = sharedData
    }*/
    

    func login(username: String, password: String) {
        // Replace this logic with your actual authentication
        if username == "user" && password == "password" {
            print("refactor view")
            
            var mqtt = MQTTManager(sharedData: sharedData)
            mqtt.connect()
            mqtt.publish(topic: "server/request", message: "deviceData")
            state = .deviceManager
        } else {
            print("login wrong")
            state = .error(message: "Invalid credentials. Please try again.")
        }
    }

    func logout() {
        // Replace this logic with your logout implementation
        state = .login
    }
}
