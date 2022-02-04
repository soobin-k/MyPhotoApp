//
//  Album.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import Foundation
import Photos

// 앨범 리스트
struct Album {
    let thumbnailImage: PHAsset? // 앨범 썸네일 이미지
    let albumTitle: String? // 앨범 제목
    let albumCount: Int // 앨범 내 사진 개수
    let albumCollection: PHAssetCollection // 앨범 콜렉션
}
