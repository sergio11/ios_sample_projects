//
//  HeaderView.swift
//  Honeymoon
//
//  Created by Sergio Sánchez Sánchez on 27/12/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            
            Button(action: {
                print("Information")
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(Color.primary)
            
            Spacer()
        
            Image("logo-honeymoon-pink")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            
            Spacer()
            
            Button(action: {
                print("Guide")
            }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(Color.primary)
            
        }.padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.fixed(width: 375, height: 80))
    }
}
