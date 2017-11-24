//
//  AlbumPHAssetViewController.m
//  Photo
//
//  Created by zhuangzhe on 2017/8/2.
//  Copyright © 2017年 腕表之家. All rights reserved.
//
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#import "AlbumPHAssetViewController.h"
#import <PhotosUI/PhotosUI.h>
#import "UIImage+GIF.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AlbumPHAssetViewController ()

@end

@implementation AlbumPHAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _phAssets = [PHAsset fetchAssetsInAssetCollection:_album options:nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
    
}



/**
 *  通过PHAsset返回image
 *  @param asset           文件信息
 *  @param original        是否要原图
 */
//- (UIImage *)PHAssetToImage:(PHAsset*)asset original:(BOOL)original
//{
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    // 同步获得图片, 只会返回1张图片
//    options.synchronous = YES;
//    //
//    CGSize size = original ? CGSizeMake(SCREEN_WIDTH *[UIScreen mainScreen].scale, SCREEN_HEIGHT *[UIScreen mainScreen].scale) : CGSizeZero;
//    
//    // 从asset中获得图片
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        NSLog(@"%@", result);
////        return result;
//    }];
    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _phAssets.count;
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
    PHAsset *asset = [_phAssets objectAtIndex:indexPath.row];
    
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

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@", result);
        if (result) {
            [cell.imageView setImage:result];
            
        }
    }];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHAsset *asset = [_phAssets objectAtIndex:indexPath.row];
    
    NSLog(@"%@",[asset valueForKey:@"filename"]);
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
        PHAssetResource *resource;
        
        for (PHAssetResource *assetRes in assetResources) {
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                assetRes.type == PHAssetResourceTypeVideo) {
                resource = assetRes;
            }
        }
        
        
//        PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, SCREEN_HEIGHT - 64-20)];
//        //        photoView.livePhoto = phAsset //[info objectForKey:UIImagePickerControllerLivePhoto];
//        photoView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.view addSubview:photoView];
//        //
//        PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//        
//        [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:photoView.bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
//            photoView.livePhoto = livePhoto;
//             [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
//        }];
        
    } else {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            //
            NSLog(@"压缩前%ld",imageData.length);
            NSData *data1 = [self zipGIFWithData:imageData];
            NSLog(@"压缩后%ld",data1.length);
//            UIImage *image = [UIImage sd_animatedGIFWithData:data];
            NSLog(@"---");
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH-20, SCREEN_HEIGHT - 64-20)];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView.layer setMasksToBounds:NO];
            [self.view addSubview:imageView];
            
            imageView.image = [UIImage sd_animatedGIFWithData:data1];
            
        }];
    }
    
}
- (NSData *)zipGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                duration += [UIImage sd_frameDurationAtIndex:i source:source];
        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
                ima = [ima GifZipWithRoll:count];
        [images addObject:ima];
        CGImageRelease(image);
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
    }
    animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    CFRelease(source);

    NSData *imageData = UIImageAnimatedGIFRepresentation(animatedImage, animatedImage.duration, 1, nil);
    
    return imageData;
}
#pragma mark - 压缩图片质量
- (NSData *)contextDrawImage:(UIImage *)_img
{
    float _width = _img.size.width > 1000.0f ? 1000: _img.size.width;
    float _height = _img.size.height*(_width/_img.size.width);
    
    CGRect _rect = CGRectMake(0, 0, _width, _height);
    UIImageView * _contentImgView = [[UIImageView alloc] initWithFrame:_rect];
    _contentImgView.backgroundColor =[UIColor blackColor];
    _contentImgView.contentMode = UIViewContentModeScaleAspectFit;
    _contentImgView.image = _img;
    
    UIGraphicsBeginImageContext(_contentImgView.frame.size);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    [_contentImgView.layer renderInContext:bitmap];
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    //压缩图片质量
    float kCompressionQuality = 1.0;
    NSData *photo = UIImageJPEGRepresentation(resultingImage, kCompressionQuality);
    resultingImage = [UIImage imageWithData:photo];
    //
    UIGraphicsEndImageContext();
    
    //    NSLog(@"length:%lu KB",photo.length/8/1024);
    while (photo.length/1000 > 300 && kCompressionQuality > 0 ) {
        kCompressionQuality = kCompressionQuality - 0.02;
        photo = UIImageJPEGRepresentation(resultingImage, kCompressionQuality);
        //        NSLog(@"Quality:%f,length:%lu KB",kCompressionQuality,photo.length/1000);
    }
    //    NSLog(@"%lu",photo.length/1000);
    //     UIImage *rImage = [UIImage imageWithData:photo];
    //    UIImageWriteToSavedPhotosAlbum(rImage, nil, nil, NULL);
    
    return photo;
}

__attribute__((overloadable)) NSData * UIImageAnimatedGIFRepresentation(UIImage *image, NSTimeInterval duration, NSUInteger loopCount, NSError * __autoreleasing *error) {
    if (!image.images) {
        return nil;
    }
    
    NSDictionary *userInfo = nil;
    {
        size_t frameCount = image.images.count;
        NSTimeInterval frameDuration = (duration <= 0.0 ? image.duration / frameCount : duration / frameCount);
        NSDictionary *frameProperties = @{
                                          (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge NSString *)kCGImagePropertyGIFDelayTime: @(frameDuration)
                                                  }
                                          };
        
        NSMutableData *mutableData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, kUTTypeGIF, frameCount, NULL);
        
        NSDictionary *imageProperties = @{ (__bridge NSString *)kCGImagePropertyGIFDictionary: @{
                                                   (__bridge NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)
                                                   }
                                           };
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)imageProperties);
        
        for (size_t idx = 0; idx < image.images.count; idx++) {
            CGImageDestinationAddImage(destination, [[image.images objectAtIndex:idx] CGImage], (__bridge CFDictionaryRef)frameProperties);
        }
        
        BOOL success = CGImageDestinationFinalize(destination);
        CFRelease(destination);
        
        if (!success) {
            userInfo = @{
                         NSLocalizedDescriptionKey: NSLocalizedString(@"Could not finalize image destination", nil)
                         };
            
            goto _error;
        }
        
        return [NSData dataWithData:mutableData];
    }
_error: {
    if (error) {
//        *error = [[NSError alloc] initWithDomain:AnimatedGIFImageErrorDomain code:-1 userInfo:userInfo];
    }
    
    return nil;
}
}
//



//兼顾了从 LivePhoto 里面提取视频文件。
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, fileName);
                                                             }
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}
//
+ (void)getImageFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    __block NSData *data;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
         }];
    }
    
    if (result) {
        if (data.length <= 0) {
            result(nil, nil);
        } else {
            result(data, resource.originalFilename);
        }
    }
}
//
+ (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE, fileName);
                                                             }
                                                         }];
    } else {
        result(nil, nil);
    }
}
//
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
*/

@end
