//
//  XYScrollToolbarSelectView.m
//  Pods
//
//  Created by chaojie zheng on 2020/4/15.
//

#import "QVMediScrollToolbarSelectView.h"
#import <XYCategory/XYCategory.h>
#import <Masonry/Masonry.h>
#import "QVMediButton.h"
#import "QVMediToolbarTool.h"
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
#import <QVMediTools/UIImage+QVMedi.h>
#import "QVMediTools.h"
#import "UIColor+QVMediInit.h"

// 目前只有一种创建方法
#define defaultCreatToolbarAction @"createToolbarWithData:itemInfo:changeSelect:selectFinish:"

@interface QVMediScrollToolbarSelectView ()

@property (nonatomic,   copy) void(^selectFinishBlock)(id selectData);

@property (nonatomic, strong) id targetResoure;


@property (nonatomic, strong) NSDictionary *actionDic;


@end

@implementation QVMediScrollToolbarSelectView

- (void)createScrollToolbarWithData:(NSArray *)data toolbarType:(QVMediScrollToolbarType)toolbarType action:(NSString *)action {
//    NSAssert(data && data.count, @"❌ data must Available array!");
   
    [self createScrollToolbarWithData:data toolbarType:toolbarType changeSelect:nil action:action selectFinish:nil];
}

- (NSArray *)getData:(NSString *)action {
    NSDictionary *dic = [QVMediToolbarTool getTemplateDic];
    NSString *key = action;
    NSArray *tidList = [dic valueForKey:key];
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:tidList.count];
    for (NSString *tid in tidList) {
        UInt64 templateID = [QVMediToolbarTool qvmedi_getLongLongFromString:tid];
        XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];
        NSString *title = [[XYTemplateDataMgr sharedInstance] getTitle:item];
        UIImage *logoImage = [[XYTemplateDataMgr sharedInstance] getTemplateLogoImage:item];
        if (0x0900000000000136 == templateID) {
            logoImage = [UIImage qvmedi_imageWithName:@"ft_132458_4000" bundleName:@"QVMediToolbarKit"];
        }
        if (!title) {
            title = @"";
        }
        
        if (logoImage) {
            [dataList addObject:@{@"icon":logoImage,@"title":title, @"templateID":@(templateID), @"filePath":item.strPath}];
        } else {
            [dataList addObject:@{@"icon":item.strLogo,@"title":title, @"templateID":@(templateID), @"filePath":item.strPath}];
        }
    }
   return dataList;
}

- (void)createScrollToolbarWithData:(NSArray *)data toolbarType:(QVMediScrollToolbarType)toolbarType  changeSelect:(SelectBlcok)changeSelect action:(NSString *)action selectFinish:(SelectBlcok)finish {
    if (QVMediScrollToolbarCardPoint == toolbarType) {
        __block NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:4];
        NSArray *tempateIDs = @[@(0x010000000040042E), @(0x0100000000400411), @(0x0100000000400423), @(0x0100000000400436)];
        [tempateIDs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger templateID = [obj integerValue];
            XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];
            NSString *title = [[XYTemplateDataMgr sharedInstance] getTitle:item];
//            UIImage *logoImage = [[XYTemplateDataMgr sharedInstance] getTemplateLogoImage:item];
            [dataList addObject:@{@"icon":@"qvsctoolbartestIcon",@"title":title, @"templateID":@(templateID), @"filePath":item.strPath}];
        }];
        data = dataList;
    } else if ([action isEqualToString:@"xy_videoEditToolbarAddMosaic:"]) {
        NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:2];
        XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:0x0500000000300002];
        [dataList addObject:@{@"icon":[UIImage qvmedi_imageWithName:@"edtor_icon_text_effect_mosaic_blur" bundleName:@"QVMediToolbarKit"],@"title":@"", @"templateID":@(0x0500000000300002), @"filePath":item.strPath}];
        XYTemplateItemData *item1 = [[XYTemplateDataMgr sharedInstance] getByID:0x0500000000300001];
        [dataList addObject:@{@"icon":[UIImage qvmedi_imageWithName:@"edtor_icon_text_effect_mosaic_square" bundleName:@"QVMediToolbarKit"],@"title":@"", @"templateID":@(0x0500000000300001), @"filePath":item1.strPath}];
        data = dataList;
    } else if (action) {
        data = [self getData:action];
    }
    NSAssert(data && data.count, @"❌ data must Available!");
    self.toolbarItemClickBlock = changeSelect;
    self.selectFinishBlock = finish;
    self.toolbarType = toolbarType;
    NSDictionary *itemInfoDic = self.actionDic[@(toolbarType)];
    SEL sel = NSSelectorFromString(itemInfoDic[@"action"]);
    IMP imp = [self methodForSelector:sel];
    ((id(*)(id, SEL, NSArray *, NSDictionary *, SelectBlcok, SelectBlcok))imp)(
                                                                               self,
                                                                                sel,
                                                                               data,
                                                                        itemInfoDic,
                                                                        changeSelect,
                                                                               finish
                                                                                );
}

#pragma mark- select card point
- (void)createToolbarWithData:(NSArray *)data
                     itemInfo:(NSDictionary *)itemInfoDic
                 changeSelect:(SelectBlcok)changeSelect
                 selectFinish:(SelectBlcok)finish {
    NSString *title = itemInfoDic[@"title"];
    BOOL canSelectNone = [itemInfoDic[@"canSelectNone"] boolValue];
    BOOL showTitle = [itemInfoDic[@"showTitle"] boolValue];
    BOOL showBottomView = [itemInfoDic[@"showBottomView"] boolValue];
    BOOL UpImageBelowTitle = [itemInfoDic[@"UpImageBelowTitle"] boolValue];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIScrollView *itemBgScView = [UIScrollView new];
    itemBgScView.backgroundColor = [UIColor qvmedi_colorWithHEX:0x101112];
    itemBgScView.showsVerticalScrollIndicator = NO;
    itemBgScView.showsHorizontalScrollIndicator = NO;
    [self addSubview:itemBgScView];
    [itemBgScView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!showBottomView) {
            make.edges.equalTo(self);
        }else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, (45 + [QVMediTools qv_safeAreaBottom]), 0));
        }
    }];

    if (UpImageBelowTitle) {
        [self creatSubItemView:itemBgScView data:data title:title];
    }else {
        [self creatSubItemView:itemBgScView data:data title:title canSelectNone:canSelectNone showTitle:showTitle];
    }
    
    [itemBgScView.subviews.lastObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22);
    }];
    
    if (showBottomView) {
        UIView *bottomActionView = [UIView new];
        bottomActionView.backgroundColor = [UIColor xy_colorWithHEX:0x000102];
        [self addSubview:bottomActionView];
        [bottomActionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemBgScView.mas_bottom);
            make.height.offset(45);
            make.left.right.equalTo(self);
        }];
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = NSLocalizedString(title, @"");
        tipLabel.textColor = [UIColor xy_colorWithHEX:0xE6E6E6];
        tipLabel.font = [UIFont systemFontOfSize:14];
        [bottomActionView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bottomActionView);
        }];
        self.bottomTitleLabel = tipLabel;
        
        UIButton *finishButton = [UIButton new];
        [finishButton setImage:[UIImage qvmedi_imageWithName:@"qv_selectToolbarItem_selectFinish" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(finishSelect) forControlEvents:UIControlEventTouchUpInside];
        [bottomActionView addSubview:finishButton];
        [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tipLabel);
            make.left.offset([UIScreen mainScreen].bounds.size.width - 48);
        }];
    }
}

- (void)creatSubItemView:(UIScrollView *)itemBgScView
                    data:(NSArray *)dataArray
                   title:(NSString *)title {
    MASViewAttribute *lastViewAt = itemBgScView.mas_left;
    for (int index = 0; index < dataArray.count; index++) {
        NSDictionary *itemInfoDic = dataArray[index];
        QVMediButton *itemButton = [QVMediButton new];
        itemButton.qvmedi_ButtonType = QVMediButtonStyleUpImageBelowTitle;
        itemButton.xy_parameter = itemInfoDic;
        [itemButton setImage:[UIImage qvmedi_imageWithName:[NSString stringWithFormat:@"qv_QVUIKit_%@_normal",itemInfoDic[@"icon&title"]] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [itemButton setTitle:NSLocalizedString(itemInfoDic[@"icon&title"], @"") forState:UIControlStateNormal];
        if (itemInfoDic[@"title"]) {
            [itemButton setTitle:NSLocalizedString(itemInfoDic[@"title"], @"") forState:UIControlStateNormal];
        }
        [itemButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [itemButton addTarget:self action:@selector(toolbarClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBgScView addSubview:itemButton];
        CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - 11)/5.8;
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(lastViewAt).offset(index?0:11);
            make.top.mas_equalTo(35);
            make.width.mas_equalTo(itemW);
            make.height.mas_equalTo(40);
        }];
        lastViewAt = itemButton.mas_right;
    }
}

- (void)creatSubItemView:(UIScrollView *)itemBgScView
                    data:(NSArray *)data
                   title:(NSString *)title
           canSelectNone:(BOOL)canSelectNone
               showTitle:(BOOL)showTitle {
    MASViewAttribute *lastViewAt = itemBgScView.mas_left;
     NSMutableArray *muDataArray = [NSMutableArray arrayWithArray:data];
     if (canSelectNone) {
         [muDataArray insertObject:@{@"title":@"",@"icon":@""} atIndex:0];
     }
     for (int index = 0; index < muDataArray.count; index++) {
         NSDictionary *itemInfoDic = muDataArray[index];
         UILabel *titleLabel = [UILabel new];
         if (showTitle) {
             if ((canSelectNone && index > 0) || !canSelectNone) {
                 titleLabel.text = itemInfoDic[@"title"];//[NSString stringWithFormat:NSLocalizedString(@"XYToolbarCardPointValue", @""),index];
             }
             titleLabel.textColor = [UIColor xy_colorWithHEX:0xE6E6E6];
             titleLabel.font = [UIFont systemFontOfSize:10];
             titleLabel.textAlignment = NSTextAlignmentCenter;
             [itemBgScView addSubview:titleLabel];
             [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.width.offset(60);
                 make.top.offset(0);
                 make.left.mas_equalTo(lastViewAt).offset(index?8:22);
                 make.height.offset(14);
             }];
             lastViewAt = titleLabel.mas_right;
         }
         UIButton *itemButton = [UIButton new];
         itemButton.xy_parameter = @{@"isNoneItem":@NO, @"info":itemInfoDic, @"index":@(index)};
         itemButton.layer.cornerRadius = 4;
         [itemButton addTarget:self action:@selector(itemCilckAction:) forControlEvents:UIControlEventTouchUpInside];
         if ([itemInfoDic[@"icon"] isKindOfClass:[NSString class]]) {
             NSString *imageName = itemInfoDic[@"icon"];
             if ([imageName hasSuffix:@"webp"]) {
                 [itemButton setImage:[UIImage qvmedi_imageWithName:[NSString stringWithFormat:@"%d",index] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
             }
            else if (imageName.length) {
                 [itemButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
             }
         }else if ([itemInfoDic[@"icon"] isKindOfClass:[UIImage class]]) {
             UIImage *image = itemInfoDic[@"icon"];
             if (image) {
                 [itemButton setImage:image forState:UIControlStateNormal];
             }
         }

         itemButton.clipsToBounds = YES;
         [itemBgScView addSubview:itemButton];
         if (index == 0) {
             if (canSelectNone) {
                 itemButton.xy_parameter = @{@"isNoneItem":@YES, @"info":itemInfoDic, @"index":@(index)};
                 [itemButton setImage:[UIImage qvmedi_imageWithName:@"qv_selectToolbarItem_none_normal" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
                 [itemButton setImage:[UIImage qvmedi_imageWithName:@"qv_selectToolbarItem_none_hight" bundleName:@"QVMediToolbarKit"] forState:UIControlStateSelected];
             }
             self.curSelectButton = itemButton;
             self.targetResoure = itemButton.xy_parameter;
             [self addBorder:itemButton];
         }
         [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.offset(60);
             make.height.offset(68);
             if (showTitle) {
                 make.centerX.equalTo(titleLabel);
                 make.top.mas_equalTo(titleLabel.mas_bottom).offset(8);
             }else {
                 make.left.mas_equalTo(lastViewAt).offset(index?8:22);
                 make.top.offset(20);
             }
         }];
         if (!showTitle) {
             lastViewAt = itemButton.mas_right;
         }
     }
}

- (void)addBorder:(UIButton *)button {
    BOOL isNoneItem = [button.xy_parameter[@"isNoneItem"] boolValue];
    self.curSelectButton.selected = NO;
    self.curSelectButton.layer.borderWidth = 0;
    self.curSelectButton.layer.borderColor = UIColor.clearColor.CGColor;
    [UIView animateWithDuration:.1f animations:^{
        self.curSelectButton.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    }];
    if (isNoneItem) {
        button.selected = YES;
        self.curSelectButton = button;
        return;
    }
    [UIView animateWithDuration:.1f animations:^{
        button.transform = CGAffineTransformMake(1.1, 0, 0, 1.1, 0, 0);
    }];
    button.layer.borderWidth = 2;
    button.layer.borderColor = UIColor.redColor.CGColor;
    self.curSelectButton = button;
}

#pragma mark- action
- (void)itemCilckAction:(UIButton *)target {
    [self addBorder:target];
    self.targetResoure = target.xy_parameter;
    if (self.toolbarItemClickBlock) {
        self.toolbarItemClickBlock(self.targetResoure);
    }
}

- (void)toolbarClickAction:(QVMediButton *)target {
    self.targetResoure = target.xy_parameter;
    if (self.toolbarItemClickBlock) {
        self.toolbarItemClickBlock(self.targetResoure);
    }
}

- (void)finishSelect {
    if (self.selectFinishBlock) {
        self.selectFinishBlock(self.targetResoure);
    }
}

#pragma mark- get set lazy

- (void)setTitle:(NSString *)title {
    _title = title;
    NSAssert(self.bottomTitleLabel, @"❌ No titlelabel created！");
    self.bottomTitleLabel.text = title;
}

- (NSDictionary *)actionDic {
    if (!_actionDic) {
        _actionDic = @{
            @(QVMediScrollToolbarCardPoint):@{@"action":defaultCreatToolbarAction,
                                          @"title":@"mn_app_mode_template",
                                          @"canSelectNone":@NO,
                                          @"showTitle":@YES,
                                          @"showBottomView":@YES,
                                          @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarSongs):@{@"action":defaultCreatToolbarAction,
                                      @"title":@"XYToolbarTitleSongs",
                                      @"canSelectNone":@YES,
                                      @"showTitle":@YES,
                                      @"showBottomView":@YES,
                                      @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarSoundEffects):@{@"action":defaultCreatToolbarAction,
                                             @"title":@"XYToolbarTitleSongEffects",
                                             @"canSelectNone":@YES,
                                             @"showTitle":@YES,
                                             @"showBottomView":@YES,
                                             @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarSpecialEffects):@{@"action":defaultCreatToolbarAction,
                                               @"title":@"XYToolbarTitleSongEffects",
                                               @"canSelectNone":@YES,
                                               @"showTitle":@YES,
                                               @"showBottomView":@YES,
                                               @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarThemes):@{@"action":defaultCreatToolbarAction,
                                       @"title":@"XYToolbarTitleThemes",
                                       @"canSelectNone":@YES,
                                       @"showTitle":@YES,
                                       @"showBottomView":@YES,
                                       @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarFilter):@{@"action":defaultCreatToolbarAction,
                                       @"title":@"XYToolbarTitleFilter",
                                       @"canSelectNone":@YES,
                                       @"showTitle":@YES,
                                       @"showBottomView":@NO,
                                       @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarVideoEdit):@{@"action":defaultCreatToolbarAction,
                                          @"title":@"XYVideoEditToolbarTypeEdit",
                                          @"canSelectNone":@NO,
                                          @"showTitle":@YES,
                                          @"showBottomView":@YES,
                                          @"UpImageBelowTitle":@YES
            },
            @(QVMediScrollToolbarVideoEditTransition):@{@"action":defaultCreatToolbarAction,
                                                    @"title":@"XYScrollToolbarVideoEditTransition",
                                                    @"canSelectNone":@YES,
                                                    @"showTitle":@YES,
                                                    @"showBottomView":@NO,
                                                    @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarVideoEditAddSticker):@{@"action":defaultCreatToolbarAction,
                                                    @"title":@"XYScrollToolbarVideoEditAddSticker",
                                                    @"canSelectNone":@NO,
                                                    @"showTitle":@NO,
                                                    @"showBottomView":@YES,
                                                    @"UpImageBelowTitle":@NO
            },
            @(QVMediScrollToolbarVideoEditSubtitle):@{@"action":defaultCreatToolbarAction,
                                                  @"title":@"XYScrollToolbarVideoEditAddSubTitle",
                                                  @"canSelectNone":@NO,
                                                  @"showTitle":@NO,
                                                  @"showBottomView":@YES,
                                                  @"UpImageBelowTitle":@NO
                                                  
            },
            @(QVMediScrollToolbarVideoEditAddMosaic):@{@"action":defaultCreatToolbarAction,
                                                  @"title":@"XYScrollToolbarVideoEditAddMosaic",
                                                  @"canSelectNone":@NO,
                                                  @"showTitle":@NO,
                                                  @"showBottomView":@YES,
                                                  @"UpImageBelowTitle":@NO
                                                  
            }
            
        };
    }
    return _actionDic;
}

@end
