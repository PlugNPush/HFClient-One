//
//  HistoryTableViewController.swift
//  HiberLink
//
//  Created by Nathan FALLET on 19/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, HistoryDelegate {
    
    var files = [(String, String, Date)]()
    
    func delay(_ delay:Double, closure: @escaping () -> ()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        navigationItem.title = "history_title".localized()
        
        // Register cells
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "labelCell")
        
        // Clear button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "history_clear".localized(), style: .plain, target: self, action: #selector(clear(_:)))
        
        // Load content
        loadContent()
    }
    
    func loadContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load from database
            self.files = Database.current.getFiles()
            
            DispatchQueue.main.async {
                // Refresh tableView
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func clear(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Load from database
            Database.current.clearHistory()
            
            DispatchQueue.main.async {
                // Refresh tableView
                self.files.removeAll()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
        let link = files[indexPath.row]
        
        cell.textLabel?.text = link.0
        cell.detailTextLabel?.text = link.1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Copy link
        let link = files[indexPath.row]
        UIPasteboard.general.string = link.0
        
        let choice = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        choice.addAction(UIAlertAction(title: "open".localized(), style: .default, handler: { (_) in
            guard let url = URL(string: link.0) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }))
        
        choice.addAction(UIAlertAction(title: "copy".localized(), style: .default, handler: { (_) in
            // Show confirmation
            let alert = UIAlertController(title: "copied_title".localized(), message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            self.delay(1){
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }))
        
        choice.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        
        present(choice, animated: true, completion: nil)
        
        
    }

}
