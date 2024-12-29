//
//  TitleModifier.swift
//  Honeymoon
//
//  Created by Sergio Sánchez Sánchez on 29/12/24.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.pink)
    }
}
