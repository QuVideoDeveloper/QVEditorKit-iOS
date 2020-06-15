/*CXiaoYingEngine.h
*
*Reference:
*
*Description: Define XiaoYing Engine API.
*
*/
@protocol CXiaoYingTemplateAdapter <NSObject>
- (MRESULT) GetTemplateFile : (MInt64) llID
                              TemplatePath : (MTChar*) szTemplatePath
                              BubberSize : (MDWord) dwBufSize;

- (MInt64) GetTemplateID : (const MTChar*) szTemplatePath;

- (MRESULT) GetTemplateExternalFile : (MInt64) templateID
                           SubTemID : (MDWord) subTemplateID
                            FileID : (MDWord) fileID
                           FilePath : (MTChar*) szFilePath
                            PathLen : (MDWord) dwLen;

@end

@protocol CXiaoYingFilePathAdapter <NSObject>
- (MRESULT) ModifyFilePath : (MTChar*)pszFileToModify
                 StrBufLen : (MDWord)dwStrBufLen;
@end

@protocol CXiaoYingFontAdapter <NSObject>
- (MRESULT) FindFont : (MTChar*)pszFont /*out*/
           strBufLen : (MDWord)dwLen
               byIdx : (MDWord)dwIdx;   /*in*/
@end

@protocol CXiaoyingTextTransformer <NSObject>
- (NSString*) TransformText : (NSString*) pstrOrgText
                      Param : (AMVE_TEXT_TRANSFORM_PARAM*)pParam;
@end


@interface CXiaoYingEngine : NSObject
{
    
}

@property(readonly, nonatomic) MHandle hSessionContext;
@property(readonly, nonatomic) MHandle hAMCM;

/**
 * Creates the XiaoYing Engine. It initializes the state of XiaoYing Engine 
 * and must be called after new a XiaoYingEngine instance.
 * 
 * @ param tempadapter,templater callback adapter
 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Create : (id <CXiaoYingTemplateAdapter>) tempadapter
    FilePathModifyAdapter   : (id <CXiaoYingFilePathAdapter>) FPMadapter
    LicensePath : (MTChar*) szLicensePath;

/**
* Destroys the XiaoYing Engine.
* 
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Destory;

/**
 * Sets the property of XiaoYing Engine.
 * 
 * @param dwPropertyID property id.
 * @param pValue data set to the specific property.
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) SetProperty: (MDWord) dwPropertyID Value : (MVoid*) pValue;


/**
 * Gets the property of XiaoYing Engine.
 * 
 * @param dwPropertyID property id.
 * @param pValue data set to the specific property.
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
*/
	 

- (MRESULT) GetProperty: (MDWord) dwPropertyID Value : (MVoid*) pValue;

- (MDWord) GetVersion;

@end // CXiaoYingEngine







