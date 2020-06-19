//
//  XYVideoEditToolbar.m
//  Pods
//
//  Created by chaojie zheng on 2020/4/15.
//

#import "QVMediVideoEditToolbar.h"
#import <XYCategory/XYCategory.h>
#import <Masonry/Masonry.h>
#import "QVMediButton.h"
#import "QVMediScrollToolbarSelectView.h"
#import "QVMediVideoToolbarOperateView.h"
#import "QVMediAddImageView.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "QVMediToolbarTool.h"
#import "QVMediToolbarManager.h"
#import "QVMediAlbumMediaItem.h"
#import <QVMediTools/UIImage+QVMedi.h>
#import "QVMediTools.h"
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>

@import Photos;

NSString * const VideoTrimBeginDuration = @"VideoTrimBeginDuration";
NSString * const VideoTrimEndDuration = @"VideoTrimEndDuration";
NSString * const VideoCutDuration = @"VideoCutDuration";
NSString * const VideoVolumeValue = @"VideoVolumeValue";
NSString * const VideoVoiceChangeValue = @"VideoVoiceChangeValue";
NSString * const VideoTotalDuration = @"VideoTotalDuration";
NSString * const VideoSpeedChangeValue = @"VideoSpeedChangeValue";
NSString * const VideoParameterAdjustment = @"VideoParameterAdjustment";




@interface QVMediVideoEditToolbar ()

@property (nonatomic, strong) NSArray *defaultToolbarDataSourceArray;

@property (nonatomic, strong) NSMutableArray *editToolBarInfoArray;

@property (nonatomic, strong) NSMutableArray *effectToolBarInfoArray;

@property (nonatomic,   copy) void(^toolbarClickBlock)(QVMediVideoEditToolbarType toolbarType);

@property (nonatomic,   copy) void(^videoEditToolbarClickBlock)(QVMediVideoEditToolbarType toolbarType, NSDictionary *toolbarTypeInfoDic, id params, BOOL executionEvent);

@property (nonatomic, strong) QVMediScrollToolbarSelectView *editToolBar;

@property (nonatomic, strong) QVMediAddImageView *addImageView;

@property (nonatomic, strong) UIScrollView *toolbarBackScrollView;

@property (nonatomic, strong) NSDictionary *curXYVideoEditToolbarTypeInfoDic;

@property (nonatomic, strong) QVMediVideoToolbarOperateView *toolbarOperateView;

@property (nonatomic, assign) QVMediVideoEditScaleType curScaleType;

@property (nonatomic, strong) NSMutableArray *effectList;//

@property (nonatomic, assign) NSInteger effectSeletedIdx;//
@property (nonatomic, assign) QVMediVideoEditToolbarType editToolBarType;
@property (nonatomic, assign) BOOL isb;

@end

@implementation QVMediVideoEditToolbar

- (void)defaultCreateToolbarClick:(void(^)(QVMediVideoEditToolbarType toolbarType, NSDictionary *toolbarTypeInfoDic, id params, BOOL executionEvent))toolbarClick {
    self.videoEditToolbarClickBlock = toolbarClick;
    [self creatUIWithData:self.defaultVideoEditToolbarDataSourceArray];
}

- (void)createVideoEditToolbarWithData:(NSArray *)dataArray toolbarClick:(void(^)(QVMediVideoEditToolbarType toolbarType))toolbarClick {
    self.toolbarClickBlock = toolbarClick;
    if (!dataArray.count) {
        dataArray = self.defaultVideoEditToolbarDataSourceArray;
    }
    [self creatUIWithData:dataArray];
}

- (void)creatUIWithData:(NSArray *)dataArray {
    self.imageArray = [NSArray new];
    self.iconImageArray = [NSMutableArray new];
    self.backgroundColor = [UIColor xy_colorWithHEX:0x101112];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _parameterAdjustmentDic = [NSMutableDictionary new];
    self.toolbarBackScrollView = [UIScrollView new];
    self.toolbarBackScrollView.backgroundColor = [UIColor clearColor];
    self.toolbarBackScrollView.showsVerticalScrollIndicator = NO;
    self.toolbarBackScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.toolbarBackScrollView];
    [self.toolbarBackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat item_W = ([UIScreen mainScreen].bounds.size.width - 40 - 4 * 24)/5;
    for (int index = 0; index < dataArray.count; index++) {
        NSDictionary *itemInfoDic = dataArray[index];
        QVMediButton *toolbarItem = [QVMediButton new];
        toolbarItem.qvmedi_ButtonType = QVMediButtonStyleUpImageBelowTitle;
        toolbarItem.xy_parameter = itemInfoDic;
        [toolbarItem setImage:[UIImage qvmedi_imageWithName:[NSString stringWithFormat:@"qv_QVUIKit_%@_normal",itemInfoDic[@"icon&title"]] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [toolbarItem setTitle:NSLocalizedString(itemInfoDic[@"icon&title"], @"") forState:UIControlStateNormal];
        if (itemInfoDic[@"title"]) {
            [toolbarItem setTitle:NSLocalizedString(itemInfoDic[@"title"], @"") forState:UIControlStateNormal];
        }
        [toolbarItem setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        toolbarItem.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [toolbarItem addTarget:self action:@selector(toolbarClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbarBackScrollView addSubview:toolbarItem];
        [toolbarItem mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(20 + index % 5 * (item_W + 24));
            make.top.mas_equalTo(40 + index / 5 * (48 + 37));
            make.width.mas_equalTo(item_W);
            make.height.mas_equalTo(48);
        }];
    }
    [self.toolbarBackScrollView.subviews.lastObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-60);
    }];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain block:^(id  _Nonnull obj) {
        XYBaseEngineTask *task = obj;
        if (XYCommonEngineTaskIDEffectVisionAdd == task.taskID || XYCommonEngineTaskIDEffectVisionDelete == task.taskID || XYCommonEngineTaskIDEffectVisionTextAdd == task.taskID) {
            [self updateAddImageViewView];
        }
        if (self.isb) {
            return;
        }
       XYTemplateItemData *info = [[XYTemplateDataMgr sharedInstance]getByID:0x4B00000000080001];
        [self engineOperate];
        self.isb = YES;
    }];
    
}

- (void)engineOperate {
    NSArray<XYAdjustItem *> *adjustItems = [self getEffectPropertyItemsWithTemplateID:0x4B00000000080001];

    CXiaoYingEffect *adjustParamEffect = [self getClipAdjustParamEffectByClipIndex:0];
    if (adjustParamEffect) {
         [adjustItems enumerateObjectsUsingBlock:^(XYAdjustItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             QVET_EFFECT_PROPDATA propData = {obj.dwID,100};
             [adjustParamEffect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
         }];
    }

}

- (CXiaoYingEffect *)getClipAdjustParamEffectByClipIndex:(int)clipIndex {
    CXiaoYingEffect *adjustParamEffect;
    CXiaoYingClip *clip = [[XYStoryboard sharedXYStoryboard] getClipByIndex:clipIndex];
    adjustParamEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT EffectIndex:0];
    if (!adjustParamEffect) {
        [[XYStoryboard sharedXYStoryboard] setClipEffect:[XYCommonEngineGlobalData data].configModel.adjustEffectPath
        effectConfigIndex:0
              dwClipIndex:0
                  groupId:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT
                  layerId:LAYER_ID_VIDEO_PARAM_ADJUST_EFFECT];
    }
    adjustParamEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT EffectIndex:0];
    return adjustParamEffect;
}


- (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithTemplateID:(long long)ltemplateID {
    CXYEffectpropertyInfo *effectPropertyInfo = [CXiaoYingStyle GetEffectPropertyInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:ltemplateID];
    return [self getEffectPropertyItemsWithEffectPropertyInfo:effectPropertyInfo];
}

- (NSArray<XYAdjustItem *> *)getEffectPropertyItemsWithEffectPropertyInfo:(CXYEffectpropertyInfo *)effectPropertyInfo {
    if (!effectPropertyInfo) {
        return nil;
    }
    NSInteger dwItemCount = effectPropertyInfo->dwItemCount;
    if (dwItemCount == 0) {
        return nil;
    }

    NSMutableArray *effectPropertyItems = [NSMutableArray new];
    for (int i = 0; i < dwItemCount; i++) {
        CXYEffectPropertyItem *pItem = effectPropertyInfo->pItems + i;
        XYAdjustItem *effectPropertyItem = [[XYAdjustItem alloc] init];
        effectPropertyItem.dwID = pItem->dwID;
        effectPropertyItem.dwMinValue = pItem->dwMinValue;
        effectPropertyItem.dwMaxValue = pItem->dwMaxValue;
        effectPropertyItem.dwDefaultValue = pItem->dwCurValue;
        effectPropertyItem.dwCurrentValue = effectPropertyItem.dwDefaultValue;
        if (pItem->pszName != NULL) {
            effectPropertyItem.nameEn = [NSString stringWithUTF8String:pItem->pszName];
        }
        if (pItem->pszWildCards != NULL) {
            effectPropertyItem.nameLocale = [NSString stringWithUTF8String:pItem->pszWildCards];
            
        }
        [effectPropertyItems addObject:effectPropertyItem];
    }

    [CXiaoYingStyle ReleasePropertyInfo:effectPropertyInfo];
    return effectPropertyItems;
}

#pragma mark- action
- (void)toolbarClickAction:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    self.curXYVideoEditToolbarTypeInfoDic = target.xy_parameter;
    NSString *actionName = target.xy_parameter[@"action"];
    if (actionName && actionName.length) {
        SEL sel = NSSelectorFromString(actionName);
        if ([self canPerformAction:sel withSender:nil]) {
            IMP imp = [self methodForSelector:sel];
            ((id(*)(id, SEL, QVMediButton *))imp)(self, sel, target);
        }
    }
    if (self.toolbarClickBlock) {
        self.toolbarClickBlock(toolbarType);
    }
}

- (void)xy_videoEditToolbarTypeEditAction:(QVMediButton *)target {
    __weak typeof(self) weakSelf = self;
    [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_REIGHT addClick:^(NSInteger curSelectIndex) {
        __strong typeof(weakSelf) self = weakSelf;
        if (self.addClipActionBlock) {
            self.addClipActionBlock(curSelectIndex);
        }
    } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
        __strong typeof(weakSelf) self = weakSelf;
        if (self.selectClipActionBlock && self.addImageView.hidden == NO) {
            self.selectClipActionBlock(curSelectIndex, autoRefresh);
        }
    }];
    [self.addImageView setDataSource:self.imageArray];
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = NO;
        self.editToolBar.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:self.editToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
            [weakSelf editToobarSlectAction:targetResource.mutableCopy];
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            [weakSelf finishHiddenCurViewAction];
        }];
        self.toolbarBackScrollView.hidden = YES;
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
    
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, nil, YES);
    }
}

- (void)xy_videoEditToolbarTypeStickerAction:(QVMediButton *)target {
    self.editToolBarType = QVMediVideoEditToolbarTypeSticker;
    self.effectSeletedIdx = 0;
    __weak typeof(self) weakSelf = self;
    [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_REIGHT addClick:^(NSInteger curSelectIndex) {
        //添加新元素
        NSLog(@"添加新元素");
        [weakSelf xy_videoEditToolbarAddSticker];
    } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
        self.effectSeletedIdx = curSelectIndex;
        NSLog(@"选择已经添加的元素");
    }];
    [self updateAddImageViewView];
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = NO;
        self.editToolBar.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:self.effectToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
            NSLog(@"创建三级子页面");
            [weakSelf stickereditToobarSlectAction:targetResource];
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            [weakSelf finishHiddenCurViewAction];
        }];
        self.toolbarBackScrollView.hidden = YES;
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
}

- (void)xy_videoEditToolbarTypeSubtitleAction:(QVMediButton *)target {
    self.editToolBarType = QVMediVideoEditToolbarTypeSubtitle;
    __weak typeof(self) weakSelf = self;
    [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_LEFT addClick:^(NSInteger curSelectIndex) {
        [weakSelf xy_videoEditToolbarAddSubtitle];
    } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
        self.effectSeletedIdx = curSelectIndex;
    }];
    [self updateAddImageViewView];
    [UIView animateWithDuration:.3f animations:^{
        self.editToolBar.hidden = NO;
        self.addImageView.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:self.effectToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
            [weakSelf subtitleEditToobarSlectAction:targetResource.mutableCopy];
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            [weakSelf finishHiddenCurViewAction];
        }];
        self.toolbarBackScrollView.hidden = YES;
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
}

- (void)xy_videoEditToolbarAddSubtitle {
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:nil toolbarType:QVMediScrollToolbarVideoEditSubtitle changeSelect:^(NSDictionary * _Nonnull targetResource) {
        } action:@"xy_videoEditToolbarTypeSubtitleAction:" selectFinish:^(id  _Nonnull targetResource) {
            __strong typeof(weakSelf) self = weakSelf;
            [self.iconImageArray addObject:targetResource[@"info"][@"icon"]];
            [self xy_videoEditToolbarTypeSubtitleAction:nil];
            NSLog(@"添加完成");
            if (self.isUpdate) {
                self.isUpdate = NO;
                [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle) param:targetResource];
            } else {
                [self addText:targetResource];
            }
        }];
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
}


- (void)xy_videoEditToolbarAddSticker {
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:nil toolbarType:QVMediScrollToolbarVideoEditAddSticker changeSelect:^(NSDictionary * _Nonnull targetResource) {

        } action:@"xy_videoEditToolbarTypeStickerAction:" selectFinish:^(id  _Nonnull targetResource) {
            NSLog(@"添加完成");
            __strong typeof(weakSelf) self = weakSelf;
            if (targetResource[@"info"][@"icon"]) {
                [self.iconImageArray addObject:targetResource[@"info"][@"icon"]];
            }
            [self addSticker:targetResource];
            [self xy_videoEditToolbarTypeStickerAction:nil];
        }];
        self.editToolBar.title = NSLocalizedString(@"mn_edit_title_sticker",@"");
    }];
    self.editToolBar.hidden = NO;
    self.toolbarBackScrollView.hidden = YES;


}

- (void)xy_videoEditToolbarAddMosaic {
   
    [UIView animateWithDuration:.3f animations:^{
           self.addImageView.hidden = YES;
           __weak typeof(self) weakSelf = self;
           [self.editToolBar createScrollToolbarWithData:nil toolbarType:QVMediScrollToolbarVideoEditAddMosaic changeSelect:^(NSDictionary * _Nonnull targetResource) {
               [self addMosaic:targetResource];
           } action: @"xy_videoEditToolbarAddMosaic:" selectFinish:^(id  _Nonnull targetResource) {
               NSLog(@"添加完成");
               __strong typeof(weakSelf) self = weakSelf;
               if (targetResource[@"info"][@"icon"]) {
                   [self.iconImageArray addObject:targetResource[@"info"][@"icon"]];
               }
               [self xy_videoEditToolbarTypeMosaicAction:nil];
           }];
           self.editToolBar.title = NSLocalizedString(@"mn_edit_title_sticker",@"");
       }];
}

- (void)addSticker:(NSDictionary *)targetResource {
    NSString * pastePath = targetResource[@"info"][@"filePath"];
    if (self.isUpdate) {
        [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle) param:pastePath];
        self.isUpdate = NO;
    } else {
        XYEffectVisionModel * visionModel = [XYEffectVisionModel new];
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        visionModel.groupID = XYCommonEngineGroupIDSticker;
        visionModel.filePath = pastePath;
        visionModel.isStaticPicture = YES;
        NSInteger beginTime = 0;
        visionModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:beginTime length:[XYEngineWorkspace clipMgr].clipsTotalDuration];
        [[XYEngineWorkspace effectMgr] runTask:visionModel];
    }
   
}

- (void)addMosaic:(NSDictionary *)targetResource {
    NSString * pastePath = targetResource[@"info"][@"filePath"];
    XYEffectVisionModel * visionModel;
    if ([[XYEngineWorkspace effectMgr] effectModels:XYCommonEngineGroupIDMosaic].count > 0) {
        visionModel = [[[XYEngineWorkspace effectMgr] effectModels:XYCommonEngineGroupIDMosaic]firstObject];
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
        visionModel.filePath = pastePath;
    } else {
        visionModel = [XYEffectVisionModel new];
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        visionModel.groupID = XYCommonEngineGroupIDMosaic;
        visionModel.filePath = pastePath;
        visionModel.propData = 0.5;
        NSInteger beginTime = 0;
        visionModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:beginTime length:[XYEngineWorkspace clipMgr].clipsTotalDuration];
    }
    
    [[XYEngineWorkspace effectMgr] runTask:visionModel];
}

- (void)addText:(NSDictionary *)targetResource {
    NSString * pastePath = targetResource[@"info"][@"filePath"];
    NSInteger templateID = [targetResource[@"info"][@"templateID"] integerValue] ;
    XYEffectVisionTextModel * textModel = [XYEffectVisionTextModel new];
    textModel.taskID = XYCommonEngineTaskIDEffectVisionTextAdd;
    textModel.groupID = XYCommonEngineGroupIDText;
    textModel.filePath = pastePath;
    textModel.templateID = templateID;
    XYEffectVisionSubTitleLabelInfoModel *subTextModel = [XYEffectVisionSubTitleLabelInfoModel new];
    subTextModel.text = @"点击输入字幕";
    textModel.multiTextList = @[subTextModel];
    NSInteger beginTime = 0;
    textModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:beginTime length:[XYEngineWorkspace clipMgr].clipsTotalDuration];
    [[XYEngineWorkspace effectMgr] runTask:textModel];
}


- (void)showAddImageView {
    [self xy_videoEditToolbarTypeStickerAction:nil];
}


- (void)xy_videoEditToolbarTypeSubtitle_toobarTypeDeleteAction:(NSDictionary *)infoDic {
    
}

- (void)xy_videoEditToolbarTypeScaleAction:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    if (self.curScaleType == QVMediVideoEditScaleType_3_4) {
        self.curScaleType = QVMediVideoEditScaleTypeDefault;
    }else {
        self.curScaleType++;
    }
    NSArray *scaleTypesAry = target.xy_parameter[@"scaleTypes"];
    [target setImage:[UIImage qvmedi_imageWithName:scaleTypesAry[self.curScaleType][@"icon"] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, @(self.curScaleType), YES);
    }
}

- (void)xy_videoEditToolbarTypeWatermarkAction:(QVMediButton *)target {
    void (^getTemeLogoBlock)(id info) = ^(id info){
        NSLog(@"temeInfoArray-->%@",info);
        QVMediAlbumMediaItem * mediaInfo = info;
        if (self.isUpdate) {
            self.isUpdate = NO;
            [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle) param:mediaInfo.filePath];
        }
    };
    self.editToolBarType = QVMediVideoEditToolbarTypeWatermark;

       [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_REIGHT addClick:^(NSInteger curSelectIndex) {
                 QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
                 if (self.videoEditToolbarClickBlock) {
                     self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
               }
       } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
           
       }];
       [self updateAddImageViewView];
       [UIView animateWithDuration:.3f animations:^{
           self.addImageView.hidden = NO;
           self.editToolBar.hidden = NO;
           __weak typeof(self) weakSelf = self;
           [self.editToolBar createScrollToolbarWithData:self.effectToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
               [weakSelf stickereditToobarSlectAction:targetResource];
           } action:nil selectFinish:^(id  _Nonnull targetResource) {
               [weakSelf finishHiddenCurViewAction];
           }];
           self.toolbarBackScrollView.hidden = YES;
           self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
           if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
               self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
           }
       }];
}


- (void)xy_videoEditToolbarTypeMosaicAction:(QVMediButton *)target {
    self.editToolBarType = QVMediVideoEditToolbarTypeMosaic;

    [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_REIGHT addClick:^(NSInteger curSelectIndex) {
        [self xy_videoEditToolbarAddMosaic];

    } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
        self.effectSeletedIdx = curSelectIndex;
    }];
    [self updateAddImageViewView];
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = NO;
        self.editToolBar.hidden = NO;
        __weak typeof(self) weakSelf = self;
        
        [self.editToolBar createScrollToolbarWithData:self.effectToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
            [weakSelf stickereditToobarSlectAction:targetResource];
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            [weakSelf finishHiddenCurViewAction];
        }];
        self.toolbarBackScrollView.hidden = YES;
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
    
    //
//    XYVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
//    if (self.videoEditToolbarClickBlock) {
//        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, @"Mosaic", YES);
//    }
}


- (void)xy_videoEditToolbarTypePictureInPictureAction:(QVMediButton *)target {
    self.editToolBarType = QVMediVideoEditToolbarTypePictureInPicture;
    void (^getTemeLogoBlock)(id info) = ^(id info){
        QVMediAlbumMediaItem * mediaInfo = info;
        NSLog(@"temeInfoArray-->%@",info);
        if (self.isUpdate) {
            [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle) param:mediaInfo.filePath];
            return;
        }
        XYEffectVisionModel *visionModel = [[XYEffectVisionModel alloc] init];
        visionModel.groupID = XYCommonEngineGroupIDCollage;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        visionModel.reCalculateFrame = YES;
        PHAsset *asset = [self getPHAssetWithPath:mediaInfo.filePath];
        visionModel.userDataModel.originWidth = asset.pixelWidth;
        visionModel.userDataModel.originHeight = asset.pixelHeight;
        if (mediaInfo.mediaType == QVMediAssetMediaTypeVideo) {
        NSInteger length = mediaInfo.endPoint - mediaInfo.startPoint;
        if (length == 0) {
            length = mediaInfo.duration;
        }
        
        XYVeRangeModel *trimRangeModel = [XYVeRangeModel VeRangeModelWithPosition:mediaInfo.startPoint length:length];
        visionModel.trimVeRange = trimRangeModel;
        
        XYVeRangeModel *sourceRangeModel = [XYVeRangeModel VeRangeModelWithPosition:0 length:mediaInfo.duration];
        
        visionModel.sourceVeRange = sourceRangeModel;
        
        visionModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:length];
        
        visionModel.userDataModel.isPIPVideo = YES;
        } else {
            XYVeRangeModel *trimRangeModel = [XYVeRangeModel VeRangeModelWithPosition:mediaInfo.startPoint length:-1];
            visionModel.trimVeRange = trimRangeModel;
        }
        visionModel.filePath = mediaInfo.filePath;
        XYVeRangeModel *veRangeModel = [XYVeRangeModel VeRangeModelWithPosition:0 length:[XYEngineWorkspace clipMgr].clipsTotalDuration];
        visionModel.destVeRange = veRangeModel;

        [[XYEngineWorkspace effectMgr] runTask:visionModel];
    };

    __weak typeof(self) weakSelf = self;
    [self.addImageView creatWithAddButtonDirection:QVMEDIADDBUTTONDIRECTION_REIGHT addClick:^(NSInteger curSelectIndex) {
          QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
            if (self.videoEditToolbarClickBlock) {
                self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
            }
    } select:^(NSInteger curSelectIndex, UIImage * _Nonnull image, BOOL autoRefresh) {
        
    }];
    [self updateAddImageViewView];
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = NO;
        self.editToolBar.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [self.editToolBar createScrollToolbarWithData:self.effectToolBarInfoArray toolbarType:QVMediScrollToolbarVideoEdit changeSelect:^(NSDictionary * _Nonnull targetResource) {
            [weakSelf stickereditToobarSlectAction:targetResource];
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            [weakSelf finishHiddenCurViewAction];
        }];
        self.toolbarBackScrollView.hidden = YES;
        self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
        if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
        }
    }];
}

- (void)xy_videoEditToolbarTypeSpecialEffectsAction:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    void (^getSpecialEffectsLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = ^(NSArray <NSDictionary *> *effectsInfoArray, void (^selectChangeBlock)(NSDictionary *infoDic)){
        NSLog(@"effectsInfoArray-->%@",effectsInfoArray);
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [self.editToolBar createScrollToolbarWithData:effectsInfoArray toolbarType:QVMediScrollToolbarSpecialEffects changeSelect:^(NSDictionary * _Nonnull targetResource) {
                selectChangeBlock(targetResource);
            } action:nil selectFinish:^(id  _Nonnull targetResource) {
                [weakSelf finishHiddenCurViewAction];
            }];
            self.toolbarBackScrollView.hidden = YES;
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
            if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
                self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
            }
        }];
    };
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getSpecialEffectsLogoBlock, YES);
    }
}

- (void)xy_videoEditToolbarTypeThemeAction:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = ^(NSArray <NSDictionary *> *temeInfoArray, void (^selectChangeBlock)(NSDictionary *infoDic)){
        NSLog(@"temeInfoArray-->%@",temeInfoArray);
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [self.editToolBar createScrollToolbarWithData:temeInfoArray toolbarType:QVMediScrollToolbarSpecialEffects changeSelect:^(NSDictionary * _Nonnull targetResource) {
                selectChangeBlock(targetResource);
            } action:nil selectFinish:^(id  _Nonnull targetResource) {
                [weakSelf finishHiddenCurViewAction];
            }];
            self.toolbarBackScrollView.hidden = YES;
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
            if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
                self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
            }
        }];
    };
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
    }
}

- (void)xy_videoEditToolbarTypeAudioAction:(QVMediButton *)target {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        self.toolbarBackScrollView.hidden = YES;
        self.toolbarOperateView.hidden = NO;
    }completion:^(BOOL finished) {
        [self.toolbarOperateView creatOperateViewWithItemInfo:target.xy_parameter changeValue:^(id  _Nullable toobarType, id  _Nullable value) {
            __strong typeof(weakSelf) self = weakSelf;
            [self videoEditToolbarTypeAudioAction:[value integerValue] button:target];
        } finish:^(id  _Nullable editToobarType, id  _Nullable value) {
            self.toolbarBackScrollView.hidden = NO;
            self.toolbarOperateView.hidden = YES;
        }];
    }];
}

- (void)videoEditToolbarTypeAudioAction:(VideoEditToolbarTypeAudioType)type button:(QVMediButton *)target {
    switch (type) {
        case VideoEditToolbarTypeAudioTypeSong:
            [self videoEditToolbarTypeAudioTypeSong:type button:target];
            break;
            
        case VideoEditToolbarTypeAudioTypeSoundEffects:
            [self videoEditToolbarTypeAudioTypeSoundEffects:type button:target];
            break;
            
        case VideoEditToolbarTypeAudioTypeRrecording:
            [self videoEditToolbarTypeAudioTypeRrecording:type button:target];
            break;
            default:
            [self videoEditToolbarTypeAudioTypeRrecording:type button:target];
            break;
    }
}

- (void)videoEditToolbarTypeAudioTypeSong:(VideoEditToolbarTypeAudioType)type button:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = ^(NSArray <NSDictionary *> *temeInfoArray, void (^selectChangeBlock)(NSDictionary *infoDic)){
        NSLog(@"temeInfoArray-->%@",temeInfoArray);
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [self.editToolBar createScrollToolbarWithData:temeInfoArray toolbarType:QVMediScrollToolbarSongs changeSelect:^(NSDictionary * _Nonnull targetResource) {
                selectChangeBlock(@{@"dataInfo":targetResource, @"type":@(type)});
            } action:nil selectFinish:^(id  _Nonnull targetResource) {
                [weakSelf finishHiddenCurViewAction];
            }];
            self.toolbarOperateView.hidden = YES;
            self.toolbarBackScrollView.hidden = YES;
            self.editToolBar.title = NSLocalizedString(@"mn_edit_title_bgm",@"");
        }];
    };
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
    }
}

- (void)videoEditToolbarTypeAudioTypeSoundEffects:(VideoEditToolbarTypeAudioType)type button:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = ^(NSArray <NSDictionary *> *temeInfoArray, void (^selectChangeBlock)(NSDictionary *infoDic)){
        NSLog(@"temeInfoArray-->%@",temeInfoArray);
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [self.editToolBar createScrollToolbarWithData:temeInfoArray toolbarType:QVMediScrollToolbarSongs changeSelect:^(NSDictionary * _Nonnull targetResource) {
                selectChangeBlock(@{@"dataInfo":targetResource, @"type":@(type)});
            } action:nil selectFinish:^(id  _Nonnull targetResource) {
                [weakSelf finishHiddenCurViewAction];
            }];
            self.toolbarOperateView.hidden = YES;
            self.toolbarBackScrollView.hidden = YES;
            self.editToolBar.title = NSLocalizedString(@"音效",@"");
        }];
    };
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
    }
}

- (void)videoEditToolbarTypeAudioTypeRrecording:(VideoEditToolbarTypeAudioType)type button:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = ^(NSArray <NSDictionary *> *temeInfoArray, void (^selectChangeBlock)(NSDictionary *infoDic)){
        NSLog(@"temeInfoArray-->%@",temeInfoArray);
        selectChangeBlock(@{@"type":@(type)});
//        [UIView animateWithDuration:.3f animations:^{
//
//            self.toolbarOperateView.title = NSLocalizedString(@"录音",@"录音");
//        }];
    };
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
    }
}

//测试语音转文字功能
- (void)xy_videoEditToolbarTypeTTSAction:(QVMediButton *)target {
    QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    if (self.videoEditToolbarClickBlock) {
        self.videoEditToolbarClickBlock(toolbarType, self.curXYVideoEditToolbarTypeInfoDic, nil, YES);
    }
}

- (void)finishHiddenCurViewAction {
    if (self.editToolBar.hidden && self.toolbarBackScrollView.hidden) {
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = NO;
            self.toolbarOperateView.hidden = YES;
            self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"icon&title"],@"");
            if (self.curXYVideoEditToolbarTypeInfoDic[@"title"]) {
                self.editToolBar.title = NSLocalizedString(self.curXYVideoEditToolbarTypeInfoDic[@"title"],@"");
            }
        }];
    }else if (!self.editToolBar.hidden && !self.addImageView.hidden){
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = YES;
            self.addImageView.hidden = YES;
            self.toolbarBackScrollView.hidden = NO;
        }];
    }else {
        [UIView animateWithDuration:.3f animations:^{
            self.editToolBar.hidden = YES;
            self.toolbarBackScrollView.hidden = NO;
        }];
    }
}

#pragma mark- XYVideoEditToolbarTypeEdit_toobarType action
- (void)xy_videoEditToolbarTypeEdit_toobarTypeTrimAction {
    [UIView animateWithDuration:.3f animations:^{
        self.editToolBar.hidden = YES;
    }];
}

#pragma mark- XYVideoEditToolbarTypeEdit_toobarType action
- (void)editToobarSlectAction:(NSMutableDictionary *)infoDic {
    // TODO: actionDirectReturn
    QVMediVideoEditToolbarTypeEdit_toobarType editToolbarType = [[NSString stringWithFormat:@"%@",infoDic[@"type"]] integerValue];
    BOOL actionDirectReturn = [infoDic[@"DirectReturn"] boolValue];
    infoDic = [self getEditToolBarUpdateInfoWithType:editToolbarType infoDic:infoDic];
    if (actionDirectReturn) {
        QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
        self.videoEditToolbarClickBlock(toolbarType, infoDic, @"actionDirectReturn", YES);
        return;
    }
    NSString *actionName = infoDic[@"action"];
    if (!(actionName.length && actionName)) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = YES;
        self.editToolBar.hidden = YES;
        self.toolbarOperateView.hidden = NO;
    }completion:^(BOOL finished) {
        [self.toolbarOperateView creatOperateViewWithItemInfo:infoDic changeValue:^(id  _Nullable toobarType, id  _Nullable value) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.videoEditToolbarClickBlock) {
                QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
                self.videoEditToolbarClickBlock(toolbarType, infoDic, value, YES);
            }
        } finish:^(id  _Nullable editToobarType, id  _Nullable value) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.videoEditToolbarClickBlock) {
                QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
                self.videoEditToolbarClickBlock(toolbarType, infoDic, value, NO);
            }
            self.addImageView.hidden = NO;
            [self finishHiddenCurViewAction];
        }];
    }];
}


#pragma mark- XYVideoEditToolbarTypeSubtitle_toobarType action
- (void)subtitleEditToobarSlectAction:(NSMutableDictionary *)infoDic {
    // TODO: delete
    self.editToolBarType = QVMediVideoEditToolbarTypeSubtitle;
    QVMediVideoEditToolbarTypeSticker_toobarType toolbarType = [[NSString stringWithFormat:@"%@",infoDic[@"type"]] integerValue];
    if (toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeDelete || toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeRotate || QVMediVideoEditToolbarTypeSticker_toobarTypeMirror == toolbarType) {
        NSLog(@"delete");
        [self updateEffect:toolbarType param:nil];
        return;
    } else if (toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle){
        [self xy_videoEditToolbarAddSubtitle];
        self.isUpdate = YES;
        return;
    }
    
    BOOL actionDirectReturn = [infoDic[@"DirectReturn"] boolValue];
    infoDic = [self getSubtitleToolBarUpdateInfoWithType:toolbarType infoDic:infoDic];
    if (actionDirectReturn) {
        QVMediVideoEditToolbarType toolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
        self.videoEditToolbarClickBlock(toolbarType, infoDic, @"actionDirectReturn", YES);
        return;
    }
    NSString *actionName = infoDic[@"action"];
    if (!(actionName.length && actionName)) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        self.editToolBar.hidden = YES;
        self.addImageView.hidden = YES;
        self.toolbarOperateView.hidden = NO;
    }completion:^(BOOL finished) {
        [self.toolbarOperateView creatOperateViewWithItemInfo:infoDic changeValue:^(id  _Nullable toobarType, id  _Nullable value) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.videoEditToolbarClickBlock) {
                QVMediVideoEditToolbarType editToolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
                self.videoEditToolbarClickBlock(editToolbarType, infoDic, value, YES);
                if (QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText !=  [toobarType integerValue]) {
                    [self updateEffect:[toobarType integerValue] param:value];
                }
            }
        } finish:^(id  _Nullable toobarType, id  _Nullable value) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.videoEditToolbarClickBlock) {
                QVMediVideoEditToolbarType editToolbarType = [[NSString stringWithFormat:@"%@",self.curXYVideoEditToolbarTypeInfoDic[@"type"]] integerValue];
                self.videoEditToolbarClickBlock(editToolbarType, infoDic, value, NO);
                if ([toobarType integerValue] == QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText){
                    [self videoEditView_xy_videoEditToolbarTypeSubtitle_toobarTypeEditAction:value];
                }
            }
            self.addImageView.hidden = NO;
            [self finishHiddenCurViewAction];
        }];
    }];
}


#pragma mark- XYVideoEditToolbarTypeStick_toobarType action
- (void)stickereditToobarSlectAction:(NSDictionary *)infoDic {
    void (^getTemeLogoBlock)(id info) = ^(id info){
        QVMediAlbumMediaItem * mediaInfo = info;
        if (self.isUpdate) {
            self.isUpdate = NO;
            [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle) param:mediaInfo.filePath];
        }
    };
    // TODO: delete
    QVMediVideoEditToolbarTypeSticker_toobarType toolbarType = [[NSString stringWithFormat:@"%@",infoDic[@"type"]] integerValue];
    if (toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeDelete || toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeRotate || QVMediVideoEditToolbarTypeSticker_toobarTypeMirror == toolbarType) {
        NSLog(@"delete");
        [self updateEffect:toolbarType param:nil];
        return;
    }
        self.isUpdate = YES;
        if (self.videoEditToolbarClickBlock && ((QVMediVideoEditToolbarTypeWatermark == self.editToolBarType || QVMediVideoEditToolbarTypePictureInPicture == self.editToolBarType) && QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle == toolbarType)) {
            self.videoEditToolbarClickBlock(QVMediVideoEditToolbarTypePictureInPicture, self.curXYVideoEditToolbarTypeInfoDic, getTemeLogoBlock, YES);
            return;
        } else  if (self.editToolBarType == QVMediVideoEditToolbarTypeSticker && toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle){
            [self xy_videoEditToolbarAddSticker];
            return;
        }  else  if (self.editToolBarType == QVMediVideoEditToolbarTypeMosaic && toolbarType == QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle){
            [self xy_videoEditToolbarAddMosaic];
            return;
        }
    NSString *actionName = infoDic[@"action"];
    if (!(actionName.length && actionName)) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.3f animations:^{
        self.addImageView.hidden = YES;
        self.editToolBar.hidden = YES;
        self.toolbarOperateView.hidden = NO;
    }completion:^(BOOL finished) {
        [self.toolbarOperateView creatOperateViewWithItemInfo:infoDic changeValue:^(id  _Nullable toobarType, id  _Nullable value) {
            [self updateEffect:[toobarType integerValue] param:value];
            NSLog(@"toobarType--->%@-->%@",toobarType,value);
        } finish:^(id  _Nullable toobarType, id  _Nullable value) {
            NSLog(@"toobarType--->%@-->%@",toobarType,value);
            __strong typeof(weakSelf) self = weakSelf;
            self.addImageView.hidden = NO;
            [self finishHiddenCurViewAction];
        }];
    }];
}

#pragma mark- set get lazy

- (QVMediScrollToolbarSelectView *)editToolBar {
    if (!_editToolBar) {
        _editToolBar = [[QVMediScrollToolbarSelectView alloc] init];
        _editToolBar.hidden = YES;
        _editToolBar.backgroundColor = [UIColor xy_colorWithHEX:0x000102 alpha:1];
        [self addSubview:_editToolBar];
        [_editToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(153 + [QVMediTools qv_safeAreaBottom]);
            make.bottom.equalTo(self).offset(0);
        }];
    }
    return _editToolBar;
}

- (QVMediVideoToolbarOperateView *)toolbarOperateView {
    if (!_toolbarOperateView) {
        _toolbarOperateView = [[QVMediVideoToolbarOperateView alloc] init];
        [self addSubview:_toolbarOperateView];
        [_toolbarOperateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _toolbarOperateView;
}

- (QVMediAddImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[QVMediAddImageView alloc] init];
        _addImageView.hidden = YES;
        [self addSubview:_addImageView];
        [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.mas_equalTo(self.editToolBar.mas_top);
        }];
    }
    return _addImageView;
}

- (void)setVideoTotalDuration:(NSInteger)videoTotalDuration {
    _videoTotalDuration = videoTotalDuration;
    if (_videoTotalDuration) {
        for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
            if ([[objDic allKeys] containsObject:VideoTotalDuration]) {
                [objDic setObject:@(videoTotalDuration) forKey:VideoTotalDuration];
            }
        }
    }
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    if (_addImageView) {
        [self.addImageView setDataSource:imageArray];
    }
}

- (void)setIconImageArray:(NSMutableArray *)iconImageArray {
    _iconImageArray = iconImageArray;
    if (_addImageView) {
        [self.addImageView setDataSource:iconImageArray];
    }
}

- (void)setVolumeValue:(CGFloat)volumeValue {
    _volumeValue = volumeValue;
    for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
        if ([[objDic allKeys] containsObject:VideoVolumeValue]) {
            [objDic setObject:@(volumeValue) forKey:VideoVolumeValue];
        }
    }
}

- (void)setVoiceChangeValue:(CGFloat)voiceChangeValue {
    _voiceChangeValue = voiceChangeValue;
    for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
        if ([[objDic allKeys] containsObject:VideoVoiceChangeValue]) {
            [objDic setObject:@(voiceChangeValue) forKey:VideoVoiceChangeValue];
        }
    }
}

- (void)setVoiceSpeedValue:(CGFloat)voiceSpeedValue {
    _voiceSpeedValue = voiceSpeedValue;
    for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
        if ([[objDic allKeys] containsObject:VideoSpeedChangeValue]) {
            [objDic setObject:@(voiceSpeedValue) forKey:VideoSpeedChangeValue];
        }
    }
}

- (void)setParameterAdjustmentDic:(NSMutableDictionary *)parameterAdjustmentDic {
    _parameterAdjustmentDic = parameterAdjustmentDic;
    for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
        if ([[objDic allKeys] containsObject:VideoParameterAdjustment]) {
            [objDic setObject:parameterAdjustmentDic forKey:VideoParameterAdjustment];
        }
    }
}

- (void)setAddClipActionBlock:(void (^)(NSInteger))addClipActionBlock {
    _addClipActionBlock = addClipActionBlock;
}

- (void)setSelectClipActionBlock:(void (^)(NSInteger, BOOL))selectClipActionBlock {
    _selectClipActionBlock = selectClipActionBlock;
}

#pragma mark- data

- (NSMutableDictionary *)getEditToolBarUpdateInfoWithType:(QVMediVideoEditToolbarTypeEdit_toobarType)toolbarType infoDic:(NSMutableDictionary *)infoDic {
    for (NSMutableDictionary *objDic in self.editToolBarInfoArray) {
        if ([objDic[@"type"] integerValue] == toolbarType) {
            return objDic;
            break;
        }
    }
    return infoDic;
}

- (NSMutableArray *)editToolBarInfoArray {
    //编辑页面传值
    if (!_editToolBarInfoArray) {
        _editToolBarInfoArray = @[
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeTrim),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeTrim",
                @"title" : @"mn_edit_title_trim",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeTrimAction:",
                VideoTotalDuration:@(self.videoTotalDuration)
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeSplit),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeSplit",
                @"title" : @"mn_edit_title_split",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeSplitAction:",
                VideoTotalDuration:@(self.videoTotalDuration)
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeDelete),
                @"DirectReturn":@YES,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeDelete",
                @"title" : @"mn_edit_title_delete",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeDeleteAction:"
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeVolume),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeVolume",
                @"title" : @"mn_edit_title_volume",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeVolumeAction:",
                VideoVolumeValue:@(self.volumeValue)
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeFilter),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeFilter",
                @"title" : @"mn_edit_title_filter",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeFilterAction:"
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeTransition),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeTransition",
                @"title" : @"mn_edit_title_transitions",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeTransitionAction:"
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeVoiceChange),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeVoiceChange",
                @"title" : @"mn_edit_title_change_voice",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeVoiceChangeAction:",
                VideoVoiceChangeValue:@(self.voiceChangeValue)
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeVariableSpeed),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeVariableSpeed",
                @"title" : @"mn_edit_title_speed",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeVariableSpeedAction:",
                VideoSpeedChangeValue:@(self.voiceSpeedValue)
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeParameterAdjustment),
                @"DirectReturn":@NO,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeParameterAdjustment",
                @"title" : @"mn_edit_title_adjust",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeParameterAdjustmentAction:",
                VideoParameterAdjustment:self.parameterAdjustmentDic
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeMirror),
                @"DirectReturn":@YES,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeMirror",
                @"title" : @"mn_edit_title_mirror",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeMirrorAction:"
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeReverse),
                @"DirectReturn":@YES,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeReverse",
                @"title" : @"mn_edit_title_reserve",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeReverseAction:"
            }.mutableCopy,
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit_toobarTypeRotate),
                @"DirectReturn":@YES,
                @"icon&title":@"QVVideoEditToolbarTypeEdit_toobarTypeRotate",
                @"title" : @"mn_edit_title_rotate",
                @"action":@"xy_videoEditToolbarTypeEdit_toobarTypeRotateAction:"
            }.mutableCopy
        ].mutableCopy;
    }
    return _editToolBarInfoArray;
}


- (NSMutableDictionary *)getSubtitleToolBarUpdateInfoWithType:(QVMediVideoEditToolbarTypeSticker_toobarType)toolbarType infoDic:(NSMutableDictionary *)infoDic {
    for (NSMutableDictionary *objDic in self.effectToolBarInfoArray) {
        if ([objDic[@"type"] integerValue] == toolbarType) {
            return objDic;
            break;
        }
    }
    return infoDic;
}


- (NSMutableArray *)effectToolBarInfoArray {
    NSInteger clipSourceRangeDuration = [XYEngineWorkspace clipMgr].clipModels[[QVMediToolbarManager manager].clipSeletedIdx].sourceVeRange.dwLen;
        XYEffectModel *effctModel;
        NSArray *effectList = [self fetchEffectModels];
           if (self.effectSeletedIdx < effectList.count) {
               effctModel = effectList[self.effectSeletedIdx];
           }
        _effectToolBarInfoArray = @[
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeModifyStyle",
                @"title" : @"mn_edit_change_style",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeModifyStyleAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeTrim),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeTrim",
                @"title" : @"mn_edit_title_trim",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeTrimAction:",
                VideoTotalDuration:@(clipSourceRangeDuration)
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeVolume),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeVolume",
                @"title" : @"mn_edit_title_volume",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeVolumeAction:",
                VideoVolumeValue:@(((XYEffectVisionModel *)effctModel).volume)
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeOpacity),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeOpacity",
                @"title" : @"mn_edit_alpha_change",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeOpacityAction:",
                VideoVolumeValue:@(((XYEffectVisionModel *)effctModel).alpha * 100)
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeZoom),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeZoom",
                @"title" : @"mn_edit_change_zoom",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeZoomAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeDelete),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeDelete",
                @"title" : @"mn_edit_title_delete",
                @"action":@""
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeMirror),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeMirror",
                @"title" : @"mn_edit_title_mirror",
                @"action":@""
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeRotate),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeRotate",
                @"title" : @"mn_edit_title_rotate",
                @"action":@""
            }
        ].mutableCopy;
    if (QVMediVideoEditToolbarTypeSubtitle == self.editToolBarType) {
        [_effectToolBarInfoArray removeObjectAtIndex:2];
        [_effectToolBarInfoArray removeObjectAtIndex:2];
        [_effectToolBarInfoArray insertObject:@{@"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText),
        @"DirectReturn":@NO,
        @"icon&title":@"QVVideoEditToolbarTypeSubtitle_toobarTypeModify",
        @"title" : @"mn_edit_bgm_edit",
        @"action":@"xy_videoEditToolbarTypeSubtitle_toobarTypeEditAction:"} atIndex:0];
    } else if (QVMediVideoEditToolbarTypeSticker == self.editToolBarType || QVMediVideoEditToolbarTypeWatermark == self.editToolBarType ) {
        [_effectToolBarInfoArray removeObjectAtIndex:2];
        if (QVMediVideoEditToolbarTypeWatermark != self.editToolBarType) {
            [_effectToolBarInfoArray removeObjectAtIndex:2];
        }
    } else if (QVMediVideoEditToolbarTypeSpecialEffects == self.editToolBarType) {
       _effectToolBarInfoArray = @[
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeModifyStyle",
                @"title" : @"mn_edit_change_style",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeModifyStyleAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeTrim),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeTrim",
                @"title" : @"mn_edit_title_trim",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeTrimAction:",
                VideoTotalDuration:@([XYEngineWorkspace clipMgr].clipsTotalDuration)
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeVolume),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeVolume",
                @"action":@"xy_videoEditToolbarTypeSticker_toobarTypeVolumeAction:",
                VideoVolumeValue:@(((XYEffectVisionModel *)effctModel).volume)
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker_toobarTypeDelete),
                @"icon&title":@"QVVideoEditToolbarTypeSticker_toobarTypeDelete",
                @"action":@""
            },
           
        ].mutableCopy;
    } else if (QVMediVideoEditToolbarTypePictureInPicture == self.editToolBarType) {
        [_effectToolBarInfoArray removeObjectAtIndex:3];
    } else if (QVMediVideoEditToolbarTypeMosaic == self.editToolBarType) {
        [_effectToolBarInfoArray removeObjectAtIndex:2];
        [_effectToolBarInfoArray removeObjectAtIndex:2];
        [_effectToolBarInfoArray removeObjectAtIndex:_effectToolBarInfoArray.count - 2];
    }
    
    return _effectToolBarInfoArray;
}

- (NSArray *)defaultVideoEditToolbarDataSourceArray {
    if (!_defaultToolbarDataSourceArray) {
        _defaultToolbarDataSourceArray = @[
            @{
                @"type":@(QVMediVideoEditToolbarTypeEdit),
                @"icon&title":@"QVVideoEditToolbarTypeEdit",
                @"title" : @"mn_edit_title_edit",
                @"action":@"xy_videoEditToolbarTypeEditAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSticker),
                @"icon&title":@"QVVideoEditToolbarTypeSticker",
                @"title" : @"mn_edit_title_sticker",
                @"action":@"xy_videoEditToolbarTypeStickerAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSpecialEffects),
                @"icon&title":@"QVVideoEditToolbarTypeSpecialEffects",
                @"title" : @"mn_edit_title_fx",
                @"action":@"xy_videoEditToolbarTypeSpecialEffectsAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypePictureInPicture),
                @"icon&title":@"QVVideoEditToolbarTypePictureInPicture",
                @"title" : @"mn_edit_title_collages",
                @"action":@"xy_videoEditToolbarTypePictureInPictureAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeWatermark),
                @"icon&title":@"QVVideoEditToolbarTypeWatermark",
                @"title" : @"mn_edit_title_watermark",
                @"action":@"xy_videoEditToolbarTypeWatermarkAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeMosaic),
                @"icon&title":@"QVVideoEditToolbarTypeMosaic",
                @"title" : @"mn_edit_title_mosaic",
                @"action":@"xy_videoEditToolbarTypeMosaicAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeSubtitle),
                @"icon&title":@"QVVideoEditToolbarTypeSubtitle",
                @"title" : @"mn_edit_title_subtitle",
                @"action":@"xy_videoEditToolbarTypeSubtitleAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeTheme),
                @"icon&title":@"QVVideoEditToolbarTypeTheme",
                @"title" : @"mn_edit_title_theme",
                @"action":@"xy_videoEditToolbarTypeThemeAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeAudio),
                @"icon&title":@"QVVideoEditToolbarTypeAudio",
                @"title" : @"mn_edit_title_dubbing",
                @"action":@"xy_videoEditToolbarTypeAudioAction:"
            },
            @{
                @"type":@(QVMediVideoEditToolbarTypeScale),
                @"icon&title":@"QVVideoEditToolbarTypeScale",
                @"title" : @"mn_edit_title_ratio",
                @"action":@"xy_videoEditToolbarTypeScaleAction:",
                @"scaleTypes":@[
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_normal",
                            @"XYVideoEditScaleType":@(QVMediVideoEditScaleTypeDefault)
                        },
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_1_1_normal",
                            @"XYVideoEditScaleType":@(QVMediVideoEditScaleType_1_1)
                        },
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_3_4_normal",
                            @"XYVideoEditScaleType":@(QVMediVideoEditScaleType_3_4)
                        },
                ]
            },
//            @{
//                @"type":@(XYVideoEditToolbarTypeTTS),
//                @"icon&title":@"XYVideoEditToolbarTypeTTS",
//                @"action":@"xy_videoEditToolbarTypeTTSAction:"
//            }
        ];
    }
    return _defaultToolbarDataSourceArray;
}

- (void)addEffect:(NSMutableDictionary *)param {
}

- (void)updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarType)type param:(id)param {
    QVMediVideoEditToolbarTypeSticker_toobarType actionType = type;
    NSArray *effectList = [self fetchEffectModels];
    XYEffectModel *effctModel;
    if (self.effectSeletedIdx < effectList.count) {
        effctModel = effectList[self.effectSeletedIdx];
    }
    if (!effctModel) {
        return;
    }
    effctModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
    if (QVMediVideoEditToolbarTypeSubtitle == self.editToolBarType) {
        effctModel.taskID = XYCommonEngineTaskIDEffectVisionTextUpdate;
    }
    if (QVMediVideoEditToolbarTypeSticker_toobarTypeTrim == actionType) {
        effctModel.destVeRange.dwPos = [param[VideoTrimBeginDuration] integerValue];
        effctModel.destVeRange.dwLen = [param[VideoTrimEndDuration] integerValue] - [param[VideoTrimBeginDuration] integerValue];
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeVolume == actionType) {
        ((XYEffectVisionModel *)effctModel).volume = [param[VideoVolumeValue] floatValue];
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeOpacity == actionType) {//透明度
        ((XYEffectVisionModel *)effctModel).alpha = [param[VideoVolumeValue] floatValue] / 100.0;
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeZoom == actionType) {
        CGFloat modifiedWidth;
        if ([@"zoomIn" isEqualToString:param]) {
            modifiedWidth = ((XYEffectVisionModel *)effctModel).width - 3;
            ((XYEffectVisionModel *)effctModel).width = modifiedWidth;
            ((XYEffectVisionModel *)effctModel).height = ((XYEffectVisionModel *)effctModel).height - 3;
        } else {
            modifiedWidth = ((XYEffectVisionModel *)effctModel).width + 3;
            ((XYEffectVisionModel *)effctModel).width = modifiedWidth;
            CGFloat height = ((XYEffectVisionModel *)effctModel).height + 3;
            ((XYEffectVisionModel *)effctModel).height = height;
            if (XYCommonEngineGroupIDMosaic == effctModel.groupID) {
                ((XYEffectVisionModel *)effctModel).height = modifiedWidth;
            }
        }
        if ([effctModel isKindOfClass:[XYEffectVisionTextModel class]]) {
                    CGFloat currentScale = modifiedWidth / ((XYEffectVisionModel *)effctModel).defaultWidth;
                    ((XYEffectVisionModel *)effctModel).currentScale = currentScale;
        }
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeDelete == actionType) {
        effctModel.taskID = XYCommonEngineTaskIDEffectVisionDelete;
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeMirror == actionType) {
       ((XYEffectVisionModel *)effctModel).horizontalReversal = !((XYEffectVisionModel *)effctModel).horizontalReversal;
    }  else if (QVMediVideoEditToolbarTypeSticker_toobarTypeRotate == actionType) {
        ((XYEffectVisionModel *)effctModel).rotation = ((XYEffectVisionModel *)effctModel).rotation + 90;
        ((XYEffectVisionModel *)effctModel).rotation = ((XYEffectVisionModel *)effctModel).rotation % 360;
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText == actionType) {
        ((XYEffectVisionTextModel *)effctModel).multiTextList[0].text = param;
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle == actionType && [param isKindOfClass:[NSString class]]) {
        effctModel.filePath = param;
    } else if (QVMediVideoEditToolbarTypeSticker_toobarTypeModifyStyle == actionType) {
        NSString * pastePath = param[@"info"][@"filePath"];
        NSInteger templateID = [param[@"info"][@"templateID"] integerValue] ;
        effctModel.filePath = pastePath;
        effctModel.templateID = templateID;
    }
    
    [[XYEngineWorkspace effectMgr] runTask:effctModel];
}

- (NSArray *)fetchEffectModels {
    XYCommonEngineGroupID groupID;
    switch (self.editToolBarType) {
        case QVMediVideoEditToolbarTypeSticker:
            groupID = XYCommonEngineGroupIDSticker;
            break;
        case QVMediVideoEditToolbarTypePictureInPicture:
            groupID = XYCommonEngineGroupIDCollage;
            break;
        case QVMediVideoEditToolbarTypeWatermark:
            groupID = XYCommonEngineGroupIDWatermark;
            break;
        case QVMediVideoEditToolbarTypeMosaic:
            groupID = XYCommonEngineGroupIDMosaic;
            break;
        case QVMediVideoEditToolbarTypeSubtitle:
            groupID = XYCommonEngineGroupIDText;
            break;
            
        default:
            break;
    }
    NSArray *effectList = [[XYEngineWorkspace effectMgr]effectModels:groupID];
    return effectList;
}

- (void)updateAddImageViewView {
    NSArray *effectList = [self fetchEffectModels];
    [self.iconImageArray removeAllObjects];
    [effectList enumerateObjectsUsingBlock:^(XYEffectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            if ([XYCommonEngineRequest requestTemplateThumbnail:obj size:CGSizeMake(50, 50)]) {
                [self.iconImageArray addObject:[XYCommonEngineRequest requestTemplateThumbnail:obj size:CGSizeMake(50, 50)]];
            }
        }
    }];
    [self.addImageView setDataSource:self.iconImageArray];

}

-(void)videoEditView_xy_videoEditToolbarTypeSubtitle_toobarTypeEditAction:(id)info {
    [self updateEffect:(QVMediVideoEditToolbarTypeSticker_toobarTypeModifyText) param:info];
}

- (PHAsset *)getPHAssetWithPath:(NSString *)path {
    if (path == nil) {
        return nil;
    }
    
    NSString *prefixIdentifier = @"PHASSET://";
    NSString* pStr = [[NSString alloc] initWithUTF8String:[path UTF8String]];
    NSString *identifier = [pStr substringWithRange:NSMakeRange(prefixIdentifier.length, path.length-prefixIdentifier.length)];
    
    if (!identifier) {
        return nil;
    }
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    
    if (fetchResult.count <= 0) {
        return nil;
    }
    
    PHAsset *asset = [fetchResult objectAtIndex:0];
    
    if (!asset) {
        return nil;
    }
    
    return asset;
}

@end
