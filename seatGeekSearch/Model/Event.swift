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
  var imageUrlString: String
  
  override init(){
    self.id = ""
    self.title = ""
    self.locationString = ""
    self.dateTimeString = ""
    //self.formattedDateTimeString = ""
    self.imageUrlString = ""
  }
  
//  func getFormattedDateTimeString () -> String {
//
//    let dateFmtr = DateFormatter()
//    dateFmtr.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //"yyyy-MM-ddThh:mm:ss"
//    let date = dateFmtr.date(from: dateTimeString)
//
//    dateFmtr.dateFormat = "EEEE, MMM d yyyy, h:mm a"
//    let retString = dateFmtr.string(from: date!)
//
//    return retString
//  }
}
