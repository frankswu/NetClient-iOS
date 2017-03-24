//
//  NetURLSessionDelegate.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Foundation

class NetURLSessionDelegate: NSObject {

    fileprivate weak var netURLSession: NetURLSession?

    var metrics = [NetURLSessionTaskIdentifier: Any]()

    init(_ urlSession: NetURLSession) {
        netURLSession = urlSession
        super.init()
    }

    deinit {
        metrics.removeAll()
        netURLSession = nil
    }

}

extension NetURLSessionDelegate: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        handle(challenge, completion: completionHandler)
    }

}

extension NetURLSessionDelegate: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        handle(challenge, completion: completionHandler)
    }

    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting taskMetrics: URLSessionTaskMetrics) {
        metrics[task.taskIdentifier] = taskMetrics
    }

}

extension NetURLSessionDelegate: URLSessionDataDelegate {}


extension NetURLSessionDelegate: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {}
    
}

@available(iOS 9.0, *)
extension NetURLSessionDelegate: URLSessionStreamDelegate {}

fileprivate extension NetURLSessionDelegate {

    func handle(_ challenge: URLAuthenticationChallenge, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let authChallenge = netURLSession?.authChallenge else {
            if let realm = challenge.protectionSpace.realm {
                print(realm)
                print(challenge.protectionSpace.authenticationMethod)
            }
            completion(.useCredential, nil)
            return
        }
        authChallenge(challenge, completion)
    }

}