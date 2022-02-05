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
    
    // 앨범 콜렉션
    var albumCollection = PHAssetCollection()

    // 앨범 제목
    var albumTitle = String()
    
    // 앨범 내 사진 개수
    var albumCount = Int()
    
    // 앨범 이미지 배열
    var albumImageArray: PHFetchResult<PHAsset>?
    
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
        albumImageArray = PHAsset.fetchAssets(in: albumCollection, options: .none)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "AlbumDetailCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "AlbumDetailCollectionViewCell")
    }
}

// MARK: - Extension
extension AlbumDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumDetailCollectionViewCell", for: indexPath) as? AlbumDetailCollectionViewCell {
            let option = PHImageRequestOptions()
            PHImageManager.default().requestImage(for: albumImageArray![indexPath.row], targetSize: CGSize(width: 70, height: 70), contentMode: .default, options: option, resultHandler: {(result, info) -> Void in
                cell.albumImage.image = result!
            })
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (self.view.bounds.size.width) / 3 , height:  (self.view.bounds.size.width) / 3)
        return size
    }
}

