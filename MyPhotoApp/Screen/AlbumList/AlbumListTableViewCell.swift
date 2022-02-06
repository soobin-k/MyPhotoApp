//
//  AlbumListTableViewCell.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import UIKit

class AlbumListTableViewCell: UITableViewCell {

    //MARK: - Property
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Action
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 셀 값 설정 함수
    func setCell(currentAlbum: Album){
        albumCountLabel.text = String(currentAlbum.albumCount)
        albumTitleLabel.text = currentAlbum.albumTitle
        
        // 썸네일 이미지 파일 가져오기
        if let image = currentAlbum.thumbnailImage{
            AlbumManager.shared.getAlbumImage(asset: image){ (image) in
                self.thumbnailImageView.image = image
            }
        }else{ // 사진 개수가 0일 때 디폴트 이미지
            thumbnailImageView.image = #imageLiteral(resourceName: "defaultImage")
        }
    }
    
}
