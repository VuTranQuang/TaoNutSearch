//
//  TableViewController.swift
//  TaoNutSearch
//
//  Created by Vũ on 1/15/19.
//  Copyright © 2019 Vũ. All rights reserved.
//

import UIKit
extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearch(searchController.searchBar.text!, scope: scope)
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearch(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope] )
    }
}

class TableViewController: UITableViewController {
    
    var laptops = [
        Laptop(catogery: "Dell", name: "Dell 1"),
        Laptop(catogery: "Dell", name: "Dell Vostro"),
        Laptop(catogery: "Dell", name: "Dell Inperion"),
        Laptop(catogery: "Asus", name: "Asus pro"),
        Laptop(catogery: "Asus", name: "Asus K"),
        Laptop(catogery: "Mac", name: "Mac Pro"),
        Laptop(catogery: "Mac", name: "Mac 2015"),
        Laptop(catogery: "Other", name: "may tinh 1"),
        Laptop(catogery: "Other", name: "May tinh bang")
    ]
    
    var filterLaptop = [Laptop]()
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup for search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Here!!!"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup for Scope
         searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["All", "Dell", "Asus", "Mac", "Other"]
        
    }
    //MARK: Setup action for Search
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
   
    func isFiltering() -> Bool {
        let scopeFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || scopeFiltering)
    }
    
    func filterContentForSearch(_ searchtext: String, scope: String = "All") {
        filterLaptop = laptops.filter({ (laptop: Laptop) -> Bool in
            let doesCatogeryMath = (scope == "All") || (laptop.catogery == scope)
            if isSearchBarEmpty() {
                return doesCatogeryMath
            } else {
                
                return doesCatogeryMath && laptop.name.lowercased().contains(searchtext.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterLaptop.count
        } else {
            return laptops.count
        }
       
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let laptop: Laptop
        if isFiltering() {
            laptop = filterLaptop[indexPath.row]
        } else {
            laptop = laptops[indexPath.row]
        }
        cell.textLabel?.text = laptop.name
        cell.detailTextLabel?.text = laptop.catogery

        return cell
    }
 

  

}
