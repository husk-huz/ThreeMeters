//
//  HzzzJson.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/19.
//

import Foundation


class HzzzHTTP
{
    static func SendJson(urlStr: String, data: Dictionary<String, String>, whenFinish: @escaping (Dictionary<String, String>)->Void)
    {
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        // 创建请求对象
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 创建URLSession对象
        let session = URLSession.shared

        // 发送请求
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            // 处理响应
            if let data = data
            {
                print(String(data: data, encoding: .utf8)!)
                whenFinish(["it is test":""])
            }
        }
        task.resume()
    }
}

