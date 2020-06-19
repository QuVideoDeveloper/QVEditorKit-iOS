/*CXiaoYingFaceDTUtils.h
*
*Reference:
*
*Description: Define XiaoYing face dt Utils API.
*
*/

@interface CXiaoYingFaceDTUtils : NSObject
{
    
}


/**
 *  Create face dt handle
 *  @param  hAPPContext [in] app context
 *  @param pstrDataFile [in] track data file path
 *  @param pEngine [in] Engine instance
 *  @return 0 if success,otherwise return error code
 **/
- (UInt32) Create : (MHandle _Nullable) hAPPContext
         DataFile : (NSString* _Nonnull)pstrDataFile
           Engine : (CXiaoYingEngine* _Nonnull) pEngine;

/**
 *  Detect face by image
 *  @param  pstrImgFile [in] image url
 *  @param pDTResult [in/out] detect result
 *  @return 0 if success,otherwise return error code
 **/
- (UInt32) DetectFaceByImage : (NSString* _Nonnull)pstrImgFile
                    DTResult : (AMVE_FACEDT_RESULT_TYPE* _Nonnull)pDTResult;

/**
 *  Check face dt lib license file,only need to check once when App start
 *  @param  pstrLicFile [in] license file url
 *  @return 0 if license is valid,otherwise return error code
 **/
+ (UInt32) CheckFaceDTLicenseFile : (NSString* _Nonnull)pstrLicFile;

/**
 *  Check face dt lib license file data,only need to check once when App start
 *  @param  pData [in] license file data
 *  @param uiLength[in] license file data length
 *  @return 0 if license is valid,otherwise return error code
 **/
+ (UInt32) CheckFaceDTLiceseData : (UInt8* _Nonnull)pData
                         DateLen : (UInt32)uiLength;

@end // CXiaoYingFaceDTUtils


