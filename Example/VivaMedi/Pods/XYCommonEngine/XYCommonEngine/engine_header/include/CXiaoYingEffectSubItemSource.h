/*CXiaoYingEffectSubItemSource
*
*Reference:
*
*Description: Define XiaoYing Effect  API. by chenglong 2019/11/22
*
*/

@interface CXiaoYingEffectSubItemSource : NSObject
{
    UInt32 _dwEffctSubType;
	MFloat _fLayerID;//
	UInt32 _dwFrameType;
	UInt64 _hEffect;//
	UInt32 _dwEffectMode;//0 storyboard, 1 effect
	NSString *_pnsTemplatePath;
}

@property(readwrite, nonatomic,strong) NSString* _pnsTemplatePath;
@property(readwrite, nonatomic) MDWord _dwEffctSubType;
@property(readwrite, nonatomic) MFloat _fLayerID;
@property(readwrite, nonatomic) MHandle _hEffect;
@property(readwrite, nonatomic) MDWord _dwEffectMode;
@property(readwrite, nonatomic) MHandle _dwFrameType;

- (void)setEffectSubSourceData:(NSString *)pnsTemplatePath SubType:(UInt32)subType EffectMode:(UInt32)effectMode FrameType:(UInt32)frameType;


- (void)getEffectSubSourceData:(QVET_EFFECT_SUB_ITEM_SOURCE_TYPE *)pSubData;



@end // CXiaoYingLyricData
