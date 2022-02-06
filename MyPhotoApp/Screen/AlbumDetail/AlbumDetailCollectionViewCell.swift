//
//  AlbumDetailCollectionViewCell.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/05.
//

import UIKit
import Photos

class AlbumDetailCollectionViewCell: UICollectionViewCell {

    //MARK: - Property
    @IBOutlet weak var albumImage: UIImageView!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Action
    
    // 셀 값 설정 함수
    func setCell(currentAsset: PHAsset){
        // 이미지 파일 가져오기
        AlbumManager.shared.getAlbumImage(asset: currentAsset){ (image) in
            self.albumImage.image = image
        }
    }
}
