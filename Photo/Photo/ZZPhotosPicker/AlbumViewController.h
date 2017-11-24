//
//  AlbumViewController.h
//  Photo
//
//  Created by zhuangzhe on 2017/8/2.
//  Copyright © 2017年 腕表之家. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)    UITableView * tableView;
@property (nonatomic,strong)    NSMutableArray *albumArray;

@end
