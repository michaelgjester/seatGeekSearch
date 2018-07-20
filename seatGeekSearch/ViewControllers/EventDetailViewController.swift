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
  public var dismissVCHandler: (() -> Void)? = nil
  
  private var heartButton: UIButton = UIButton()
  
  @IBOutlet weak var eventImageView: UIImageView!
  @IBOutlet weak var eventDateTimeLabel: UILabel!
  @IBOutlet weak var eventLocationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavBar()
    
    if let event = self.displayedEvent {
      self.eventImageView.layer.cornerRadius = 10
      self.eventImageView.clipsToBounds = true
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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if let dismissVCHandler = dismissVCHandler {
      dismissVCHandler()
    }
  }
  
  private func configureNavBar() {
    
    //set the navigation bar title text
    //using multiple lines
    let label = UILabel(frame: CGRect(x:0, y:0, width:400, height:400))
    label.backgroundColor = .clear
    label.numberOfLines = 2
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    label.textAlignment = .center
    label.textColor = .black
    let formattedTitle: String = (self.displayedEvent?.title.replacingOccurrences(of: " at ", with: " at\n"))!
    label.text = formattedTitle
    self.navigationItem.titleView = label
    
    
    //add 'favorites' button to nav bar
    if let event = displayedEvent {
      let isFavorite = event.isFavorite
      let isFavoriteImage: UIImage? = isFavorite ? UIImage(named:"heart_red") : UIImage(named:"heart_blank")
      self.heartButton.setImage(isFavoriteImage, for: .normal)
      self.heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
      let rightBarButton = UIBarButtonItem(customView: heartButton)
      self.navigationItem.rightBarButtonItem = rightBarButton
    }

  }
  
  @objc func heartTapped() {
    
    //toggle 'isFavorite' status and update to appropriate image
    displayedEvent?.isFavorite = !(displayedEvent?.isFavorite)!
    let imageNameForCurrentState = (displayedEvent?.isFavorite)! ? "heart_red" : "heart_blank"
    let imageForCurrentState = UIImage(named: imageNameForCurrentState)
    self.heartButton.setImage(imageForCurrentState, for: .normal)
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
