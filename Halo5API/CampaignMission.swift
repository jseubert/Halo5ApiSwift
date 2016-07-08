//
//  CampaignMission.swift
//  Halo5API
//
//  Created by John  Seubert on 7/7/16.
//  Copyright © 2016 John Seubert. All rights reserved.
//

import Foundation

public struct CampaignMission {

    public let id : String
    
    public let missionNumber : Int
    
    public let name : String
    
    public let missionDescription : String
    
    public let imageUrl : String
    
    public let type : String
    
    public let contentId : String
    
    public init(dictionary: [String : AnyObject]) {
        id = dictionary["id"] as? String ?? "";
        missionNumber = dictionary["missionNumber"] as? Int ?? -1;
        name = dictionary["name"] as? String ?? "";
        missionDescription = dictionary["description"] as? String ?? "";
        imageUrl = dictionary["imageUrl"] as? String ?? "";
        type = dictionary["type"] as? String ?? "";
        contentId = dictionary["contentId"] as? String ?? "";
    }
    
}

