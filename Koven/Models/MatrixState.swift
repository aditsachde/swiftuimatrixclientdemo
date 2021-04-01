//
//  KMatrixSession.swift
//  Koven
//
//  Created by Adit Sachde on 1/12/21.
//
import SwiftUI
import MatrixSDK

class MatrixState: ObservableObject {
    var session: MXSession
    var client: MXRestClient
    private var delegate: MatrixAuth? = nil
    
    init(session: MXSession, client: MXRestClient) {
        self.session = session
        self.client = client
    }
    
    func setDelegate(_ delegate: MatrixAuth) {
        self.delegate = delegate
    }
    
    func logout() -> Bool {
        guard delegate != nil else {
            return false
        }
        self.delegate!.logout()
        return true
    }
}
