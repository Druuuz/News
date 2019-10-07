//
//  NewsTableViewController.swift
//  News
//
//  Created by Андрей Олесов on 10/3/19.
//  Copyright © 2019 Andrei Olesau. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    private var newsForFilter = [Article]()
    private var currentNewsForDisplay = [Article]()
    private var dayCounter = 1
    private let searchController = UISearchController()
    
    
    private var searchLineIsEmpty: Bool{
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering:Bool{
        return !searchLineIsEmpty && searchController.isActive
    }
    
    
    @objc private func refresh(sender: UIRefreshControl){
        if !isFiltering{
            currentNewsForDisplay.removeAll()
            dayCounter = 1
            addNewsToCurrentListOfNews(withDayCounter: dayCounter)
            tableView.reloadData()
        }
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DBUtil.retrieve())
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for News"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: "")

    
        addNewsToCurrentListOfNews(withDayCounter: dayCounter)
        
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func addNewsToCurrentListOfNews(withDayCounter counter:Int){
        let fromDate = Date().minusHours(24*counter)
        let tillDate = Date().minusHours((24*counter) - 24)
        print("from \(fromDate) to \(tillDate)")
        if let request = NetworkUtil.createRequest(fromDate: fromDate, tillDate: tillDate){
            NetworkUtil.getNews(byRequest: request) { (model) in
                if let articles = model.articles{
                    self.currentNewsForDisplay.append(contentsOf: articles)
                    DispatchQueue.main.async {
                       self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return newsForFilter.count
        }
        return currentNewsForDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell
        if let cell = cell{
            if isFiltering{
                cell.article = newsForFilter[indexPath.row]
            } else{
                cell.article = currentNewsForDisplay[indexPath.row]
            }
            
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController")
            as? DescriptionViewController else {return}
        if isFiltering{
            controller.article = newsForFilter[indexPath.row]
        } else{
            controller.article = currentNewsForDisplay[indexPath.row]
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = currentNewsForDisplay.count
        guard dayCounter < 7 , !isFiltering else {return}
        if indexPath.row == lastItem - 1{
          dayCounter += 1
          addNewsToCurrentListOfNews(withDayCounter: dayCounter)
        }
    }

}

extension NewsTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedText = searchController.searchBar.text else {return}
        newsForFilter = currentNewsForDisplay.filter({ (($0.title?.lowercased().contains(searchedText.lowercased())) ?? false)
        })
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
