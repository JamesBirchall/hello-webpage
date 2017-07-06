//
//  CoreDataManager.swift
//  Hello Webpage
//
//  Created by James Birchall on 02/05/2017.
//  Copyright © 2017 James Birchall. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    private init() {}
    
    func setupAndSaveURLRequest(requestedURL: URL, responseInfo: HTTPURLResponse) {
        
        var request: URLRequested?  // to store either an existing or new reference
        
        // first search for the request in Core Data as only 1 should exist for each URL string variation
        let fetchedURLRequest: NSFetchRequest<URLRequested> = URLRequested.fetchRequest()
        fetchedURLRequest.predicate = NSPredicate(format: "url = %@", requestedURL.absoluteString)
        
        if let returnedRequests = try? context.fetch(fetchedURLRequest) {
            // check for just 1 object - error the app otherwise as there should be no clashes
            if returnedRequests.count == 1 {
                // print("Found a match: \((returnedRequests.first?.url)!)")
                // use existing one
                request = returnedRequests.first
            } else if returnedRequests.count == 0 {
                // print("Setup a new URLRequestedObject in Core Data.")
                request = URLRequested(context: context)
                request?.url = requestedURL.absoluteString
            } else {
                print("Somethng strange happened - more than one match was found, check Core Data database!")
            }
        }
        
        if request != nil {
            // print("Setting up response object and saving")
            let response = URLResponses(context: context)
            response.responseDate = Date() as NSDate
            response.firstPayloadSizeInBytes = responseInfo.expectedContentLength
            response.responseCode = "\(responseInfo.statusCode)"
            response.responseDescription = HTTPURLResponse.localizedString(forStatusCode: responseInfo.statusCode)
            
            request!.responses?.adding(response)
            response.request = request
        } else {
            print("Request was nil, there was a fault.")
        }

    }
    
    func saveData() {
        do {
            try context.save()
            print("Context Successfully Saved to Core Data.")
        } catch {
            print("Error Saving Value: \(error)")
        }
    }
    
    func loadAndPrintData() {
        let request: NSFetchRequest<URLResponses> = URLResponses.fetchRequest()
        let sorting = NSSortDescriptor(key: "responseDate", ascending: false)
        request.sortDescriptors = [sorting]
        
        if let recentResponses = try? context.fetch(request) {
            
            if recentResponses.count < 1 {
                print("No data for Responses.")
            }
            
            print("We have \(recentResponses.count) URLResponse objects.")
            
//            for response in recentResponses {
//                //print("Date: \(response.responseDate!), response for URL:  \((response.request?.url)!) was \(response.responseCode!)")
//                print("Date: \(response.responseDate!), response object ID:  \(response.request.debugDescription) was \(response.responseCode!) with URL: \((response.request?.url)!)")
//            }
        }
    }
    
    func loadAndPrintDataURLObjectsAndArraysOfResponses() {
        let request: NSFetchRequest<URLRequested> = URLRequested.fetchRequest()
        
        if let urls = try? context.fetch(request) {
            
            if urls.count < 1 {
                print("No data for URLRequests.")
            }
            
            print("We have \(urls.count) URLRequest objects.")
            
//            for url in urls {
////                print("URL: \(url.url!)")
////                print("Set of responses: \(url.responses.debugDescription)")
//            }
        }
    }
    
    func removeAllDataInModel() {
        let request: NSFetchRequest<URLResponses> = URLResponses.fetchRequest()
        let sorting = NSSortDescriptor(key: "responseDate", ascending: false)
        request.sortDescriptors = [sorting]
        
        if let recentResponses = try? context.fetch(request) {
            for response in recentResponses {
                context.delete(response)
            }
        }
        
        let request2: NSFetchRequest<URLRequested> = URLRequested.fetchRequest()
        
        if let urls = try? context.fetch(request2) {
            for url in urls {
                context.delete(url)
            }
        }
        
        print("This should clear the old girl out.")
    }
}
