//
//  FirstViewController.swift
//  FUMCApp
//
//  Created by Andrew Branch on 10/9/14.
//  Copyright (c) 2014 FUMC Pensacola. All rights reserved.
//

import UIKit

protocol HomeViewPage {
    var pageViewController: HomeViewController? { get set }
}

class HomeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    var pages = [UIViewController]()
    var calendarsDataSource: CalendarsDataSource?
    var calendarViewController: CalendarTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarViewController = self.storyboard!.instantiateViewControllerWithIdentifier("calendarViewController") as CalendarTableViewController
        let featuredViewController = self.storyboard!.instantiateViewControllerWithIdentifier("featuredViewController") as FeaturedViewController
        
        calendarViewController.pageViewController = self
        featuredViewController.pageViewController = self
        
        self.pages = [calendarViewController, featuredViewController]
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([calendarViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageControl.frame = CGRectMake(self.navigationController!.navigationBar.bounds.size.width / 2, 37, 0, 0)
        self.pageControl.transform = CGAffineTransformMakeScale(0.6, 0.6)
        self.pageControl.numberOfPages = self.pages.count
        
        self.navigationController!.navigationBar.addSubview(self.pageControl)
        
        self.calendarsDataSource = CalendarsDataSource(settingsDelegate: nil, calendarDelegate: calendarViewController)
        self.calendarViewController = calendarViewController
        
        // Preload featured view
        let preload = featuredViewController.view
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = find(self.pages, viewController)
        if (index == 0) {
            return nil
        }
        return self.pages[index! - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = find(self.pages, viewController)
        if (index == self.pages.count - 1) {
            return nil
        }
        return self.pages[index! + 1]
    }
    
    func didTransitionToViewController(viewController: UIViewController) {
        self.pageControl.currentPage = find(self.pages, viewController)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "calendarSettingsSegue") {
            let viewController = (segue.destinationViewController as CalendarSettingsViewController)
            self.calendarsDataSource!.settingsDelegate = viewController
            viewController.dataSource = self.calendarsDataSource!
            viewController.delegate = self.calendarViewController
        }
    }

}

