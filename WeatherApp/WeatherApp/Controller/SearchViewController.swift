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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        searchBar.delegate = self
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        // Do any additional setup after loading the view.
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
        if searchResults.count == 0 {
            numberOfRows = 1
            return numberOfRows
        } else {
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        
        if searchResults.count == 0 {
//            tableCell.name = "Search the city name"
            numberOfRows = 1
            tableCell.lblName.text = "Search the city name"
        } else {
//            tableCell.name = searchResults[indexPath.row].title
            tableCell.lblName.text = searchResults[indexPath.row].title

        }
                
//        if searchResults.count > 1 {
//            tableCell.name = searchResults[indexPath.row].title
//        } else {
//            tableCell.name = "Search the city name"
//        }
        

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
                    vc.selectedCity = searchResults[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
                }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
