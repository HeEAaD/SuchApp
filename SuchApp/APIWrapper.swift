//
//  SMAPIWrapper.swift
//  SuchApp
//
//  Created by Steffen on 03.06.14.
//  Copyright (c) 2014 Steffen. All rights reserved.
//

import Foundation

class APIWrapper {

    let apiKey = "" // <- your API token here

    func urlForMethod(method: String) -> NSURL {

        return NSURL.URLWithString("https://www.dogeapi.com/wow/v2/?api_key=\(apiKey)&a=\(method)")

    }

    func loadAccountBalanceWithCompetionHandler(completionHandler: (balance:Int) -> Void) {

        let session = NSURLSession.sharedSession()

        let url = urlForMethod("get_balance")

        let task = session.dataTaskWithURL(url) { data, response, error in

            let httpResp = response as NSHTTPURLResponse

            println("Status code: \(httpResp.statusCode)" )

            if (httpResp.statusCode == 200) {

                var jsonError:NSErrorPointer?

                let JSON = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: jsonError!) as Dictionary<String,Dictionary<String,Int>>

                let balance = JSON["data"]?["balance"] // better way?


                dispatch_async(dispatch_get_main_queue()) {

                    println("Balance: \(balance)")
                    completionHandler(balance: balance!)

                }
            }

        }

        task.resume()
        
    }

}