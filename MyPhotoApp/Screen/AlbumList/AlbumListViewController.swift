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
    
    // 앨범 리스트 배열
    var albumList = [Album]()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        // 사진 라이브러리 권한 요청
        AlbumManager.shared.requestPhotoPermission(){ result in
            switch result {
                case .success:
                    // 앨범 리스트 가져오기
                    self.albumList = AlbumManager.shared.getAlbumList()
                    
                    // 테이블 뷰 리로드
                    DispatchQueue.main.async {
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                    break
                    
                case .fail:
                    self.presentAlert(title: "권한 에러", message: "사진 접근 권한을 승인해주세요.", isDoneTitle: "설정으로 이동", isCancelActionIncluded: true, handler: self.photoPermissionHandler)
                    break
            }
        }
    }
    
    //MARK: - Action
    
    // 테이블 뷰 세팅
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumListTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "AlbumListTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
    }
    
    // 앨범 상세 페이지로 이동
    func goAlbumDetail(album: Album){
        let detailStoryboard = UIStoryboard(name: "AlbumDetailStoryboard", bundle: nil)
        guard let detailVC = detailStoryboard.instantiateViewController(identifier: "AlbumDetailViewController") as? AlbumDetailViewController else {
            return
        }
        
        detailVC.albumAssets = album.albumAssets
        detailVC.albumTitle = album.albumTitle ?? "제목 없음"
        detailVC.albumCount = album.albumCount
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 사진 권한 설정 페이지로 이동
    func photoPermissionHandler(alert: UIAlertAction!) {
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url)
        }
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
            
            // 셀 값 설정
            cell.setCell(currentAlbum: albumList[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 클릭 시 앨범 상세보기 페이지로 이동
        goAlbumDetail(album: albumList[indexPath.row])
    }
}
