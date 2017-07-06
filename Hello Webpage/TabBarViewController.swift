//
//  TabBarViewController.swift
//  Hello Webpage
//
//  Created by James Birchall on 13/05/2017.
//  Copyright © 2017 James Birchall. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var mainTabBar: TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTabBar.configureTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
