//
//  AlbumManager.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/04.
//

import Foundation
import Photos

class AlbumManager {

    /**
     `requestPhotoPermission`: 사진 라이브러리 권한 요청 함수
            - 권한 요청이 허용된 경우에만 앨범 리스트를 가져옴
     */
    private func requestPhotoPermission() {
        
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
            case .authorized:
                print("Photo Authorization status is authorized.")
                getAlbumList()
                
            case .denied:
                print("Photo Authorization status is denied.")
                
            case .notDetermined:
                print("Photo Authorization status is not determined.")
                PHPhotoLibrary.requestAuthorization() { [self]
                    (status) in
                    switch status {
                    case .authorized:
                        print("User permiited.")
                        self.getAlbumList()
                    case .denied:
                        print("User denied.")
                        break
                    default:
                        break
                    }
                }
                
            case .restricted:
                print("Photo Authorization status is restricted.")
                
            default:
                break
            }
    }
    
    /**
     `getAlbumList`: 앨범 리스트를 가져오는 함수
        1. 최근 항목
        2. 사용자 지정 앨범(최신순 정렬)
        3. 즐겨찾는 항목
     */
    func getAlbumList() -> [PHAssetCollection] {

        // 최신순 정렬
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]

        var albumList = [PHAssetCollection]()
        // 최근 항목
        let recentAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: .none)
        // 사용자 지정 앨범
        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: albumOptions)
        // 즐겨찾는 항목
        let favoriteAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: .none)
        
        recentAlbum.enumerateObjects { (collection, _, _) in albumList.append(collection) }
        userAlbum.enumerateObjects { (collection, _, _) in albumList.append(collection) }
        favoriteAlbums.enumerateObjects { (collection, _, _) in albumList.append(collection) }
        
        return albumList
        
    }
}
