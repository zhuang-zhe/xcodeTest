//
//  AlbumViewController.m
//  Photo
//
//  Created by zhuangzhe on 2017/8/2.
//  Copyright © 2017年 腕表之家. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#import "AlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumPHAssetViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"相册"];
    //
    _albumArray = [[NSMutableArray alloc] initWithCapacity:8];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView.layer setMasksToBounds:NO];
    [_tableView setScrollsToTop:NO];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableFooterView=[[UIView alloc]init];
    
    [self.view addSubview:_tableView];
    [self loadAlbum];
}

//1.获得所有相簿的原图
- (void)loadAlbum
{
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary  options:nil].lastObject;
    [_albumArray addObject:cameraRoll];
    //
    // live
    PHAssetCollection *live = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumLivePhotos  options:nil].lastObject;
    [_albumArray addObject:live];
    // 最近增加
    PHAssetCollection *last = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded  options:nil].lastObject;
    [_albumArray addObject:last];
    //
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [_albumArray addObject:assetCollection];
    }
    [_tableView reloadData];
    
    
}
/*
enum PHAssetCollectionType : Int {
case Album //从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
case SmartAlbum //经由相机得来的相册
case Moment //Photos 为我们自动生成的时间分组的相册
}

enum PHAssetCollectionSubtype : Int {
case AlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
case AlbumSyncedEvent //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
case AlbumSyncedFaces //使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
case AlbumSyncedAlbum //做了 AlbumSyncedEvent 应该做的事
case AlbumImported //从相机或是外部存储导入的相册，完全没有这方面的使用经验，没法验证。
case AlbumMyPhotoStream //用户的 iCloud 照片流
case AlbumCloudShared //用户使用 iCloud 共享的相册
case SmartAlbumGeneric //文档解释为非特殊类型的相册，主要包括从 iPhoto 同步过来的相册。由于本人的 iPhoto 已被 Photos 替代，无法验证。不过，在我的 iPad mini 上是无法获取的，而下面类型的相册，尽管没有包含照片或视频，但能够获取到。
case SmartAlbumPanoramas //相机拍摄的全景照片
case SmartAlbumVideos //相机拍摄的视频
case SmartAlbumFavorites //收藏文件夹
case SmartAlbumTimelapses //延时视频文件夹，同时也会出现在视频文件夹中
case SmartAlbumAllHidden //包含隐藏照片或视频的文件夹
case SmartAlbumRecentlyAdded //相机近期拍摄的照片或视频
case SmartAlbumBursts //连拍模式拍摄的照片，在 iPad mini 上按住快门不放就可以了，但是照片依然没有存放在这个文件夹下，而是在相机相册里。
case SmartAlbumSlomoVideos //Slomo 是 slow motion 的缩写，高速摄影慢动作解析，在该模式下，iOS 设备以120帧拍摄。不过我的 iPad mini 不支持，没法验证。
case SmartAlbumUserLibrary //这个命名最神奇了，就是相机相册，所有相机拍摄的照片或视频都会出现在该相册中，而且使用其他应用保存的照片也会出现在这里。
case Any //包含所有类型
}
*/

/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
//    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSString *albumStr = [self transformAblumTitle:assetCollection.localizedTitle];
    NSString *albumTitle = [NSString stringWithFormat:@"相簿名:%@(%ld)", albumStr,assets.count];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dict setObject:assetCollection forKey:@"albumUrl"];
    [dict setObject:albumTitle forKey:@"albumTitle"];
    
    if (assets.count>0) {
        PHAsset *asset = [assets lastObject];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            if (result) {
                [dict setObject:result forKey:@"albumImage"];
            }
        }];
    }
    
    
    
//    for (PHAsset *asset in assets) {
//        // 是否要原图
//        CGSize size = original ? CGSizeMake(SCREEN_WIDTH *[UIScreen mainScreen].scale, SCREEN_HEIGHT *[UIScreen mainScreen].scale) : CGSizeZero;
//        
//        // 从asset中获得图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"%@", result);
//        }];
//    }
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"Bursts"]) {
        return @"爆发";
    }else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景";
    }else if ([title isEqualToString:@"Hidden"]) {
        return @"隐藏";
    }else if ([title isEqualToString:@"Time-lapse"]) {
        return @"定时";
    }
    return title;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if([self numberOfSectionsInTableView:tableView]==(section+1)){
        return [UIView new];
    }
    return nil;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHAssetCollection *assetCollection = [_albumArray objectAtIndex:indexPath.row];

    static NSString *UnknowCellIdentifier = @"UnknowCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:UnknowCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UnknowCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
//    [cell setBackgroundColor:RGBA(255, 192, 203, 1)];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSString *albumStr = [self transformAblumTitle:assetCollection.localizedTitle];
    NSString *albumTitle = [NSString stringWithFormat:@"%@(%ld)", albumStr,assets.count];
    [cell.textLabel setText:albumTitle];
    if (assets.count>0) {
        PHAsset *asset = [assets lastObject];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            if (result) {
                [cell.imageView setImage:result];

            }
        }];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHAssetCollection *assetCollection = [_albumArray objectAtIndex:indexPath.row];
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSString *albumStr = [self transformAblumTitle:assetCollection.localizedTitle];
    NSString *albumTitle = [NSString stringWithFormat:@"%@(%ld)", albumStr,assets.count];
    AlbumPHAssetViewController *detailVC = [[AlbumPHAssetViewController alloc] init];
    detailVC.album = assetCollection;
    detailVC.albumName = albumTitle;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 
 第三步，让图片动起来
 
 PhotosUI框架为我们提供了两种LivePhoto的动态效果，一种为持续数秒，第二种为全部循环展示。
 可通过如下方法进行调用
 
 //效果1
 [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
 //效果2
 [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
 对应的停止动画的方法为
 
 [photoView stopPlayback];
 
 //
 PHAsset *phAsset = (PHAsset *)asset;
 if (phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
 PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
 //        photoView.livePhoto = phAsset //[info objectForKey:UIImagePickerControllerLivePhoto];
 photoView.contentMode = UIViewContentModeScaleAspectFill;
 [self.view addSubview:photoView];
 //
 PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
 options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
 
 [[PHImageManager defaultManager] requestLivePhotoForAsset:phAsset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
 photoView.livePhoto = livePhoto;
 }];
 
 }
 
*/

@end
