//
//  ContentView.swift
//  Honeymoon
//
//  Created by Sergio Sánchez Sánchez on 27/12/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    @State var showAlert: Bool = false
    @State var showGuide: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(showGuideView: $showGuide)
            Spacer()
            CardView(honeymoon: honeymoonData[2])
                .padding()
            Spacer()
            FooterView(showBookingAlert: $showAlert)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("SUCCESS"),
                message: Text("Whishing a lovely and most precious of the times together for the amazing couple."),
                dismissButton: .default(Text("Happy Honeymoon!"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
