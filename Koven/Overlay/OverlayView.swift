//
//  OverlayView.swift
//  Koven
//
//  Created by Adit Sachde on 1/24/21.
//

import SwiftUI

struct OverlayView<Content: View>: View {
    @Binding var overlayActive: Bool
    @State private var offset = CGSize.zero
    let content: Content
    
    init(overlayActive: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._overlayActive = overlayActive
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            
            Rectangle()
                .fill(Color.blue)
                .cornerRadius(35)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: 350)
                .offset(x: 0, y: max(offset.height, -100))
                .gesture(self.gesture)
                .animation(.spring())
                .zIndex(0)
            
            
            content
                .cornerRadius(35)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: 350)
                .offset(x: 0, y: max(offset.height, -100))
                .gesture(self.gesture)
                .animation(.spring())
                .zIndex(1)
            
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.001)
                //.grayscale(0.65)
                .gesture(self.gesture)
                .animation(.spring())
                .zIndex(-1)
                .onTapGesture {
                    return
                }
        }
        .zIndex(1)
        .transition(.move(edge: .bottom))
    }
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                self.offset = gesture.translation
            }
            
            .onEnded { _ in
                if self.offset.height > 200 {
                    self.offset = .zero
                    withAnimation {
                        self.overlayActive = false
                    }
                } else {
                    self.offset = .zero
                }
            }
    }
}
