//
//  AlbumDetailViewController.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/05.
//

import UIKit
import Photos

class AlbumDetailViewController: UIViewController {
    
    //MARK: - Property
    // 사진 목록
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 앨범 제목
    var albumTitle = String()
    
    // 앨범 내 사진 개수
    var albumCount = Int()
    
    // 앨범 이미지 배열
    var albumAssets: PHFetchResult<PHAsset>?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
    }
    
    //MARK: - Action
    func setUI(){
        navigationItem.title = albumTitle
    }
    
    func setCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "AlbumDetailCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "AlbumDetailCollectionViewCell")
    }
}

// MARK: - Extension
extension AlbumDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumDetailCollectionViewCell", for: indexPath) as? AlbumDetailCollectionViewCell {
            
            // 셀 값 설정
            cell.setCell(currentAsset: albumAssets![indexPath.row])
    
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 한줄에 3개의 사진이 출력되도록 지정
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        let numberOfCells: CGFloat = 3
        let width = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))
        
        return CGSize(width: width/(numberOfCells), height: width/(numberOfCells))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 이미지 파일 정보 출력
        AlbumManager.shared.getImageFileInfo(asset: albumAssets![indexPath.row]){ message in
            self.presentAlert(title: "사진 정보", message: message)
        }
    }
}

