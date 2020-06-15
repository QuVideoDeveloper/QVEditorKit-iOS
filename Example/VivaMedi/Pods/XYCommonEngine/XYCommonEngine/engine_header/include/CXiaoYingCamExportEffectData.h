/*
 * CXiaoYingCamExportEffectData.h
 *
 *
 * History
 *    
 * 2017-03-31 YifeiFeng
 * - Init version
 *		
 */
@interface CXiaoyingEffectPropData : NSObject
{
    UInt32 _uiID;
    SInt32 _siValue;
}
@property(readwrite,nonatomic) UInt32 uiID;
@property(readwrite,nonatomic) SInt32 siValue;
@end

 @interface CXiaoYingCamExportEffectData : NSObject
 {
     UInt64 _ulID;               //template id
     NSMutableArray<CXiaoyingEffectPropData*>* _pPropData; //effect prop data
 }
 @property(readwrite,nonatomic) UInt64 ulID;
 @property(readwrite,nonatomic,strong) NSMutableArray* pPropData;

 @end
