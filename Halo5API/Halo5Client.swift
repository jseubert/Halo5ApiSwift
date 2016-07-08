//
//  Halo5Client.swift
//  Halo5API
//
//  Created by John  Seubert on 7/7/16.
//  Copyright © 2016 John Seubert. All rights reserved.
//

import UIKit

class Halo5Client {
    private var primaryKey = "30126583ab994b3eb5084c6836b287eb"
    private let secondaryKey = "0fb874038ad847e197b4a7b6d5b5d0d7"
    
    private let baseURL = "https://www.haloapi.com"
    
    static let sharedInstance = Halo5Client();
    private init() {}
    
    enum URLTitle : String {
        case H5 = "h5"
    }
    
    enum URLType : String {
        case Metadata = "metadata"
        case Profile = "profile"
        case Stats = "stats"
    }
    
    enum URLRequest : String {
        case CampaignMissions = "metadata/campaign-missions"
    }

    
    func buildURLWithTitle(title: URLTitle, type: URLType, request: URLRequest) -> String{
        return "\(baseURL)/\(type.rawValue)/\(title.rawValue)/\(request.rawValue)";
    }
    
    func getCampaignMissions(completion: (success: Bool, message: String?, missions: [CampaignMission]?  ) -> ()) {
        let requestUrl = buildURLWithTitle(URLTitle.H5, type: URLType.Metadata, request: URLRequest.CampaignMissions);
        
        get(clientURLRequest(requestUrl, params: nil)) {(success, object) in
            var missionArray = [CampaignMission]()
            if let missions = object as? [[String : AnyObject]] {
                var message = ""
                for mission in missions {
                    let missionObject = CampaignMission(dictionary: mission)
                    missionArray.append(missionObject)
                    print(missionObject.name)
                    message += missionObject.name
                }
                completion(success: true, message: message, missions: missionArray)
            } else if let message = object as? String {
                completion(success: success, message: message, missions: nil)
            } else {
                completion(success: false, message: "Something Broke", missions: nil)
            }
        }

    }
    
    //Generics for REST API
    private func post(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    private func put(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "PUT", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    //Called by one of the above
    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        request.HTTPMethod = method
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    completion(success: true, object: json)
                } else {
                    completion(success: false, object: json)
                }
            } else if error != nil {
                let response = ["message": "\(error!.code): Description \(error!.localizedDescription)"];
                completion(success: false, object: response)
            } else {
                completion(success: false, object: "Something went wrong")
            }
        }.resume()
    }
    
    //Builds a URL Request
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                paramString += "\(escapedKey!)=\(escapedValue!)"
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(primaryKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        }
        
        return request
    }
}
