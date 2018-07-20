//
//  EventListViewController.swift
//  seatGeekSearch
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {

  @IBOutlet weak var eventListTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  private var eventArray: [Event] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()

      eventListTableView.dataSource = self
      eventListTableView.delegate = self
      searchBar.delegate = self
      
      //give the search bar a default value
      searchBar.text = "Texas Rangers"
      performNetworkCall()
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
  
    private func performNetworkCall() {
      let loadEventsCompletionHandler: ([Event]) -> Void = { [weak self] (eventArray:[Event]) -> Void in
        
        //upon each network call re-perform check coreData
        //if the loaded events are 'favorited'
        let savedEventIds = CoreDataManager.getSavedEventIds()
        for event in eventArray {
          if savedEventIds.contains(event.id){
            event.isFavorite = true
          }
        }
        self?.eventArray = eventArray
        self?.eventListTableView.reloadData()
      }
      if let text = searchBar.text {
        if !text.isEmpty {
          NetworkingManager.loadEventsWithCompletion(searchText: text, completionHandler: loadEventsCompletionHandler)
        }
      }
    }

}

// MARK: UITableViewDataSource
extension EventListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let reuseIdentifier = "EventTableViewCell"
    let cell = eventListTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! EventTableViewCell
    
    //text labels
    cell.eventTitleLabel.text = eventArray[indexPath.row].title
    cell.eventLocationLabel.text = eventArray[indexPath.row].locationString
    cell.eventDateTimeLabel.text = eventArray[indexPath.row].formattedDateTimeString
    
    //thumbnail image
    cell.eventThumbnailImageView.layer.cornerRadius = 10
    cell.eventThumbnailImageView.clipsToBounds = true
    cell.eventThumbnailImageView?.downloadImageFromNetworkAtURL(url: eventArray[indexPath.row].imageUrlString)

    //is favorite image
    let savedEventIds = CoreDataManager.getSavedEventIds()
    let isFavorite = savedEventIds.contains(eventArray[indexPath.row].id)
    let isFavoriteImage: UIImage? = isFavorite ? UIImage(named:"heart_red") : nil
    cell.eventIsFavoriteImageView.image = isFavoriteImage
    
    return cell
  }
  
}

// MARK: UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let detailVC: EventDetailViewController = EventDetailViewController()
    detailVC.displayedEvent = self.eventArray[indexPath.row]
    detailVC.dismissVCHandler = {
      //reload master view in case changes have been made on the detail screen
      if let eventAfterUpdate = detailVC.displayedEvent {
        //either add or delete event from saved favorites
        if eventAfterUpdate.isFavorite {
          CoreDataManager.addEvent(eventAfterUpdate)
        } else {
          CoreDataManager.deleteEvent(eventAfterUpdate)
        }
      }
      self.eventListTableView.reloadData()
    }
    
    self.navigationController?.pushViewController(detailVC, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: UISearchBarDelegate
extension EventListViewController: UISearchBarDelegate {
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    performNetworkCall()
    searchBar.resignFirstResponder()
    
  }
  
}

