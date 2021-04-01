//
//  AuthViewDataSource.swift
//  Koven
//
//  Created by Adit Sachde on 1/13/21.
//

import SwiftUI
import KeychainAccess
import MatrixSDK

enum LoginState {
    case loggedOut
    case authenticating
    case failure(Error)
    case loggedIn
    case crossSign
}

// Adapted From NIO
class MatrixAuth: ObservableObject {
    @Published var loginState: LoginState = .loggedOut
    private var keychain = Keychain(service: "com.aditsachde.Koven")
    private var fileStore: MXFileStore?
    private var credentials: MXCredentials?
    var client: MXRestClient?
    var session: MXSession?
    var state: MatrixState?
    
    init() {
        //clearKeychain()
        
        guard let credentials = getCredentials() else { return }
        self.loginState = .authenticating
        self.credentials = credentials
        self.sync { result in
            switch result {
            case .failure(let error):
                print("Error on starting session with saved credentials: \(error)")
                self.loginState = .failure(error)
            case .success(let state):
                self.loginState = state
            }
        }
    }
    
    private func getCredentials() -> MXCredentials? {
        print("trying to log in with keychain!")
        guard let userId = keychain["userId"] else {
            return nil
        }
        guard let accessToken = keychain["accessToken"] else {
            return nil
        }
        guard let homeServer = keychain["homeServer"] else {
            return nil
        }
        guard let deviceId = keychain["deviceId"] else {
            return nil
        }
        
        let credentials = MXCredentials(homeServer: homeServer, userId: userId, accessToken: accessToken)
        credentials.deviceId = deviceId
        return credentials
    }
    
    private func sync(completion: @escaping (Result<LoginState, Error>) -> Void) {
        guard let credentials = self.credentials else { return }
        
        let options = MXSDKOptions()
        options.enableCryptoWhenStartingMXSession = true
        
        self.client = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)
        self.session = MXSession(matrixRestClient: self.client!)
        self.state = MatrixState(session: self.session!, client: self.client!)
        self.state!.setDelegate(self)
        
        self.fileStore = MXFileStore()
        
        self.session!.setStore(fileStore!) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                self.session?.start { response in
                    switch response {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success:
                        self.session?.enableCrypto(true, completion: { response in
                            print("loggerlogging crypto \(response.isSuccess)")
                        })
                        completion(.success(.loggedIn))
                    }
                }
            }
        }
    }
    
    
    func login(username: String, password: String, homeserver: URL) {
        
        self.loginState = .authenticating
        
        self.client = MXRestClient(homeServer: homeserver, unrecognizedCertificateHandler: nil)
        
        self.client?.login(username: username, password: password, completion: { response in
            switch response {
            case .failure(let error):
                self.loginState = .failure(error)
            case .success(let credentials):
                self.keychain["userId"] = credentials.userId
                self.keychain["accessToken"] = credentials.accessToken
                self.keychain["homeServer"] = credentials.homeServer
                self.keychain["deviceId"] = credentials.deviceId
                self.credentials = credentials
                
                self.sync { result in
                    switch result {
                    case .failure(let error):
                        // Does this make sense? The login itself didn't fail, but syncing did.
                        self.loginState = .failure(error)
                    case .success(let state):
                        print("loggerlogging login sync success state \(state)")
                        self.loginState = .crossSign
                    }
                }
            }
        })
    }
    
    func logout(completion: @escaping (Result<LoginState, Error>) -> Void) {
        self.session?.logout { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                self.fileStore?.deleteAllData()
                self.clearKeychain()
                completion(.success(.loggedOut))
            }
        }
    }
    
    func logout() {
        self.logout { result in
            switch result {
            case .failure:
                self.loginState = .loggedOut
                self.clearKeychain()
            case .success(let state):
                self.loginState = state
                self.clearKeychain()
            }
        }
    }
    
    func crossSignDone() {
        if case .crossSign = loginState {
            loginState = .loggedIn
        }
    }
    
    private func clearKeychain() {
        self.keychain["userId"] = nil
        self.keychain["accessToken"] = nil
        self.keychain["homeServer"] = nil
        self.keychain["deviceId"] = nil
    }
}
