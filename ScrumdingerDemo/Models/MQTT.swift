//
//  MQTT.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 30.06.23.
//

import Foundation
import CocoaMQTT

class MQTTManager: ObservableObject {
    var sharedData: SharedData
    
    @Published var isConnected = false
    @Published var isSubscribed = false
    @Published var receivedMessage: String = ""

    private var mqtt: CocoaMQTT!

    init(sharedData: SharedData) {
        self.sharedData = sharedData
        
        mqtt = CocoaMQTT(clientID: "yourClientID", host: "manuel.feste-ip.net", port: 38839)
        mqtt.username = "root"
        mqtt.password = "1Ter6esai#Qabc"
        mqtt.keepAlive = 60
        mqtt.delegate = self
    }

    func connect() {
        print(mqtt.connect())
    }

    func disconnect() {
        mqtt.disconnect()
    }
    
    func subscribeToTopic(_ topic: String) {
        mqtt.subscribe(topic)
    }
    
    func unsubscribeFromTopic(_ topic: String) {
        mqtt.unsubscribe(topic)
    }
    
    func publish(topic: String, message: String) {
        mqtt.publish(topic, withString: message)
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        isConnected = true
        print("Connected to MQTT broker")
        // Additional actions after successful connection
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            isConnected = true
            print("Connected to MQTT broker")
            // Additional actions after successful connection
        } else {
            isConnected = false
            print("Unable to connect to MQTT broker")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message published: \(message.string ?? "")")
        // Additional actions after message publishing
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishMessage:")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("Message received: \(message.string ?? "")")
        DispatchQueue.main.async {
            self.receivedMessage = message.string ?? ""
            
            if(message.topic == "server/response/deviceData"){
                self.sharedData.devices = Device.sampleData02
            }else{
                self.sharedData.devices = Device.sampleData02
            }
        }
        // Additional actions after message received
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        DispatchQueue.main.async {
            self.isSubscribed = true
        }
        print("didSubscribeTopics")
        // Additional actions after subscription
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        DispatchQueue.main.async {
            self.isSubscribed = false
        }

        print("Unsubscribed from topic: \(topic)")
        // Additional actions after unsubscription
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        isConnected = false
        print("Disconnected from MQTT broker: \(err?.localizedDescription ?? "")")
        // Additional actions after disconnection
    }

    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Subscribed to topic: \(topic)")
        // Additional actions after subscription
    }
    

    

    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topic: [String]) {
        print("Unsubscribed from topic: \(topic)")
        // Additional actions after unsubscription
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        // Handle SSL/TLS security if required
        // Set completionHandler to true or false based on trust validation
        completionHandler(true)
    }
}
