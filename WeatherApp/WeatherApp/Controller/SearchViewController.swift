//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 27/06/22.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfRows = 20

    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var recentSearches = [String]()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recentSearches = userDefaults.object(forKey: "recentSearches") as? [String] ?? []
        
        searchCompleter.delegate = self
        searchBar.delegate = self
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    // MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        numberOfRows = searchResults.count
        self.citiesTableView.reloadData()
        
        print(searchResults)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if recentSearches.count == 0 {
                numberOfRows = 1
                return numberOfRows
            } else {
                return recentSearches.count
            }
        case 1:
            if searchResults.count == 0 {
                numberOfRows = 1
                return numberOfRows
            } else {
                return numberOfRows
            }
        default:
            if searchResults.count == 0 {
                numberOfRows = 1
                return numberOfRows
            } else {
                return numberOfRows
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        
        switch indexPath.section {
        case 0:
            if recentSearches.count > 0 {
                numberOfRows = recentSearches.count
                tableCell.lblName.text = recentSearches[indexPath.row]
            } else {
                numberOfRows = 1
                tableCell.lblName.text = "Search the city name"
            }
        case 1:
            if searchResults.count == 0 {
                numberOfRows = 1
                tableCell.lblName.text = "Search the city name"
            } else {
                tableCell.lblName.text = searchResults[indexPath.row].title
            }
        default:
            numberOfRows = 1
            tableCell.lblName.text = "Search the city name"
        }
        
        return tableCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recent Searches"
        case 1:
            return "Possible Results"
        default:
            return "Possible Results"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                        vc.selectedCity = recentSearches[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                    }
        case 1:
            if recentSearches.count == 5 {
                recentSearches.removeLast()
                print(recentSearches)
            }
            recentSearches.insert(searchResults[indexPath.row].title, at: 0)
            citiesTableView.reloadData()
            userDefaults.set(recentSearches, forKey: "recentSearches")
            //salvar o array no UserDefaults
            print(recentSearches)
            
            
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                        vc.selectedCity = searchResults[indexPath.row].title
                self.navigationController?.pushViewController(vc, animated: true)
                    }
        default:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                        vc.selectedCity = searchResults[indexPath.row].title
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
