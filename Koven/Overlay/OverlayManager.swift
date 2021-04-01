//
//  OverlayManager.swift
//  Koven
//
//  Created by Adit Sachde on 1/24/21.
//

import SwiftUI

struct OverlayManager<Content: View>: View {
    @StateObject var dataSource = OverlayManagerDataSource()
    @State var overlayActive = true
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if overlayActive {
                OverlayView(overlayActive: $overlayActive) {
                    Text("Test")
                }
            }
            
            Button(action: {
                withAnimation {
                    overlayActive.toggle()
                }
            }, label: {
                Text("Button")
            }).zIndex(2)
            
            self.content.opacity(overlayActive ? 0.5 : 1).zIndex(0)
        }
    }
}
