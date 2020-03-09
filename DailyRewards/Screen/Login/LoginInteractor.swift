//
//  LoginInteractor.swift
//  DailyRewards
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//  Copyright (c) 2019 Globile. All rights reserved.
//
import GoogleSignIn
import FirebaseAuth
import JewFeatures
import SwiftyRSA

protocol LoginInteractorProtocol {
    func setupSignIn()
}

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    var workerFirebase: LoginFirebaseWorkerProtocol? = LoginFirebaseWorker()
    var workerPublicKey: LoginPublicKeyWorkerProtocol? = LoginPublicKeyWorker()
    var workerAccessToken: LoginAccessTokenWorkerProtocol? = LoginAccessTokenWorker()
    var workerSignIn: LoginSignInWorkerProtocol? = LoginSignInWorker()
    func setupSignIn() {
        GIDSignIn.sharedInstance()?.delegate = workerFirebase as? GIDSignInDelegate
        getFirebase(userCompletion: { (user) in
            self.authentication()
        }) { (error) in
            self.presenter?.presentLogin(error: error)
        }
    }
    
    private func getFirebase(userCompletion: @escaping (JEWUserModel) -> (), errorCompletion: @escaping (String) -> ()) {
        savedFirebaseUser(userCompletion: { (user) in
            userCompletion(user)
        }) { (error) in
            errorCompletion(error)
        }
        getServerFirebaseUser(userCompletion: { (user) in
            userCompletion(user)
        }) { (error) in
            errorCompletion(error)
        }
    }
    
    private func savedFirebaseUser(userCompletion: @escaping (JEWUserModel) -> (), errorCompletion: @escaping (String) -> ()) {
        let currentUser = Auth.auth().currentUser
        if(currentUser != nil) {
            workerFirebase?.create(user: currentUser, success: { (user) in
                JEWSession.session.user = user
                userCompletion(user)
            }, error: { (error) in
                errorCompletion(error)
            })
        }
    }
    
    private func getServerFirebaseUser(userCompletion: @escaping (JEWUserModel) -> (), errorCompletion: @escaping (String) -> ()) {
        workerFirebase?.successCallback = { (user) in
            userCompletion(user)
        }
        workerFirebase?.errorCallback = { (error) in
            errorCompletion(error)
        }
    }
    
    private func authentication() {
        getPublicKey(successCompletion: {
            self.getAccessToken()
        }) { (error) in
            self.presenter?.presentLogin(error: error)
        }
    }
    
    private func getPublicKey(successCompletion: @escaping () -> (), errorCompletion: @escaping (String) -> ()) {
        workerPublicKey?.get(successCompletion: { responsePublicKey in
            JEWSession.session.services.publicKey = responsePublicKey.data.publicKey
            self.getAccessToken()
        }, errorCompletion: { (error) in
            self.presenter?.presentLogin(error: error)
        })
    }
    
    private func getAccessToken() {
        if let aesCrypto = AES256Crypter.create(), let encryptedAESCryptoString = RSACrypto.encrypt(data: aesCrypto) {
            workerAccessToken?.post(aesCryptoEncrypted: encryptedAESCryptoString, successCompletion: { (accessToken) in
                if let accessTokenString = accessToken.data.accessToken {
                    self.signIn(accessToken: accessTokenString)
                }
            }, errorCompletion: { (error) in
                self.presenter?.presentLogin(error: error)
            })
        }
    }
    
    private func signIn(accessToken: String) {
        let currentUser = Auth.auth().currentUser
        let signIn = SignInModel(name: currentUser?.displayName ?? "User Without Name", email: currentUser?.email ?? "User Without Email", picture: currentUser?.photoURL?.absoluteString ?? "User Without Photo")
        if let signInData = getData(signIn: signIn), let encryptedSignInString = AES256Crypter.crypto.encrypt(signInData) {
            workerSignIn?.post(accessToken: accessToken, signInEncrypted: encryptedSignInString, successCompletion: { (sessionToken) in
                guard let user = JEWSession.session.user else {
                    self.presenter?.presentLogin(error: "Tente Novamente!")
                    return
                }
                JEWSession.session.services.token = sessionToken.data.sessionToken
                self.presenter?.presentLogin(user: user)
            }, errorCompletion: { (error) in
                self.presenter?.presentLogin(error: error)
            })
        }
    }
    
    private func getData(signIn: SignInModel) -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(signIn)
            return data
        } catch let error {
            JEWLogger.error(error.localizedDescription)
            return nil
        }
    }
    
}
