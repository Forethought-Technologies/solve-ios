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
        VStack(spacing: 50) {
            Image("forethoughtLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 220)
            
            Button {
                ForethoughtSDK.show()
            } label: {
                ZStack {
                    Image("button")
                    Text("Contact Support")
                        .foregroundColor(.white)
                }
            }
            Spacer()
                .frame(height: 100)
            Image("poweredBy")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 100)

        }
        

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
