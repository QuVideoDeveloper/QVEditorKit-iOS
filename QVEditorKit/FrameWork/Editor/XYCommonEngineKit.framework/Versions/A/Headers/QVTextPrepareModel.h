//
//  QVTextPrepareModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QVTextPrepareMode) {
    QVTextPrepareModeLocation, // 位置信息
    QVTextPrepareModeCountry, // 国家
    QVTextPrepareModeProvince, // 省
    QVTextPrepareModeCity, //城市
    QVTextPrepareModeEnCity, // 城市的英文名称 或者中文的拼音
    QVTextPrepareModeNickName,// 昵称
    QVTextPrepareModeWeather,//天气
    QVTextPrepareModeFilmName = 0, //电影名称
    QVTextPrepareModeBackCoverTitle, // 电影片尾标题
    QVTextPrepareModeFilmMaker, //电影制作人
    QVTextPrepareModeFilmDirector, // 电影导演
    QVTextPrepareModeFilmScreenWriter, // 电影编剧
    QVTextPrepareModeFilmActor, // 电影演员
    QVTextPrepareModeFilmEditor, // 电影编辑
    QVTextPrepareModeFilmPhotographer, // 电影摄影师
};

NS_ASSUME_NONNULL_BEGIN

@interface QVTextPrepareModel : NSObject

/// 位置信息
@property (nonatomic, copy) NSString *location;

///国家
@property (nonatomic, copy) NSString *country;

///省
@property (nonatomic, copy) NSString *province;

/// 城市
@property (nonatomic, copy) NSString *city;

/// 城市的英文名称 或者中文的拼音
@property (nonatomic, copy) NSString *enCity;

///昵称
@property (nonatomic, copy) NSString *nickname;

/// 天气
@property (nonatomic, copy) NSString *weather;

///影片名称
@property (nonatomic, copy) NSString *filmName;

/// 电影片尾标题
@property (nonatomic, copy) NSString *backCoverTitle;

/// 电影制作人
@property (nonatomic, copy) NSString *filmMaker;

/// 电影导演
@property (nonatomic, copy) NSString *filmDirector;

/// 电影编剧
@property (nonatomic, copy) NSString *filmScreenWriter;

/// 电影演员
@property (nonatomic, copy) NSString *filmActor;

/// 电影编辑
@property (nonatomic, copy) NSString *filmEditor;

/// 电影摄影师
@property (nonatomic, copy) NSString *filmPhotographer;
                                         
@end

NS_ASSUME_NONNULL_END
