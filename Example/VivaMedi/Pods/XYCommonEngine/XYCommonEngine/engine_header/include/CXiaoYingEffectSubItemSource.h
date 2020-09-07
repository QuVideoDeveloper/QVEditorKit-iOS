/*CXiaoYingEffectSubItemSource
*
*Reference:
*
*Description: Define XiaoYing Effect  API. by chenglong 2019/11/22
*
*/

@interface CXiaoYingEffectSubItemSource : NSObject
{

}

@property(readwrite, nonatomic,strong) NSString* pnsTemplatePath;
@property(readwrite, nonatomic) MDWord dwEffctSubType;
@property(readwrite, nonatomic) MFloat fLayerID;
@property(readwrite, nonatomic) MHandle hEffect;
@property(readwrite, nonatomic) MDWord dwEffectMode;
@property(readwrite, nonatomic) MDWord dwFrameType;

- (void)setEffectSubSourceData:(NSString *)pnsTemplatePath SubType:(UInt32)subType EffectMode:(UInt32)effectMode FrameType:(UInt32)frameType;


- (void)getEffectSubSourceData:(QVET_EFFECT_SUB_ITEM_SOURCE_TYPE *)pSubData;



@end // CXiaoYingLyricData
