//
//  EventDetailViewController.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

  public var displayedEvent: Event? = nil
  
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var eventDateTimeLabel: UILabel!
  @IBOutlet weak var eventLocationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set the title text
    self.navigationItem.title = self.displayedEvent?.title
    let attrs = [
      NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 24)!
    ]
    self.navigationController?.navigationBar.titleTextAttributes = attrs
    
    if let event = self.displayedEvent {
      self.eventImageView.downloadImageFromNetworkAtURL(url: event.imageUrlString)
      self.eventDateTimeLabel.text = event.formattedDateTimeString
      self.eventLocationLabel.text = event.locationString
    }
    
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
