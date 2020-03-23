//
//  ViewController.swift
//  cathayHolding
//
//  Created by wei on 2020/3/24.
//  Copyright © 2020 orange. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    let frontView = UIView()
    var frontViewTopAnchor = NSLayoutConstraint()
    let bgNavView = BGNavView()
    let newNavView = NewNavView()
    let tableview = UITableView()
    var offset :Int = 0
    var dataArray = [[String:AnyObject]]()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        self.view.addSubview(bgNavView)
        bgNavView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgNavView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bgNavView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bgNavView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgNavView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        frontView.backgroundColor = UIColor.yellow
        self.view.addSubview(frontView)
        frontView.translatesAutoresizingMaskIntoConstraints = false
        frontViewTopAnchor = frontView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:150)as NSLayoutConstraint
        NSLayoutConstraint.activate([
            frontViewTopAnchor,
            frontView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            frontView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        newNavView.alpha = 0
        frontView.addSubview(newNavView)
        newNavView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newNavView.topAnchor.constraint(equalTo: frontView.topAnchor),
            newNavView.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            newNavView.trailingAnchor.constraint(equalTo: frontView.trailingAnchor)
        ])
        
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        frontView.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: newNavView.bottomAnchor),
            tableview.bottomAnchor.constraint(equalTo: frontView.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: frontView.trailingAnchor)
        ])
        
        retrieveData(limit: 20, offset: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let F_Name_Ch = self.dataArray[indexPath.row]["F_Name_Ch"] as? String
        let F_Location = self.dataArray[indexPath.row]["F_Location"] as? String
        let F_Feature = self.dataArray[indexPath.row]["F_Feature"] as? String
        let F_Pic01_URL = self.dataArray[indexPath.row]["F_Pic01_URL"] as? String
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "F_Name_Ch : \(String(describing: F_Name_Ch)) \n F_Location : \(String(describing: F_Location)) \n F_Feature : \(String(describing: F_Feature)) \n  F_Pic01_URL : \(String(describing: F_Pic01_URL))"
        
     return cell
    }
    
    
    
    
    var lastPosition :CGFloat = 0.0
    let maxConstant = 150
    let minConstant = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = lastPosition - scrollView.contentOffset.y
        lastPosition = scrollView.contentOffset.y
        
        if ( offset > 0 && scrollView.contentOffset.y < 0 ) {
            let moved = frontViewTopAnchor.constant + offset
            frontViewTopAnchor.constant = moved < 0 ? 0 : moved > 150 ? 150 : moved
            
            bgNavView.alpha =  frontViewTopAnchor.constant / 150
            newNavView.alpha = (150 - frontViewTopAnchor.constant) / 150
        }
        
        
        if (offset < 0 && scrollView.contentOffset.y > 0) {
            let moved = frontViewTopAnchor.constant + offset
            frontViewTopAnchor.constant = moved < 0 ? 0 : moved > 150 ? 150 : moved
            
            bgNavView.alpha =  frontViewTopAnchor.constant / 150
            newNavView.alpha = (150 - frontViewTopAnchor.constant) / 150
            
            if frontViewTopAnchor.constant != 0 {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                lastPosition = 0
            }
        }
    
     
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        autoUpDown()
        
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= 0 {
            retrieveData(limit: 20, offset: offset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        autoUpDown()
        
    }
    
    
    func autoUpDown () {
        if self.frontViewTopAnchor.constant > 75 {
            UIView.animate(withDuration: 0.5) {
                self.frontViewTopAnchor.constant = 150
                self.bgNavView.alpha =  self.frontViewTopAnchor.constant / 150
                self.newNavView.alpha = (150 - self.frontViewTopAnchor.constant) / 150
            }
        }
        
        if self.frontViewTopAnchor.constant <= 75 {
            UIView.animate(withDuration: 0.5) {
                self.frontViewTopAnchor.constant = 0
                self.bgNavView.alpha =  self.frontViewTopAnchor.constant / 150
                self.newNavView.alpha = (150 - self.frontViewTopAnchor.constant) / 150
            }
        }
        
    }
    
    func retrieveData(limit:Int, offset:Int) {
        let url = URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f18de02f-b6c9-47c0-8cda-50efad621c14&limit=\(limit)&offset=\(offset)")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                guard let data = data else { return }
                
                let dataDic = try JSONSerialization.jsonObject(with: data) as! [String:[String:AnyObject]]
                
                let newArray = dataDic["result"]!["results"] as! [[String:AnyObject]]
                self.dataArray += newArray
                self.offset += 20
                DispatchQueue.main.async{
                    self.tableview.reloadData()
                }
                print(self.dataArray)
            } catch {
                print("error")
            }
        }
        
        task.resume()
    }
}

