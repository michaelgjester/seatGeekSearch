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

// MARK: UITableViewDataSource
extension EventListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return eventArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let reuseIdentifier = "EventTableViewCell"
    let cell = eventListTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! EventTableViewCell
    
    cell.eventTitleLabel.text = eventArray[indexPath.row].title
    cell.eventLocationLabel.text = eventArray[indexPath.row].locationString
    cell.eventDateTimeLabel.text = eventArray[indexPath.row].formattedDateTimeString
    
    cell.eventThumbnailImageView.layer.cornerRadius = 10
    cell.eventThumbnailImageView.clipsToBounds = true
    cell.eventThumbnailImageView?.downloadImageFromNetworkAtURL(url: eventArray[indexPath.row].imageUrlString)

    
    return cell
  }
  
}

// MARK: UITableViewDelegate
extension EventListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let selectedEvent: Event = self.eventArray[indexPath.row]
    let detailVC: EventDetailViewController = EventDetailViewController()
    detailVC.displayedEvent = selectedEvent
    self.navigationController?.pushViewController(detailVC, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: UISearchBarDelegate
extension EventListViewController: UISearchBarDelegate {
  
//  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//    print("searchText = \(searchText)")
//  }
  
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("searchButtonClicked")
    
    if let searchText = searchBar.text {
      
      let loadEventsCompletionHandler: ([Event]) -> Void = { [weak self] (eventArray:[Event]) -> Void in
        
        self?.eventArray = eventArray
        self?.eventListTableView.reloadData()
      }
      NetworkingManager.loadEventsWithCompletion(searchText: searchText, completionHandler: loadEventsCompletionHandler)
      
    }
    
    searchBar.resignFirstResponder()
  }
  
}

