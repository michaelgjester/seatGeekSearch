//
//  ViewController.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let dummyCompletionHandler: ([Event]) -> Void = { [weak self] (eventArray:[Event]) -> Void in
      
      for event in eventArray{
        print("********************")
        print("event.id = \(event.id)")
        print("event.title = \(event.title)")
      }
    }
    
    NetworkingManager.loadEventsWithCompletion(completionHandler: dummyCompletionHandler)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

