# 나의 사진첩 앱 <img width=28px src=https://user-images.githubusercontent.com/77331348/152672188-99afe52b-d728-4909-ac5a-a7f8cb13f340.png>

>**플로우 iOS 사전 과제**

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
