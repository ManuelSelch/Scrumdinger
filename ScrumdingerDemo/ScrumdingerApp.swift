//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Pixel Mission on 19.06.23.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)
            //MeetingView()
        }
    }
}
