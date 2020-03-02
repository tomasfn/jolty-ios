//
//  MyJoltyViewController.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/27/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD
import RealmSwift
import Firebase


class UserJoltysViewController: BaseViewController, FIRDatabaseReferenceable {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var noCouponsView: UIView!
    
    private var emptyJoltysView: EmptyJoltysView?
    
    var joltys: [Jolty] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Activity".localized()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: AppInitSetConfig.appFontColor(),
                                                                        NSAttributedStringKey.font: UIFont.OpenSansRegular(fontSize: 22)]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.separatorColor = tableView.backgroundColor
        
        if Auth.auth().currentUser?.uid != nil {
            addEmptyJoltysView()
            
            //below is the correct code but is kinda crashing so we get the line above
           // SVProgressHUD.show()
           // getUserJoltys()
        } else {
            addEmptyJoltysView()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func getUserJoltys() {
        joltys.removeAll()
        
        let currentUserId = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("Jolty").queryOrdered(byChild: "helpedUser").queryEqual(toValue: currentUserId)
        let ref2 = Database.database().reference().child("Jolty").queryOrdered(byChild: "saviorUser").queryEqual(toValue: currentUserId)
        
        ref.observe(.value, with:{ (snapshot: DataSnapshot) in
            
            for snap in snapshot.children {
                if let dict = snap as? DataSnapshot {
                    let jolty = Jolty(snapshot: dict)
                    self.joltys.append(jolty)
                }
            }
            
            if self.joltys.count == 0 {
                self.addEmptyJoltysView()
            } else {
                self.removeEmptyJoltysView()
            }
            
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
        
        ref2.observe(.value, with:{ (snapshot: DataSnapshot) in
            
            for snap in snapshot.children {
                if let dict = snap as? DataSnapshot {
                    let jolty = Jolty(snapshot: dict)
                    self.joltys.append(jolty)
                }
            }
            self.tableView.reloadData()
        })
    }
}

//MARK UserJoltysViewController Add Views
extension UserJoltysViewController {
    
    private func addEmptyJoltysView() {
        
        if emptyJoltysView == nil {
            
            if emptyJoltysView == nil {
                emptyJoltysView = (EmptyJoltysView.initFromNib() as? EmptyJoltysView)
            }
            
            if emptyJoltysView!.superview == nil {
                self.view.addSubview(emptyJoltysView!)
                emptyJoltysView!.snp.makeConstraints({ (make) in
                    make.left.bottom.right.top.equalTo(view)
                })
            }
        }
    }
}

//MARK UserJoltysViewController remove Views
extension UserJoltysViewController {
    private func removeEmptyJoltysView() {
        emptyJoltysView?.removeFromSuperview()
        emptyJoltysView = nil
    }
}

extension UserJoltysViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return joltys.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        // number 2 example number
    }

    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == UITableViewCellEditingStyle.delete) {

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellReusdeIdentifier = "JoltyTableViewCell"
        let cell:JoltyTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReusdeIdentifier) as! JoltyTableViewCell
        
        let currentJolty = joltys[indexPath.row]
        
        cell.JoltyDateLbl.text = currentJolty.start
        
        // Current user was helped!
        if Auth.auth().currentUser?.uid == currentJolty.helpedUserId {
            cell.JoltyActionImgView.image = UIImage.leftArrow()
            cell.getFullNameFromUserId(id: currentJolty.saviourUserId)
            
        } // Current user helped someone!
        else if Auth.auth().currentUser?.uid == currentJolty.saviourUserId {
            cell.JoltyActionImgView.image = UIImage.rightArrow()
            cell.getFullNameFromUserId(id: currentJolty.helpedUserId)
            
        }
        
        return cell
    }
}

extension UserJoltysViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedJolty = joltys[indexPath.row]
        print(selectedJolty)
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
}

//extension UserJoltysViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        return [SwipeAction]
//    }
//}





