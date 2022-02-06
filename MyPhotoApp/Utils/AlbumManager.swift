//
//  AlbumManager.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import Foundation
import Photos
import UIKit

class AlbumManager {
    
    // 공유 인스턴스 생성
    static let shared = AlbumManager()
    
    /**
     `requestPhotoPermission`: 사진 라이브러리 권한 요청 함수
            - 권한 요청이 허용된 경우(success)에만 앨범 리스트를 가져옴
     */
    func requestPhotoPermission(completion: @escaping(PhotoAccess) -> Void) {
        
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
        
            case .authorized: // 권한 승인
                completion(.success)
                
            case .denied: // 권한 거부
                completion(.fail)
                
            case .notDetermined: // 권한 승인 미실시
                PHPhotoLibrary.requestAuthorization() { []
                    (status) in
                    switch status {
                        case .authorized:
                            completion(.success) // 권한 승인
                        case .denied:
                            completion(.fail) // 권한 거부
                            return
                        default:
                            return
                    }
                }
                
            case .restricted:
                completion(.fail) // 권한을 부여 X
                
            default:
                return
            }
    }
    
    /**
     `getAlbumList`: 앨범 리스트를 가져오는 함수
        1. 최근 항목
        2. 사용자 지정 앨범
        3. 즐겨찾는 항목
     */
    func getAlbumList() -> [Album] {

        var albumList = [Album]()
        
        // 최근 항목
        let recentAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: .none)
        
        // 사용자 지정 앨범
        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: .none)
        
        // 즐겨찾는 항목
        let favoriteAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: .none)
        
        // 타입 변환 후 앨범 리스트에 추가
        changeAlbumType(list: recentAlbum){ album in
            albumList.append(album)
        }
        changeAlbumType(list: userAlbum){ album in
            albumList.append(album)
        }
        changeAlbumType(list: favoriteAlbum){ album in
            albumList.append(album)
        }

        return albumList
    }
    
    /**
     `changeAlbumType`: 타입을 PHAssetCollection 배열에서 Album으로 바꿔주는 함수
     */
    func changeAlbumType(list: PHFetchResult<PHAssetCollection>, completion: @escaping(Album) -> Void){
        list.enumerateObjects { (collection, _, _) in
            // 최신순 정렬
            let albumOptions = PHFetchOptions()
            albumOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let assets = PHAsset.fetchAssets(in: collection, options: albumOptions)
            let album = Album(thumbnailImage: assets.firstObject, albumTitle: collection.localizedTitle, albumCount: assets.count, albumAssets: assets)
            
            completion(album)
        }
    }
    
    /**
     `getAlbumImage`: 앨범 내 이미지 파일을 가져오는 함수
     */
    func getAlbumImage(asset: PHAsset, completion: @escaping(UIImage) -> Void){
        let option = PHImageRequestOptions()
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 70, height: 70), contentMode: .default, options: option, resultHandler: {(result, info) in

            completion(result!)
        })
    }
}

// 사진 라이브러리 접근 권한 타입
enum PhotoAccess {
    case success, fail // 권한 요청 허용, 미허용
}
