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
  
  override init(){
    self.id = ""
    self.title = ""
    self.locationString = ""
    self.dateTimeString = ""
    self.imageUrlString = ""
  }
  
}
