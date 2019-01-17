//
//  StreetFitTokenHandler.swift
//  Mockup
//
//  Created by Quentin Duquesne on 16/12/2018.
//  Copyright © 2018 Quentin Duquesne. All rights reserved.
//

import Foundation
import Alamofire

class StreetFitTokenHandler: RequestAdapter, RequestRetrier {
    
    // Definition du RefreshCompletion utilisé lors de la requete RefreshToken
    private typealias RefreshCompletion = (_ succeeded: Bool, _ jwt1: String?, _ jwt2: String?) -> ()
    
    
    // Definition du SessionManager
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
        
    } ()
    
    
    // Autres variables
    private let lock = NSLock()
    
    private var jwt1: String?
    private var jwt2: String?
    private var baseURLString: String
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // Initialization
    
    public init() {
        self.jwt1 = UserDefaults.standard.string(forKey: "jwt1")
        self.jwt2 = UserDefaults.standard.string(forKey: "jwt2")
        self.baseURLString = "http://83.217.132.102:3000/"
    }
    
    
    // Request Adapter
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            print("DEBUG ADAPTER JWT1 IS", jwt1!)
            urlRequest.setValue(jwt1, forHTTPHeaderField: "jwt1")
            urlRequest.setValue(jwt2, forHTTPHeaderField: "jwt2")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // RequestRetrier
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                print("Refresh is require, launching of the refreshToken function")
                refreshToken { [weak self] succeeded, jwt1,jwt2 in
                    guard let strongSelf = self else {return}
                    
                    strongSelf.lock.lock() ; defer {strongSelf.lock.unlock()}
                    
                    if let jwt1 = jwt1, let jwt2 = jwt2 {
                        strongSelf.jwt1 = jwt1
                        strongSelf.jwt2 = jwt2
                        
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                    
                }
            }
        } else {
            completion(false,0.0)
        }
    }
    
    //RefreshToken
    private func refreshToken (completion: @escaping RefreshCompletion) {
        
        let urlString = "http://83.217.132.102:3000/auth/refresh"
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        let headers: HTTPHeaders = [
            "jwt1" : jwt1!
        ]
        
        sessionManager.request(urlString, method: .post,encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            
            guard let json = response.result.value as? [String:Any] else {return}
            let data = json["data"] as! [String:Any]
            let jwt2 = data["JWT2"] as? String
            
            if
                let json = response.result.value as? [String:Any],
                let data = json["data"] as? [String:Any],
                let jwt2 = data["JWT2"] as? String
                
            {
                UserDefaults.standard.set(jwt2, forKey: "jwt2")
                completion(true,self?.jwt1,jwt2)
            } else {
                completion(false,nil,nil)
            }
            
            strongSelf.isRefreshing = false
            
        }
    }
    
    
}

// ================================== MAIN FUNCTIONS ====================================

func populateEventsList (targetURL: String,theSessionManager: SessionManager, completion: @escaping ([eventClass]?) -> Void) {
    
    theSessionManager.request(targetURL, method: .get)
        .validate()
        .responseJSON { response in
            
            print(response)
            
            switch response.result {
                
            case .success:
                
                guard response.result.isSuccess else {return completion(nil)}
                guard let rawInventory = response.result.value as? [[String:Any]?] else {return completion(nil)}
                
                let inventory = rawInventory.compactMap { EvenDict -> eventClass? in
                    let data = EvenDict!
                    return eventClass(data: data)
                }
                completion(inventory)
                
            case .failure(let error):
                print(error)
                
            }
            
    }
    
} // end of populateEventsList


