//
//  NetURLSession+SyncUpload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func upload(_ request: NetRequest, data: Data) throws -> Data? {
        return try upload(request.urlRequest, data: data)
    }

    public func upload(_ request: URLRequest, data: Data) throws -> Data? {
        var dataObject: Data?
        var dataError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = upload(request, data: data, completion: { (data, response, error) in
            dataObject = data
            dataError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let dataError = dataError {
            throw dataError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return dataObject
    }

    public func upload(_ url: URL, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> Data? {
        return try upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), data: data)
    }

    public func upload(_ urlString: String, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> Data? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try upload(url, data: data, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

    public func upload(_ request: NetRequest, fileURL: URL) throws -> Data? {
        return try upload(request.urlRequest, fileURL: fileURL)
    }

    public func upload(_ request: URLRequest, fileURL: URL) throws -> Data? {
        var dataObject: Data?
        var dataError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = upload(request, fileURL: fileURL, completion: { (data, response, error) in
            dataObject = data
            dataError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let dataError = dataError {
            throw dataError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return dataObject
    }

    public func upload(_ url: URL, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> Data? {
        return try upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), fileURL: fileURL)
    }

    public func upload(_ urlString: String, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> Data? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try upload(url, fileURL: fileURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}