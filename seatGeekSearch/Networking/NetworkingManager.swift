//
//  NetworkingManager.swift
//  recipeBook
//
//  Created by Michael Jester on 3/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
  
  static let allowedEventTypes = ["sports"]
  
  static func loadEventsWithCompletion(searchText: String, completionHandler:@escaping ([Event]) -> Void) -> Void{
    
      let clientId = "OTIwNTk4M3wxNTMyMDAwOTg0Ljg3"

      let updatedSearchText = searchText.replacingOccurrences(of: " ", with:"+")
      let eventRequestString = "https://api.seatgeek.com/2/events?client_id=" + clientId + "&q=" + updatedSearchText
    
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


  
  static func downloadImageAtURL(urlString: String, downloadCompletionHandler:@escaping ((Data)->Void)){
    
    guard let url = URL(string: urlString) else {
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
        downloadCompletionHandler(data!)
      } else {
        print("Error: response in nil")
      }
    }
    
    task.resume()
  }

  static func processJsonRequestIntoArrayOfEvents(jsonArray: [Dictionary<String, AnyObject>]) -> [Event]{
    
      var eventArray: [Event] = []
    
      for eventDictionary in jsonArray{
        let currentEvent: Event = Event()
      
        if !isValidEventType(eventDictionary) {
          return []
        }
              
        currentEvent.id = eventDictionary["id"]!.stringValue as String
        currentEvent.title = eventDictionary["title"] as! String
        currentEvent.dateTimeString = eventDictionary["datetime_local"] as! String
      
        if let venueJsonDictionary = eventDictionary["venue"] as? Dictionary<String, AnyObject> {
          if let city = venueJsonDictionary["city"] as? String, let state = venueJsonDictionary["state"] as? String {
            currentEvent.locationString = city + ", " + state
          }
          
        }
      
        if let performersJsonArray = eventDictionary["performers"] as? [Dictionary<String, AnyObject>] {
          
          //FIXME -
          //not sure we can assume home team always second element in array?
          let homeTeam = performersJsonArray[1]
          
          if let imageUrl = homeTeam["image"] as? String {
            currentEvent.imageUrlString  = imageUrl
          }
          
        }
        eventArray.append(currentEvent)
      }

    
      return eventArray
  }
  
  static func isValidEventType(_ eventDictionary: Dictionary<String, AnyObject>) -> Bool {
    
    let eventTypeDictionaryArray = eventDictionary["taxonomies"] as? [Dictionary<String, AnyObject>]
    var isValidEventType = false
    
    for eventTypeDictionary in eventTypeDictionaryArray! {
      if allowedEventTypes.contains(eventTypeDictionary["name"] as! String){
        isValidEventType = true
        break
      }
    }
    
    return isValidEventType
  }
  

}
