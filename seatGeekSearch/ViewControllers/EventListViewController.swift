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
  
    private var eventArray: [Event] = []
  
    override func viewDidLoad() {
      super.viewDidLoad()

      eventListTableView.dataSource = self
      eventListTableView.delegate = self
      
      // Do any additional setup after loading the view.
      let loadEventsCompletionHandler: ([Event]) -> Void = { [weak self] (eventArray:[Event]) -> Void in
        
        //DEBUG CODE
        /*
        for event in eventArray{
          print("********************")
          print("event.id = \(event.id)")
          print("event.title = \(event.title)")
          print("event.dateTimeString = \(event.dateTimeString)")
          print("event.imageUrlString = \(event.imageUrlString)")
        }
        */
        
        self?.eventArray = eventArray
        self?.eventListTableView.reloadData()
      }
      
  NetworkingManager.loadEventsWithCompletion(completionHandler: loadEventsCompletionHandler)
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
    
    let reuseIdentifier = "cell"
    let cell: UITableViewCell = eventListTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)
    
    cell.textLabel!.text = eventArray[indexPath.row].title
    
    return cell
  }
  
}

// MARK: UITableViewDelegate
extension EventListViewController: UITableViewDelegate {

}

