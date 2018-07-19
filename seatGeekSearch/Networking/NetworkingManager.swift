//
//  NetworkingManager.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
    
    static func loadEventsWithCompletion(completionHandler:@escaping ([Event]) -> Void) -> Void{
      
        let clientId = "OTIwNTk4M3wxNTMyMDAwOTg0Ljg3"
        let eventRequestString = "https://api.seatgeek.com/2/events?client_id=" + clientId + "&q=Texas+Ranger"
      
        guard let url = URL(string: eventRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main)
        
        // make the request with the session
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            //check 1: no errors
            guard error == nil else {
                print("error calling the request:\(error!)")
                return
            }
            
            //check 2: data is non-nil
            guard data != nil else {
                print("Error: data is nil")
                return
            }
            
            //check 3: response parameter is non-nil
            if response != nil {
                do {
                  
//                  if let response = response {
//                    print("response = \(response)")
//                    if let data = data {
//                      print("data = \(data)")
//
//                    }
//                  }
                  
                    //JSON response is an array of dictionaries
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: [])as? [String: AnyObject]{
                      
                      if let jsonEventArray = jsonDictionary["events"] {
                        
                        //populate array of model objects based on JSON response
                        let eventArray: [Event] = self.processJsonRequestIntoArrayOfEvents(jsonArray:jsonEventArray as! [Dictionary<String, AnyObject>])

                        //perform completion handler with the array of model objects
                        completionHandler(eventArray)
                        
                      }
                    }
                  
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }


    static func processJsonRequestIntoArrayOfEvents(jsonArray: [Dictionary<String, AnyObject>]) -> [Event]{
        
        var eventArray: [Event] = []
        
        for eventDictionary in jsonArray{
            let currentEvent: Event = Event()
          
            currentEvent.id = eventDictionary["id"]!.stringValue as String
            currentEvent.title = eventDictionary["title"] as! String
          
//            if let title = eventDictionary["title"] as! String {
//              print("title = \(title)")
//              currentEvent.title = title
//            }
//
//            if let shortTitle = eventDictionary["short_title"] {
//              print("short_title = \(shortTitle)")
//            }

            eventArray.append(currentEvent)
        }

        
        return eventArray
    }
  

}
