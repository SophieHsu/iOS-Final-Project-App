//
//  TodoViewController.swift
//  Project-App
//
//  Created by erin on 2017/5/3.
//  Copyright © 2017年 Erin Zhang. All rights reserved.
//

import UIKit

var list = ["iOS Game","Run 5 miles","iOS APP", "Movie"]

class TodoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var MyTableView: UITableView!


    @IBAction func BackButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController"){
            show(vc,sender: self)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (list.count)
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            list.remove(at: indexPath.row)
            MyTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to: IndexPath) {
        let temp = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(temp,at : to.row)
    }


    override func viewDidAppear(_ animated: Bool) {
        MyTableView.isEditing = true
        MyTableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
