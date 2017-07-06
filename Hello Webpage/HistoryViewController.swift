//
//  HistoryViewController.swift
//  Hello Webpage
//
//  Created by James Birchall on 30/04/2017.
//  Copyright © 2017 James Birchall. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<URLResponses>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(colorLiteralRed: 49, green: 50, blue: 53, alpha: 0)
        
        initialiseFetchedResultsController()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let object = fetchedResultsController?.object(at: indexPath) else {
                fatalError("Attempt to configure cell without managed object")
            }
            context.delete(object)
            CoreDataManager.sharedInstance.saveData()
        default:
            break
        }
    }
    
    func initialiseFetchedResultsController() {
        print("Initialise Fetched Results Controller.")
        
        let fetchRequest: NSFetchRequest<URLResponses> = URLResponses.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "responseDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching URL Responses.")
        }
    }
    
    // MARK: Overriden TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as? ResponseTableViewCell else {
            fatalError("Wrong cell for type dequeued")
        }
        
        guard let object = fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without managed object")
        }
        
        cell.dateLabel.text = "\(object.responseDate!.description)"
        if object.responseCode == "200" && object.firstPayloadSizeInBytes != -1 {
            cell.responseImage.image = UIImage(named: "PassedIcon")
            cell.responseLabel.text = "Response Status: 200"
        } else {
            cell.responseImage.image = UIImage(named: "FailedIcon")
            cell.responseLabel.text = "Response Status: \(object.responseCode!.description)"
        }
        
        cell.urlLabel.text = object.request?.url
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break // we dont Move yet
        case .update:
            break // we dont update yet
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            break   // we don't update anything yet
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        // print("Context Change - End Update.")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
