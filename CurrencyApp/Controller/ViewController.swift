//
//  ViewController.swift
//  CurrencyApp
//
//  Created by MacBook Pro on 25.05.21.
//

import UIKit

class ViewController: UITableViewController, XMLParserDelegate {

    var allCurrencies : NSArray = []
    var url: URL!
    var currencies = [CurrencyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadData()
        split()
    }
    
    func loadData() {
        url = URL(string: "http://www.nbg.ge/rss.php")!
        loadRss(url);
    }
    
    func loadRss(_ data: URL) {

        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager

        allCurrencies = myParser.currencies
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        title = (allCurrencies.object(at: 0) as AnyObject).object(forKey: "title") as? String
        
        cell.textLabel!.text = currencies[indexPath.row].abbreviation + " - " + currencies[indexPath.row].name

        cell.detailTextLabel!.text = currencies[indexPath.row].amount
        return cell
    }
    
    func split() {
        let description = (allCurrencies.object(at: 0) as AnyObject).object(forKey: "description") as? String
        
        var components = description?.components(separatedBy: "<td>")
        
        components?.remove(at: 0)
        
        for i in stride(from: 1, through: components!.count, by: 5) {
            let abbrevuationIndex = components![i - 1].firstIndex(of: "<")!
            let abbreviation = components![i - 1][..<abbrevuationIndex]
            let nameIndex = components![i].firstIndex(of: "<")!
            let name = components![i][..<nameIndex]
            let amountIndex = components![i + 1].firstIndex(of: "<")!
            let amount = components![i + 1][..<amountIndex]
            let currency = CurrencyModel(name: String(name), amount: String(amount), abbreviation: String(abbreviation))
            currencies.append(currency)
        }
    }
}

