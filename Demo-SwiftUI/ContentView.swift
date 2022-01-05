//
//  ContentView.swift
//  Demo
//
//  Created by Matthew Knippen on 12/7/21.
//

import SwiftUI
import Forethought

struct ContentView: View {
    @State var isForethoughtPresented = false
    
    var body: some View {
        Button("Get Support") {
            isForethoughtPresented.toggle()
        }
            .fullScreenCover(isPresented: $isForethoughtPresented) { ForethoughtContainerViewController()
        }
        
    }
    
    /*
    var body: some View {
        NavigationView {
            NavigationLink("Get Help", destination: ForethoughtContainerViewController())
                .navigationTitle("Sample SwiftUI App")
        }
 }*/
    
    public init() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
