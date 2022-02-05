//
//  AlbumListViewController.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {
    
    //MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    
    var albumList = [Album]()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 사진 라이브러리 권한 요청
        AlbumManager.shared.requestPhotoPermission(){ str in
            // 앨범 리스트 가져오기
            self.albumList = AlbumManager.shared.getAlbumList()
            
            // 테이블 뷰 세팅
            self.setTableView()
        }
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
        return albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTableViewCell") as? AlbumListTableViewCell {
            
            cell.selectionStyle = .none
            
            let currentAlbum = albumList[indexPath.row]
            
            cell.albumCountLabel.text = String(currentAlbum.albumCount)
            cell.albumTitleLabel.text = currentAlbum.albumTitle
            
            // 썸네일 이미지 정보 얻어오기
            if let image = currentAlbum.thumbnailImage{
                let option = PHImageRequestOptions()
                PHImageManager.default().requestImage(for: image, targetSize: CGSize(width: 70, height: 70), contentMode: .default, options: option, resultHandler: {(result, info) -> Void in
                    cell.thumbnailImageView.image = result!
                })
            }else{
                cell.thumbnailImageView.image = #imageLiteral(resourceName: "defaultImage") // 사진 개수가 0일때 디폴트 이미지
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("선택된 행은 \(indexPath.row) 입니다.")
    }
}
