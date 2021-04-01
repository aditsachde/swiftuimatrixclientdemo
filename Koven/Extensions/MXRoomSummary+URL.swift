//
//  MXRoomSummary+URL.swift
//  Koven
//
//  Created by Adit Sachde on 1/21/21.
//

import MatrixSDK

extension MXRoomSummary {
    var avatarURL: URL? {
        guard let avatar = self.avatar else { return nil }
        guard let mxUri = URL(string: avatar) else { return nil }
        guard let homeserver = self.mxSession.credentials.homeServer else { return nil }
        guard let host = mxUri.host else { return nil }
        let path = "/_matrix/media/r0/download/\(host)/\(mxUri.lastPathComponent)"
        return URL(string: "\(homeserver)\(path)")
    }
}
