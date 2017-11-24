//
//  AlbumPHAssetViewController.h
//  Photo
//
//  Created by zhuangzhe on 2017/8/2.
//  Copyright © 2017年 腕表之家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumPHAssetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) PHAssetCollection *album;
@property (nonatomic,strong) PHFetchResult<PHAsset *> *phAssets;

typedef void(^Result)(NSData *fileData, NSString *fileName);
typedef void(^ResultPath)(NSString *filePath, NSString *fileName);
+ (void)getImageFromPHAsset:(PHAsset *)asset Complete:(Result)result;
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result;
+ (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result;
//将图片文件和视频文件保存到手机相册需要以下两个方法：
//那么如何保存 LivePhoto，对于支持 LivePhoto 的手机用户可能需要将 LivePhoto 保存到手机相册。
//但是事实上 LivePhoto 不能作为一个整体文件存在于内存硬盘或者服务器。
//但是可以将一个视频文件和图片文件一起作为 LivePhoto Asset 保存到相册：
void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void * contextInfo);
void UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, id completionTarget, SEL completionSelector, void * contextInfo);
@end
