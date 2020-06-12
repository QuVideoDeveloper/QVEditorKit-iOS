/*
 * CXiaoYing3DMaterialItem.h
 *
 *
 * History
 *    
 * 2017-03-31 YifeiFeng
 * - Init version
 *		
 */
 @interface CXiaoYing3DMaterialItem : NSObject
 {
     NSString* strMaterialName;
     UInt32 uiParamID;
     CXIAOYING_SIZE NodeSize;
     CXIAOYING_SIZE ViewSize;
     UInt32 uiResampleMode;
     UInt32 uiTAParamID;
     UInt32 uiTAOrigin;
 }
 @property(readwrite,nonatomic,strong) NSString* strMaterialName;
 @property(readwrite,nonatomic) SInt32 uiParamID;
 @property(readwrite,nonatomic) CXIAOYING_SIZE NodeSize;
 @property(readwrite,nonatomic) CXIAOYING_SIZE ViewSize;
 @property(readwrite,nonatomic) UInt32 uiResampleMode;
 @property(readwrite,nonatomic) UInt32 uiTAParamID;
 @property(readwrite,nonatomic) UInt32 uiTAOrigin;
 @end
