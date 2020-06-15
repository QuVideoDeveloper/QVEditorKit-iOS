//
//  QVPreviewViewController.h
//  QVEditor_Example
//
//  Created by chaojie zheng on 2020/4/10.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import "QVBaseViewController.h"
@class QVMediAlbumMediaItem;

NS_ASSUME_NONNULL_BEGIN

@interface QVPreviewViewController : QVBaseViewController

@property (nonatomic, strong) NSArray<QVMediAlbumMediaItem *> *mediaList;

@end

NS_ASSUME_NONNULL_END
