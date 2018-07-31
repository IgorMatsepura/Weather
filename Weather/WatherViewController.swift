//
//  ViewController.swift
//  Weather
//
//  Created by IgorMac on 7/25/18.
//  Copyright © 2018 IgorMac. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UIViewController {
  
    
    // add name city in core data
    var addCityWeather = [String]()
    // filter result city in search bar
    var filterDataCity: [NSArray] = []
    var showCity: [City] = []
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchCIty: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchCIty.delegate = self
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

  
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! DetailWeather
        if segue.identifier == "segueInfo"  {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let nameTowns = self.tableView.cellForRow(at: indexPath)
            controller.stringWors = (nameTowns?.textLabel?.text)!
            controller.stringTitle = "Weather in city "
        }
        
    }
    
    // function save name city in core data
    func saveData(name: String) {
        
        let result = City(entity: City.entity(), insertInto: context)
        result.setValue(name, forKey: "cityName")
        
        do {
            try context.save()
            print("Saved!!!")
            self.addCityWeather.append(result.cityName!)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // fuction show all record in core data
    func fetchData() {
        do{
            showCity = try context.fetch(City.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch data \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addCity(_ sender: Any) {
        let textField = self.searchCIty.text!
        
        if textField != "" {
            if self.compareWord(res: textField) == true {
                print("Not add in data present name \(textField) city")
            } else {
                saveData(name: textField)
            }
        }
        fetchData()
        self.tableView.reloadData()
    }
    
    //Mark: compare words input and data
    func compareWord(res: String) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let word = self.searchCIty?.text
        request.predicate = NSPredicate(format: "cityName == %@", word!)
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                let wordCity = (results[0] as AnyObject).value(forKey: "cityName") as! String
                if word! == wordCity {
                    print("This city is present in data \(self.searchCIty.text!) = \(wordCity)")
                    return true
                }
            }
        } catch let error as NSError {
            print("Could not search data \(error), \(error.userInfo)")
        }
        return false
    }
    
} 

 //MARK : - tableview datasource
extension WeatherViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = showCity[indexPath.row]
        cell.textLabel!.text = name.cityName
        return cell;
    }
    
}
 //MARK : - tableview delegate
extension WeatherViewController: UITableViewDelegate {
    
    // function delete record in core data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.tableView.setEditing(true, animated: true)
            self.context.delete(showCity[indexPath.row])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                self.showCity = try self.context.fetch(City.fetchRequest())
            } catch let error as NSError {
                print("Could not delete record \(error), \(error.userInfo)")
            }
            self.tableView.reloadData()
        }
    }
    // func select row
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath ) {
        //  let info =  NSFetchedResultsController.indexPath(NSFetchedResultsController<indexPath.row>) as? City
        //  performSegueWithIdentifier("segueInfo", sender: info)
        self.performSegue(withIdentifier: "segueInfo", sender: self)
        print(performSegue(withIdentifier: "segueInfo", sender: self))
    }
}

//MARK : - searchbar delegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let searchText = self.searchCIty?.text
        request.predicate = NSPredicate(format: "cityName == %@", searchText!)
        //   search.delegate = self
        
        if searchText == "" {
            self.tableView.reloadData()
        } else {
            
            //   if searchText != "" {
            do {
                let result = try self.context.fetch(request)
                if result.count > 0 {
                    let namecity = (result[0] as AnyObject).value(forKey: "cityName") as! String
                    print (namecity)
                    self.showCity = try context.fetch(request) as! [City]
                    self.tableView.reloadData()
                    
                }
            } catch let error as NSError {
                print("Could not search data \(error), \(error.userInfo)")
            }
        }
    }
    
}
