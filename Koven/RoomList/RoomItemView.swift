//
//  RoomItemView.swift
//  Koven
//
//  Created by Adit Sachde on 1/14/21.
//

import SwiftUI
import SDWebImageSwiftUI
import MatrixSDK

struct RoomItemView: View {
    @Binding var roomSummary: MXRoomSummary

    var body: some View {
        HStack {
            image
                .frame(width: 60, height: 60, alignment: .center)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .padding(5)
            VStack(alignment: .leading) {
                HStack {
                    Text(roomSummary.displayname).bold().lineLimit(1)
                    Spacer()
                    Text(String(roomSummary.lastMessageOriginServerTs)).lineLimit(1)
                    //Image(systemName: "chevron.right")
                }
                Text(roomSummary.lastMessageString ?? "unknown").lineLimit(2)
                Spacer()
            }
            Spacer()
        }
        
        //.fixedSize(horizontal: false, vertical: true)
        //.background(Color.black.opacity(0.3))
    }
    
    // Adapted From NIO
    var image: some View {
                
        if let avatarURL = self.roomSummary.avatarURL {
            return AnyView(
                WebImage(url: avatarURL)
                    .resizable()
                    .placeholder { prefixAvatar }
                    .aspectRatio(contentMode: .fill)
            )
        } else {
            return AnyView(
                prefixAvatar
            )
        }
    }
    
    // Adapted From NIO
    var gradient: LinearGradient {
        let color: Color = .white
        let colors = [color.opacity(0.3), color.opacity(0.0)]
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // Adapted From NIO
    var prefixAvatar: some View {
        GeometryReader { geometry in
            Text(self.roomSummary.displayname.prefix(2).uppercased())
                .multilineTextAlignment(.center)
                .font(.system(.headline, design: .rounded))
                .lineLimit(1)
                .allowsTightening(true)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .foregroundColor(.init(UIColor(.black)))
                .background(
                    Color.accentColor.overlay(gradient)
                )
        }
        .accessibility(addTraits: .isImage)
    }
}

/*
struct RoomItemView_Preview: PreviewProvider {        
    static var previews: some View {
        RoomItemView()//.previewLayout(PreviewLayout.sizeThatFits)
    }
}*/
