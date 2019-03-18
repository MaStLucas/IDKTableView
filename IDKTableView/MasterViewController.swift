//
//  MasterViewController.swift
//  IDKTableView
//
//  Created by StephenMa on 2019/3/17.
//  Copyright © 2019 Stephen Ma. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let contentOffsetButton = UIBarButtonItem(title: "Offset", style: .plain, target: self, action: #selector(animateContentOffset(_:)))
        let contentInsetButton = UIBarButtonItem(title: "Inset", style: .plain, target: self, action: #selector(animateContentInset(_:)))
        
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset(_:)))
        navigationItem.rightBarButtonItems = [addButton, contentInsetButton, contentOffsetButton, resetButton]
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc
    func animateContentInset(_ sender: Any) {
        tableView.contentInset = UIEdgeInsets.init(top: 56, left: 0, bottom: 0, right: 0)
    }
    
    @objc
    func animateContentOffset(_ sender: Any) {
        tableView.setContentOffset(CGPoint.init(x: 0, y: -56), animated: true)
    }
    
    @objc
    func reset(_ sender: Any) {
        tableView.contentInset = .zero
        tableView.contentOffset = .zero
        objects.removeAll()
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}

extension MasterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }
    
}

extension MasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    
}

