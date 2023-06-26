//
//  ScrumsView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 19.06.23.
//

import SwiftUI
import CocoaMQTT


struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingAddView = false
    @State private var addScrum = DailyScrum.emptyScrum
    
    @StateObject private var mqtt = MQTTManager()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if mqtt.isConnected {
                    Text("Connected to MQTT broker")
                        .foregroundColor(.green)
                } else {
                    Text("Disconnected from MQTT broker")
                        .foregroundColor(.red)
                }
                
                
                List($scrums) { $scrum in
                    NavigationLink(destination: DetailView(scrum: $scrum)) {
                        CardView(scrum: scrum)
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .toolbar {
                    Button(action: {
                        isPresentingAddView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $isPresentingAddView) {
                    NavigationStack {
                        DetailEditView(scrum: $addScrum)
                            .navigationTitle($addScrum.title)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel") {
                                        isPresentingAddView = false
                                    }
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done") {
                                        isPresentingAddView = false
                                        scrums.append(addScrum)
                                        addScrum = DailyScrum.emptyScrum
                                    }
                                }
                            }
                    }
                }
            }
            .onAppear {
                mqtt.connect()
            }
            .onDisappear {
                mqtt.disconnect()
            }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData))
    }
}



class MQTTManager: ObservableObject {
    @Published var isConnected = false

    private var mqtt: CocoaMQTT!

    init() {
        mqtt = CocoaMQTT(clientID: "yourClientID", host: "manuelselch.ddns.net", port: 100)
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
        // Additional actions after message received
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("didSubscribeTopics")
        // Additional actions after subscription
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
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

