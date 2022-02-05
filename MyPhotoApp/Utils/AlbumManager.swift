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
            - 권한 요청이 허용된 경우에만 앨범 리스트를 가져옴
     */
    func requestPhotoPermission(completion: @escaping(String?) -> Void) {
        
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
            case .authorized:
                completion("User permited")
                
            case .denied:
                print("Photo Authorization status is denied.")
                
            case .notDetermined:
                print("Photo Authorization status is not determined.")
                PHPhotoLibrary.requestAuthorization() { []
                    (status) in
                    switch status {
                    case .authorized:
                        completion("User permited")
                    case .denied:
                        print("User denied.")
                        return
                    default:
                        return
                    }
                }
                
            case .restricted:
                print("Photo Authorization status is restricted.")
                
            default:
                return
            }
    }
    
    /**
     `getAlbumList`: 앨범 리스트를 가져오는 함수
        1. 최근 항목
        2. 사용자 지정 앨범(최신순 정렬)
        3. 즐겨찾는 항목
     */
    func getAlbumList() -> [Album] {

        // 최신순 정렬
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]

        var albumList = [Album]()
        
        // 최근 항목
        let recentAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: albumOptions)
        
        // 사용자 지정 앨범
        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: albumOptions)
        
        // 즐겨찾는 항목
        let favoriteAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: albumOptions)
        
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
            let assets = PHAsset.fetchAssets(in: collection, options: .none)
            let album = Album(thumbnailImage: assets.firstObject, albumTitle: collection.localizedTitle, albumCount: assets.count, albumCollection: collection)
            completion(album)
        }
    }
}
