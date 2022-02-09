# 나의 사진첩 앱 <img width=28px src=https://user-images.githubusercontent.com/77331348/152672188-99afe52b-d728-4909-ac5a-a7f8cb13f340.png>

## 📌 시연 영상

<img width="250" src="./시연 영상/미리보기1.gif"> <img width="250" src="./시연 영상/미리보기2.gif">

## 📌 과제 설명

 `앨범 리스트 및 앨범 내 사진 이미지, 파일 정보를 확인할 수 있는 앱`
```
 - 휴대폰 내의 앨범 리스트를 불러와서 출력합니다.
 - 각 항목 클릭하면 앨범 상세로 진입해, 사진 모아보기 화면으로 이동합니다.
 - 사진은 최신순으로 출력합니다.
 - 사진 클릭 시, 사진 상세 데이터(파일명 / 파일크기)를 출력합니다.
```

## 📌 개발 스택

<table>
<tbody>
<tr style="height: 43px;">
<td style="width: 50%; height: 61px;" rowspan="2">개발 환경</td>
<td style="width: 50%; height: 43px;">iOS 13.0+</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Xcode 12.5</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 54px;" rowspan="3">개발 방식</td>
<td style="width: 50%; height: 18px;">MVC&nbsp;패턴</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Storyboard&nbsp;기반</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">UIkit,&nbsp;Photos</td>
</tr>
</tbody>
</table>

## 📌 파일 구조
```
 MyPhotoApp
 ├── Model
 │  └── Album.swift
 ├── Screen
 │  ├── AlbumList
 │  │  ├── AlbumListViewController.swift
 │  │  ├── AlbumListStoryboard.storyboard
 │  │  ├── AlbumListTableViewCell.xib
 │  │  └── AlbumListTableViewCell.swift
 │  └── AlbumDetail
 │     ├── AlbumDetailViewController.swift
 │     ├── AlbumDetailStoryboard.storyboard
 │     ├── AlbumDetailCollectionViewCell.xib
 │     └── AlbumDetailCollectionViewCell.swift
 └── Utils
      ├── Extension.swift
      └── AlbumManager.swift

```
* `Album` : 앨범 리스트 데이터를 담는 구조체입니다.
* `AlbumList` : 앨범 리스트 화면을 구성합니다.
* `AlbumDetail` : 앨범별 사진 모아보기 화면을 구성합니다.
* `Extension` : 기본 알림창 관련 메소드가 정의되어 있습니다.
* `AlbumManager` : 사진 라이브러리 관련 주요 메소드가 정의되어 있습니다.

## 📌 구현 내용
### 1. 앨범 리스트
<img width="250" src="https://user-images.githubusercontent.com/77331348/152673882-894e9b4a-452a-4756-af2a-2deaf2031217.png">
<details markdown="1">
<summary>사진 라이브러리 권한 요청</summary>

```swift
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
```

</details>
<details markdown="1">
<summary>앨범 리스트 가져오기</summary>

```swift
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
```

</details>
<details markdown="1">
<summary>앨범 타입 변환, 최신순 정렬</summary>

```swift
    /**
     `changeAlbumType`: 타입을 PHAssetCollection 배열에서 Album으로 바꿔주는 함수
        - 최신순으로 assets 정렬 포함
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
```

</details>
<hr>

### 2. 앨범별 사진 모아보기
<img width="250" src="https://user-images.githubusercontent.com/77331348/152673964-deca87f8-36c9-48fc-8ca4-23224aa62cec.png">

<details markdown="1">
<summary>앨범 내 이미지 파일 가져오기</summary>

```swift
    /**
     `getAlbumImage`: 앨범 내 이미지 파일을 가져오는 함수
     */
    func getAlbumImage(asset: PHAsset, completion: @escaping(UIImage) -> Void){
        let option = PHImageRequestOptions()
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 70, height: 70), contentMode: .default, options: option, resultHandler: {(result, info) in

            completion(result!)
        })
    }
```

</details>
<hr>

### 3. 사진 상세데이터
<img width="250" src="https://user-images.githubusercontent.com/77331348/152673983-7f7074c5-f447-4313-be36-3dcdae28bfcf.png">

<details markdown="1">
<summary>앨범 내 이미지 파일 정보 가져오기</summary>

```swift
    /**
     `getImageFileInfo`: 앨범 내 이미지 파일 정보를 가져오는 함수
         1. 파일 이름
         2. 파일 크기(MB 변환)
     */
    func getImageFileInfo(asset: PHAsset, completion: @escaping(String) -> Void){
        let resources = PHAssetResource.assetResources(for: asset)
        
        if let resource = resources.first {
            // 파일 이름 가져오기
            let fileName = resource.originalFilename
            
            // 파일 크기 가져오기
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            
            // 파일 크기 MB 변환
            let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            let fileSize = String(format: "%.2f", Double(sizeOnDisk) / (1024.0 * 1024.0))+" MB"
            
            // 파일 정보 알림창 출력
            let message = "파일명 : \(fileName) \n파일 크기 : \(fileSize)"
            completion(message)
        }
    }
```

</details>
