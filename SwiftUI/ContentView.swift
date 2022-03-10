//
//  ContentView.swift
//  SwiftUI
//
//  Created by pro on 2022-03-10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(){
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
