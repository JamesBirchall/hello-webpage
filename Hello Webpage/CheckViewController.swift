//
//  CheckViewController.swift
//  Hello Webpage
//
//  Created by James Birchall on 30/04/2017.
//  Copyright © 2017 James Birchall. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var urlInputTextView: UITextView!
    @IBOutlet weak var urlResponseImageView: UIImageView!
    @IBOutlet weak var urlResponseStatusLabel: UILabel!
    @IBOutlet weak var urlResponseDescrptionLabel: UILabel!
    @IBOutlet weak var urlFirstPayloadSize: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    private var request: URL?
    private var response: URLResponse?
    private var data: Data?
    
    private func updateLabels() {
        if response != nil {

            let httpRespo: HTTPURLResponse = response as! HTTPURLResponse
            
            print("Whole Response HTTPResponse: \(httpRespo.debugDescription)")
            
            if httpRespo.expectedContentLength != -1 {
                urlResponseStatusLabel.text = "Response Status: \(httpRespo.statusCode)"
                urlResponseStatusLabel.isHidden = false
                
                urlResponseDescrptionLabel.text = "Response Description: \(HTTPURLResponse.localizedString(forStatusCode: httpRespo.statusCode))"
                urlResponseDescrptionLabel.isHidden = false
            } else {
                urlResponseStatusLabel.text = "Response Status: Invalid URL"
                urlResponseStatusLabel.isHidden = false
                
                urlResponseDescrptionLabel.text = "Response Description: No Server Response"
                urlResponseDescrptionLabel.isHidden = false
            }
            
            if httpRespo.statusCode == 200 && httpRespo.expectedContentLength != -1 {
                urlResponseImageView.image = UIImage(named: "PassedIcon")
            } else {
                urlResponseImageView.image = UIImage(named: "FailedIcon")
            }
            urlResponseImageView.isHidden = false
        
            urlFirstPayloadSize.text = "Estimated Size (bytes): \(httpRespo.expectedContentLength)"
            urlFirstPayloadSize.isHidden = false
            
            if let acceptCharacterSet = httpRespo.allHeaderFields["Accept-Charset"] as? String {
                print("Character Set: \(acceptCharacterSet)")
            }
            

            // Testng Core Data function!
            CoreDataManager.sharedInstance.setupAndSaveURLRequest(requestedURL: request!, responseInfo: httpRespo)
            CoreDataManager.sharedInstance.saveData()
            
            // Delete Function - wipes Core Data Model completely!!
//            CoreDataManager.sharedInstance.removeAllDataInModel()
//            CoreDataManager.sharedInstance.saveData()
            
//             CoreDataManager.sharedInstance.loadAndPrintData()
//             print("---------------------------")
//             CoreDataManager.sharedInstance.loadAndPrintDataURLObjectsAndArraysOfResponses()
            
//            if data != nil {
//                
//                // work out encoding by processing header properly!
//                if let contentType = httpRespo.allHeaderFields["Content-Type"] as? String {
//                    
//                    print("Content Type: \(contentType)")
//                    
//                    if contentType.contains("UTF-8") {
//                        let decodedWebPageData = String(data: data!, encoding: .utf8) ?? "Could not convert to string"
//                        print("Actual Data: \(decodedWebPageData)")
//                    } else if contentType.contains("ISO-8859-1") {
//                        let decodedWebPageData = String(data: data!, encoding: .isoLatin1) ?? "Could not convert to string"
//                        print("Actual Data: \(decodedWebPageData)")
//                    } else {
//                        print("Format not yet supported.")
//                    }
//                } else {
//                    print("Could not find: Accept-Charset key")
//                }
//            }
        }
    }
    
    
    // MARK: IBActions
    @IBAction func checkURLButtonPressed() {
        
        let urlString = urlInputTextView.text!
        
        let urlDataRequest = URL(string: urlString)
        
        request = urlDataRequest
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: urlDataRequest!) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error with request: \(error!.localizedDescription)")
            } else {
                self?.response = response
                self?.data = data
                DispatchQueue.main.async {
                    self?.updateLabels()
                }
            }
        }.resume()
        
        
        // so this works!! great - i get the status code - 200
        // I always get a response back so long as the address exists, else thats where the error would come in.
    }
    
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        // we will use the segmented control to determine how
        // this request will be used
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Paste Functionality
    @IBAction func pasteURL(_ sender: UIButton) {
        // Get URL from the Pastboard / check for something valid
        // Must start with http:// or https:// for now.
        if UIPasteboard.general.hasURLs {
            urlInputTextView.text = UIPasteboard.general.string
        } else {
            urlInputTextView.text = "Please copy a valid URL."
        }
    }
    
    func checkURLIsValid(url: String) -> Bool {
        
        // check match for http:// and https://
        
        return false
    }
}
