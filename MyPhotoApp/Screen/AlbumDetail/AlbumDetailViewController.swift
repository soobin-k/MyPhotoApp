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
    
    // 파일 정보 알림창
    func alertFileInfo(fileName: String, fileSize: String) {
      let message = "파일명 : \(fileName) \n파일 크기 : \(fileSize)"
        
      let alert = UIAlertController(title: "사진 정보", message: message, preferredStyle: .alert)
        
      let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
      alert.addAction(confirmAction)

      present(alert, animated: true, completion: nil)
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
        // 한줄에 3개의 사진이 출력되도록 지정
        let size = CGSize(width: (self.view.bounds.size.width) / 3 , height:  (self.view.bounds.size.width) / 3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let resources = PHAssetResource.assetResources(for: albumImageArray![indexPath.row])
        
        if let resource = resources.first {
            // 파일 이름 가져오기
            let fileName = resource.originalFilename
            
            // 파일 크기 가져오기
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            
            // 파일 크기 MB 변환
            let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            let size = String(format: "%.2f", Double(sizeOnDisk) / (1024.0*1024.0))+" MB"
            
            // 알림창 출력
            alertFileInfo(fileName: fileName, fileSize: size)
        }
    }
}

