//
//  ScrumsView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 19.06.23.
//

import SwiftUI


struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: HomeView(scrums: $scrums)) {
                    Label("Home", systemImage: "house.fill")
                }
                NavigationLink(destination: DetailView(scrum: .constant(DailyScrum.sampleData[0]))) {
                    Label("Connect", systemImage: "gear")
                }
                NavigationLink(destination: RefactorView()) {
                    Label("Refactor", systemImage: "eyeglasses")
                }
            }
            .navigationTitle("Learn")
            
            HomeView(scrums: $scrums)
            
            
            
        }
    }
}

struct HomeView: View {
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingAddView = false
    @State private var addScrum = DailyScrum.emptyScrum
    
    @StateObject private var mqtt = MQTTManager()
    
    
    var body: some View {
            VStack {
                if mqtt.isConnected {
                    Text("Connected to MQTT broker")
                        .foregroundColor(.green)
                } else {
                    Text("Disconnected from MQTT broker")
                        .foregroundColor(.red)
                }
                
                if mqtt.isSubscribed {
                    Button(action: {
                        mqtt.unsubscribeFromTopic("python/mqtt")
                    }, label: {
                        Text("Unubscribe from Topic")
                    })
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                } else {
                    Button(action: {
                        mqtt.subscribeToTopic("python/mqtt")
                    }, label: {
                        Text("Subscribe to Topic")
                    })
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                
                Button(action: {
                    mqtt.publish(topic: "servo", message: "10")
                }, label: {
                    Text("+10")
                })
                .padding()
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                Button("-10") {
                    mqtt.publish(topic: "servo", message: "-10")
                }
                .padding()
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                
                
                
                
                
                Text(mqtt.receivedMessage)
                    .padding()
                    .multilineTextAlignment(.center)
                
                
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





