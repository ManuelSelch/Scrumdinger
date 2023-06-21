//
//  ThemePicker.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 20.06.23.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        /*
         You can use the constant(_:) type method to create a binding to a hard-coded, immutable value.
         Constant bindings are useful in previews or when prototyping your app’s user interface.
         */
        ThemePicker(selection: .constant(.periwinkle))
    }
}
