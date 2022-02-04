//
//  AlbumListViewController.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import UIKit

class AlbumListViewController: UIViewController {
    
    //MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    //MARK: - Action
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumListTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "AlbumListTableViewCell")
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Extension
extension AlbumListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTableViewCell") as? AlbumListTableViewCell {
                cell.selectionStyle = .none
            return cell
        }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("선택된 행은 \(indexPath.row) 입니다.")
    }
}
