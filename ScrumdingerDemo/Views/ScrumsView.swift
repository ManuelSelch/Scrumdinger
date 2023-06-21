//
//  ScrumsView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 19.06.23.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingAddView = false
    @State private var addScrum = DailyScrum.emptyScrum
    
    var body: some View {
        NavigationStack {
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
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData))
    }
}
