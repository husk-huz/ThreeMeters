//
//  ARPeer.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/19.
//

import Foundation
import SwiftUI
import Network

class ARPeer
{
    static func sendData(data: String, type: String)
    {
        var dict = ["type":"", "msg":"", "image":"", "emoji":""]
        
        if(type == "msg")
        {
            dict["type"] = "msg"
            dict["msg"] = data
            ARPeer.sendMSG(dict: dict)
        }
        else if(type == "image")
        {
            dict["type"] = "image"
            dict["image"] = data
            ARPeer.sendMSG(dict: dict)
        }
        else if(type == "emoji")
        {
            dict["type"] = "emoji"
            dict["emoji"] = data
            ARPeer.sendMSG(dict: dict)
        }
        else
        {
            
        }
    }
    
    static func sendMSG(dict: Dictionary<String, String>)
    {
        if(globalConnecter != nil)
        {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            {
                let jsonString = String(data: jsonData, encoding: .unicode)
                globalConnecter?.sendMSG(str: jsonString!)
            }
        }
        else if(globalHostControl != nil)
        {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            {
                let jsonString = String(data: jsonData, encoding: .unicode)
                globalHostControl?.sendMSG(str: jsonString!)
            }
        }
        else
        {
            
        }
    }
    
    static func getMSG(data : String)
    {
        if let jsonData = data.data(using: .unicode),
           let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]
        {
            print(dictionary)
            if(dictionary["type"] == "msg")
            {
                globalARViewModel.arDisplayString = dictionary["msg"]!
                globalARViewModel.isEdited += 1
            }
            else if(dictionary["type"] == "image")
            {
                if let temp_data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)
                {
                    let image = UIImage(data: temp_data)
                    globalARViewModel.arDisplayImage = image
                    globalARViewModel.isEdited += 1
                }
            }
            else if(dictionary["type"] == "emoji")
            {
                globalARViewModel.arDisplayEmoji = dictionary["emoji"]!
                globalARViewModel.isEdited += 1
            }
            else
            {
                
            }
        }
    }
}
