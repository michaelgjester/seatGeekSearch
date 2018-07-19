//
//  Event.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import Foundation

class Event: NSObject {
  
  var id: String
  var title: String
  var locationString: String
  var dateTimeString: String
  var imageUrlString: String
  
  //calculated / read-only properties
  var formattedDateTimeString: String {
    get {
      let dateFmtr = DateFormatter()
      dateFmtr.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      let date = dateFmtr.date(from: dateTimeString)
      
      dateFmtr.dateFormat = "EEEE, MMM d yyyy, h:mm a"
      let retString = dateFmtr.string(from: date!)
      
      return retString
    }
  }
  
  
  override init(){
    self.id = ""
    self.title = ""
    self.locationString = ""
    self.dateTimeString = ""
    self.imageUrlString = ""
  }
  
}
