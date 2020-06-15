/*
 * CXiaoYingEffectSwitchInfo.h
 *
 *
 * History
 *    
 * 2017-02-13 YifeiFeng
 * - Init version
 *		
 */

typedef struct
{
    UInt32 uiItemCount;
    UInt32* pItemList;
}CXIAOYING_EFFECT_SWITCH_GROUP_INFO;

@interface CXiaoYingEffectSwichInfo : NSObject
{
    UInt32 _uiType;
    Boolean _bRandom;
    UInt32 _uiGroupCount;
    CXIAOYING_EFFECT_SWITCH_GROUP_INFO* _pGroupList;
}
@property(readwrite,nonatomic) UInt32 uiType;
@property(readwrite,nonatomic) Boolean bRandom;
@property(readwrite,nonatomic) UInt32 uiGroupCount;
@property(readwrite,nonatomic) CXIAOYING_EFFECT_SWITCH_GROUP_INFO* pGourpList;
@end



