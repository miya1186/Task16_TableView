//
//  ViewController.swift
//  tableView
//
//  Created by miyazawaryohei on 2020/08/17.
//  Copyright © 2020 miya. All rights reserved.
//

import UIKit


struct Fruit {
    var name: String
    var isChecked: Bool
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    var fruitItemIndex = Int()
    //fruitItemsを初期化
    private var fruitItems: [Fruit] = [
        Fruit(name:"りんご", isChecked: false),
        Fruit(name:"みかん", isChecked: true),
        Fruit(name:"バナナ", isChecked: false),
        Fruit(name:"パイナップル", isChecked: true)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.fruitItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let fruitItem = self.fruitItems[indexPath.row]
        cell.cellImage.image = nil
        
        if fruitItem.isChecked {
            cell.cellImage.image = UIImage(named: "checkmark")
        } else {
            cell.cellImage.image = nil
        }
        
        cell.label.text = fruitItem.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let check = fruitItems[indexPath.row].isChecked
        fruitItems[indexPath.row].isChecked = !check
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        fruitItemIndex = indexPath.row
        performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "AddSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        if let add = nav?.topViewController as? AddViewController{
            
            switch segue.identifier ?? "" {
            case "AddSegue":
                add.mode = AddViewController.Mode.add
            case "EditSegue":
                add.mode = AddViewController.Mode.edit
                if let indexPath = sender as? IndexPath{
                    let item = self.fruitItems[indexPath.row]
                    add.fruitName = item.name 
                }
            default:
                break
            }
            add.fruitName = self.fruitItems[fruitItemIndex].name
        }
    }
    
    @IBAction func exitCancell(segue:UIStoryboardSegue){
    }
    
    @IBAction func exitSaveAddSegue(segue:UIStoryboardSegue){
        let addVC = segue.source as? AddViewController
        if let addText = addVC?.addTextField.text{
            fruitItems.append(Fruit(name:addText, isChecked:false))
        }
        tableView.reloadData()
    }
    
    @IBAction func exitSaveEditSegue(segue:UIStoryboardSegue){
        if let addVC = segue.source as? AddViewController{
            let indexPath = fruitItemIndex
            fruitItems[indexPath].name = addVC.addTextField.text!
            tableView.reloadData()
        }
    }
}

