//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Pixel Mission on 19.06.23.
//

import SwiftUI

struct MeetingView: View {
    var body: some View {
        VStack {
            ProgressView(value: 5, total: 15)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Second Elapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.tophalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)
                    Label("600", systemImage: "hourglass.bottomhalf.fill")
                }
            }
            
            Circle()
                .strokeBorder(lineWidth: 24)
            
            HStack {
                Text("Speaker 1 2 3")
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                }
            }
        }
        
    }
}


struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView()
    }
}
