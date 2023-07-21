//
//  MainView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 21.07.23.
//

import SwiftUI

struct MainView: View {
    //var sharedData = SharedData()
    @StateObject private var viewState = ViewStateHandler() //sharedData: sharedData)
    
    var body: some View {
        
        Group {
            switch viewState.state {
                case .login:
                    LoginView(viewState: viewState)
                case .deviceManager:
                    DeviceManagerView(viewState: viewState).environmentObject(viewState.sharedData)
                    //LoginView(viewState: viewState)
                case .deviceOverview:
                    //DeviceOverview(viewState: viewState, device: sharedData.devices[0])
                    LoginView(viewState: viewState)
                case .refactor:
                    //RefactorView(viewState: viewState)
                    LoginView(viewState: viewState)
                case .error(message: let message):
                    ErrorView(errorMessage: message, viewState: viewState)
                }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct ErrorView: View {
    let errorMessage: String
    @ObservedObject var viewState: ViewStateHandler

    var body: some View {
        VStack {
            Text(errorMessage)

            Button(action: {
                viewState.state = .login
            }) {
                Text("Retry")
            }
        }
    }
}
