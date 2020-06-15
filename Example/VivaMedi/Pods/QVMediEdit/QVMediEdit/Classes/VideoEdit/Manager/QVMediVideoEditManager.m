//
//  QVVideoEditManager.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVMediVideoEditManager.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "QVBaseNavigationController.h"
#import <YYCategories/YYCategories.h>
#import "QVMediAlbumMediaItem.h"
#import "TZImagePickerController.h"
@import CoreServices;
@import Photos;

@interface QVMediVideoEditManager ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) void(^finish)(void);

@property (nonatomic, copy) void(^selectItemFinish)(QVMediAlbumMediaItem *mediaItem);

@end

@implementation QVMediVideoEditManager

#pragma mark- 单利
static QVMediVideoEditManager *_instance;
static dispatch_once_t onceToken;

+ (instancetype _Nonnull)sharedInstance {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)selectMediaItemFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish {
    [self showMediaPickerForType:2 mediaCount:1 callback:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        PHAsset * asset = assets.firstObject;
        QVMediAlbumMediaItem * item = [self albumMediaItemWithAsset:asset];
        if (finish) {
            finish(item);
        }
    }];
}

- (void)selectOneVideoFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish {
    [self showMediaPickerForType:1 mediaCount:1 callback:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        PHAsset * asset = assets.firstObject;
        QVMediAlbumMediaItem * item = [self albumMediaItemWithAsset:asset];
        if (finish) {
            finish(item);
        }
    }];
}

- (void)selectImageFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish {
    [self showMediaPickerForType:0 mediaCount:1 callback:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        PHAsset * asset = assets.firstObject;
        QVMediAlbumMediaItem * item = [self albumMediaItemWithAsset:asset];
        if (finish) {
            finish(item);
        }
    }];
}

- (void)showMediaPickerForType:(NSInteger)type mediaCount:(NSInteger)mediaCount callback:(void(^)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto))callback {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.maxImagesCount = mediaCount;
    if (type == 0) {
        // 图片
        imagePickerVc.allowPickingMultipleVideo = NO;
    } else if (type == 1) {
        // 视频
        imagePickerVc.allowPickingImage = NO;
    } else if (type == 2) {
        // 所有
        imagePickerVc.allowPickingMultipleVideo = YES;
    }
    
    [imagePickerVc setDidFinishPickingPhotosHandle:callback];
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        if (callback) {
            callback(nil, @[asset], NO);
        }
    }];
    
    [getCurrentViewController().navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

+ (NSString *)qvmedi_engineLocalIdentifier:(PHAsset *)phAsset
{
    NSString *fileName = [phAsset valueForKey:@"filename"];
    NSArray *nameArray = [fileName componentsSeparatedByString:@"."];
    NSString *videoLocalIdentifier;
    if (nameArray.count >= 2) {
        videoLocalIdentifier = [NSString stringWithFormat:@"PHASSET://%@.%@",phAsset.localIdentifier,nameArray[1]];
    }
    
    return videoLocalIdentifier;
}

- (double)qvmedi_getRealDuration:(PHAsset *)asset {
    if (![asset isKindOfClass:[PHAsset class]]) {
        return 1;
    }
          
    PHAsset *phAsset = asset;
    __block double dur = 0;
    if (phAsset.mediaSubtypes == PHAssetMediaSubtypeVideoHighFrameRate ||
        phAsset.mediaSubtypes == PHAssetMediaSubtypeVideoTimelapse) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version =  PHVideoRequestOptionsVersionCurrent;
        options.networkAccessAllowed = NO;
        [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dur = CMTimeGetSeconds(asset.duration);
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (!isnan(dur) && dur>0) {
            return dur;
        }
        
        if (isnan(dur) || !dur) {
            dur = phAsset.duration;
        }
    } else {
        dur = phAsset.duration;
    }
          
    return dur;
}

- (QVMediAlbumMediaItem *)albumMediaItemWithAsset:(PHAsset *)asset
{
    QVMediAlbumMediaItem *item = [[QVMediAlbumMediaItem alloc] init];
    item.originData = asset;
    item.mediaType = [asset mediaType] == PHAssetMediaTypeVideo ? QVMediAssetMediaTypeVideo : QVMediAssetMediaTypeImage;
    item.sourceType = QVMediMediaSourceTypePHPhoto;
    item.pixelWidth = asset.pixelWidth;
    item.pixelHeight = asset.pixelHeight;
    item.filePath = [self.class qvmedi_engineLocalIdentifier:asset];
    CGFloat duration = [self qvmedi_getRealDuration:asset] * 1000;;
    item.duration = duration;
    item.startPoint = 0;
    item.endPoint = duration;
    
    item.orientation = UIImageOrientationUp;
    
    return item;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        PHAsset * asset = [info objectForKey:UIImagePickerControllerPHAsset];
        QVMediAlbumMediaItem * item = [self albumMediaItemWithAsset:asset];
        
        if (self.selectItemFinish) {
            self.selectItemFinish(item);
            self.selectItemFinish = nil;
            return ;
        }
        
        if ([XYEngineWorkspace clipMgr].clipModels.count > 0) {
            [self insertClip:@[item] index:-1];
        } else {
            XYQprojectModel *newProject = [XYEngineWorkspace projectMgr].currentProjectModel;
            newProject.taskID = XYCommonEngineTaskIDQProjectCreate;
            [[XYEngineWorkspace projectMgr] runTask:newProject];
            @weakify(self)
            [[XYEngineWorkspace projectMgr] addObserver:self observerID:XYCommonEngineTaskIDQProjectCreate block:^(id  _Nonnull obj) {
                @strongify(self)
                
                XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
                sbModel.taskID = XYCommonEngineTaskIDStoryboardRatio;
                sbModel.ratioValue = 16/9.0;
                [[XYEngineWorkspace stordboardMgr] runTask:sbModel];

                [self insertClip:@[item] index:-1];
            }];
        }
    }];
}

- (void)addClip:(NSInteger)index finish:(void(^)(void))finish {
    self.finish = finish;
    [self showMediaPickerForType:2 mediaCount:9 callback:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSMutableArray<QVMediAlbumMediaItem *> * itemList = [NSMutableArray arrayWithCapacity:assets.count];
        
        [assets enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QVMediAlbumMediaItem * item = [self albumMediaItemWithAsset:obj];
            [itemList addObject:item];
        }];

        if ([XYEngineWorkspace clipMgr].clipModels.count > 0) {
            [self insertClip:itemList index:-1];
        } else {
            XYQprojectModel *newProject = [XYEngineWorkspace projectMgr].currentProjectModel;
            newProject.taskID = XYCommonEngineTaskIDQProjectCreate;
            [[XYEngineWorkspace projectMgr] runTask:newProject];
            @weakify(self)
            [[XYEngineWorkspace projectMgr] addObserver:self observerID:XYCommonEngineTaskIDQProjectCreate block:^(id  _Nonnull obj) {
                @strongify(self)
                
                XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
                sbModel.taskID = XYCommonEngineTaskIDStoryboardRatio;
                sbModel.ratioValue = 16/9.0;
                [[XYEngineWorkspace stordboardMgr] runTask:sbModel];

                [self insertClip:itemList index:-1];
            }];
        }
    }];
}

- (void)selectVideoFinish:(void(^)(void))finish {
    [self addClip:0 finish:finish];
}

- (void)insertClip:(NSArray<QVMediAlbumMediaItem *> *)mediaList index:(NSInteger)index {
    index += 1;//TODO: 插入后一位 index += 1
    __block NSMutableArray *clipArr = [[NSMutableArray alloc] initWithCapacity:mediaList.count];
    [mediaList enumerateObjectsUsingBlock:^(QVMediAlbumMediaItem * _Nonnull mediaItem, NSUInteger idx, BOOL * _Nonnull stop) {
        XYClipModel *clipModel = [[XYClipModel alloc] init];
        clipModel.sourceVeRange.dwPos = mediaItem.startPoint;
        clipModel.sourceVeRange.dwLen = mediaItem.endPoint - mediaItem.startPoint;
        clipModel.clipFilePath = mediaItem.filePath;
//        clipModel.rotation = [mediaItem angleDegreeFormOrientation:mediaItem.orientation];
        clipModel.clipIndex = index + idx;
        [clipArr addObject:clipModel];
    }];
    XYClipModel *taskModel = [[XYClipModel alloc] init];
    taskModel.taskID = XYCommonEngineTaskIDClipAddClip;
    taskModel.clipModels = clipArr;
    [[XYEngineWorkspace clipMgr] runTask:taskModel];
    
    [[XYEngineWorkspace clipMgr] addObserver:self observerID:XYCommonEngineTaskIDClipAddClip block:^(id  _Nonnull obj) {
        NSLog(@"[XYEngineWorkspace clipMgr].clipModels--->%@",[XYEngineWorkspace clipMgr].clipModels);
        self.finish();
    }];

}

- (void)removeObserver {
    [[XYEngineWorkspace clipMgr] removeObserver:self observerID:XYCommonEngineTaskIDClipAddClip];
    [[XYEngineWorkspace projectMgr] removeObserver:self observerID:XYCommonEngineTaskIDQProjectCreate];
}

- (void)dealloc {
    NSLog(@"XYVideoEditManager dealloc");
    [self removeObserver];
}

@end
