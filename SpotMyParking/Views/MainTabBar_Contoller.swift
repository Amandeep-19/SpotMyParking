//
//  MainTabBar_Contoller.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-24.
//

import Foundation
import UIKit

class MainTabBar_Controller: UITabBarController {
    var emailAddress : String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            if let viewParkingNavigationController = viewController as? ViewParkingNavigationController{
                if let viewParkingViewController = viewParkingNavigationController.viewControllers.first as? ViewParkingViewController{
                    viewParkingViewController.emailAddress = emailAddress!
                }
            }
            
            if let addParkingNavigationController = viewController as? AddParkingNavigationController{
                if let addParkingViewController = addParkingNavigationController.viewControllers.first as? AddParkingViewController{
                    addParkingViewController.emailAddress = emailAddress!
                }
            }
            if let profileNavigationController = viewController as? ProfileNavigationController{
                if let profileViewController = profileNavigationController.viewControllers.first as? ProfileViewController{
                    profileViewController.emailAddress = emailAddress!
                }
            }
        }
    }
}
