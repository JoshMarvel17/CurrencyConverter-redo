//
//  CurrencyPickerViewController.swift
//  CurrencyConverter-redo
//
//  Created by Joshua Marvel on 5/18/17.
//  Copyright © 2017 Joshua Marvel. All rights reserved.
//

import UIKit

class CurrencyPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: OUTLETS
    @IBOutlet weak var HomeTableView: UITableView!
    
    @IBOutlet weak var ForeignTableView: UITableView!
   
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var convertedAmountLabel: UILabel!
   
    
    //MARK: Variables
   
    var currString = [String]()
    
    
    var currencyDict = [String:String]()
    
    
    
    override func viewDidLoad() {
        
        for i in data {
            
            
            if i.check == true{
                
                
                currString.append(i.currName)
            }
            
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        currencyDict = callYQL()
        
       
        HomeTableView.delegate = self
        
        
        ForeignTableView.delegate = self
        
        
        HomeTableView.dataSource = self
        
        
        ForeignTableView.dataSource = self
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
        
        HomeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        ForeignTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        
        self.HomeTableView.reloadData()
        
        
        self.ForeignTableView.reloadData()
        
        
        
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipe(_ sender:UISwipeGestureRecognizer)
    {
        
        self.performSegue(withIdentifier: "showFavorites", sender: self)
    }
    
    //Enable unwinding other views
    @IBAction func unwindToCurrency(segue:UIStoryboardSegue){}
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var currCell:UITableViewCell?
        
        if tableView == self.ForeignTableView{
            
            
            currCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell2")
            
            currCell!.textLabel!.text = currString[indexPath.row]
            
            
        }
        if tableView == self.HomeTableView{
            
            
            currCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            
            currCell!.textLabel?.text = currString[indexPath.row]
            
            
            
        }

        
        return currCell!
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var currCount:Int?
        
        if tableView == self.HomeTableView {
            
            
            currCount = currString.count
        }
        
        if tableView == self.ForeignTableView {
            
            
            currCount = currString.count
        }
        
        return currCount!
    }
    
    var selectedHomeCell : String = ""
    
    
    var selectedForeignCell : String = ""
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let currCell = tableView.cellForRow(at: indexPath)
        
        if tableView == self.ForeignTableView {
            
            
            selectedForeignCell = (currCell?.textLabel!.text)!
            
            print(selectedForeignCell)
            
            
        }
        
        if tableView == self.HomeTableView{
            
            
            
            selectedHomeCell = (currCell?.textLabel!.text)!
            
            print(selectedHomeCell)
            
            
        }
        
    }
    
    func callYQL()-> Dictionary<String,String>
    {
        let myYQL = YQL()
        
        
        let queryString = "select * from yahoo.finance.xchange where pair in" +
            "(\"USDEUR\",\"USDJPY\", \"USDGBP\", \"USDUSD\", " +
            "\"EURUSD\", \"EURGBP\", \"EURJPY\", \"EUREUR\", " +
            "\"GBPUSD\", \"GBPEUR\", \"GBPJPY\", \"GBPGBP\", " +
            "\"JPYUSD\", \"JPYGBP\", \"JPYEUR\", \"JPYJPY\" )"

  
    
        var currencyDictionary = [String:String]()
        
        
        
        
        myYQL.query(queryString) { jsonDict in
            
            let queryDict = jsonDict["query"] as! [String: Any]
            
            
            let resultsDict = queryDict["results"] as! [String: Any]
            
            
            let rateArray = resultsDict["rate"] as! [Any]
            
            
            
            
            for i in 0..<rateArray.count {
                
                let rateDict = rateArray[i] as! [String: Any]
                
                let name = rateDict["id"] as! String
                
                let rate = rateDict["Rate"] as! String
                
                currencyDictionary.updateValue(rate, forKey: name)
                
            }
        }
        
        sleep(2)
        
        
        return currencyDictionary
}

    @IBAction func updatePickers(_ sender: Any) {
        
        currString.removeAll()
        
        
        for i in data {
            
            if i.check == true{
                
                currString.append(i.currName)
                
                i.check = false;
            }
        }
        
        self.HomeTableView.reloadData()
        
        
        self.ForeignTableView.reloadData()
        
    }
    
    @IBAction func convertButton(_ sender: Any) {
        
        
        let num : Float = Float(amountTextField.text!)!
        
        var homeSymbol : String = ""
        
        var foreignSymbol : String = ""
        
        var bothSymbol : String = ""
       
        
        
        
        
        for i in data {
            
            if selectedHomeCell == i.currName {
                
                homeSymbol = i.currSymbol
                
            }
            
            if selectedForeignCell == i.currName {
                
                foreignSymbol  = i.currSymbol
                
            }
        }
        
            var homeCode : String = ""
        
        
            var foreignCode : String = ""
            
            
            
            for i in data {
                
                if selectedForeignCell == i.currName {
                    
                    foreignCode = i.currCode
                }
                
                if selectedHomeCell == i.currName {
                    
                    homeCode = i.currCode
                }
                
            }
        
            
            bothSymbol = homeCode + foreignCode
            
            
            let rate: Float = Float(self.currencyDict[bothSymbol]!)!
        
            
            let convertedAmount: Float = num * rate
        
            
            convertedAmountLabel.isHidden = false
        
          
            convertedAmountLabel.text = homeSymbol + String(format: "%.2f", num) + " is " +  foreignSymbol + String(format: "%.2f", convertedAmount)
        
        
    }

        
     var data = CurrencyData.list.shared.c
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
