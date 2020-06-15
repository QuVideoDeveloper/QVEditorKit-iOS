/*
 * CXiaoYingSlideShowSceCfgInfo.h
 *
 *
 * History
 *    
 * 2018-08-10 YifeiFeng
 * - Init version
 *		
 */


@interface CXiaoYingSlideShowSceCfgItem : NSObject
{
    UInt64 _ulID;               //template id
    UInt32 _uiSrcCount;         //source count
    UInt32 _uiRevCount;         //count of source reserved to next scene
    UInt32* _puiPreviewPos;     //preview posiiton for each source
    MRECT* _pRegion;            //source region
}

@property(readwrite, nonatomic) UInt64 ulID;
@property(readwrite, nonatomic) UInt32 uiSrcCount;
@property(readwrite, nonatomic) UInt32 uiRevCount;
@property(readwrite, nonatomic) UInt32* puiPreviewPos;
@property(readwrite, nonatomic) MRECT* pRegion;
@end

@interface CXiaoYingSlideShowSceCfgInfo : NSObject
{
    UInt32 _uiVersion;
    UInt32 _uiBestDispTime;             //Best display time length of this theme
	MBool  _OnlySceneMode;
    NSMutableArray<CXiaoYingSlideShowSceCfgItem*>* _pCoverItem;        //cover item,element type is CXiaoYingSlideShowSceCfgItem
    NSMutableArray<CXiaoYingSlideShowSceCfgItem*>* _pBodyItem;         //body item
    NSMutableArray<CXiaoYingSlideShowSceCfgItem*>* _pBackItem;         //back cover item
}

@property(readwrite, nonatomic) UInt32 uiVersion;
@property(readwrite, nonatomic) UInt32 uiBestDispTime;
@property(readwrite, nonatomic) NSMutableArray* pCoverItem;
@property(readwrite, nonatomic) NSMutableArray* pBodyItem;
@property(readwrite, nonatomic) NSMutableArray* pBackItem;
@property(readwrite, nonatomic) MBool OnlySceneMode;
@end
