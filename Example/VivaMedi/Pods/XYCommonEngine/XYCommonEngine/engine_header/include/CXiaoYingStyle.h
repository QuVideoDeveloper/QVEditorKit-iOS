/*CXiaoYingStyle.h
*
*Reference:
*
*Description: Define XiaoYing Style API.
*
*/

#define QVET_TEMPLATE_THUMBNAIL_FILE_ID     3
#define QVET_TEMPLATE_DEMO_EXAMPLE_FILE_ID	12
#define QVET_TEMPLATE_MUSIC_FILE_ID			    1000


typedef struct __TagXY_BUBBLE_MEASURE_RESULT
{
    int textLines;
    int bubbleW;
    int bubbleH;
}XY_BUBBLE_MEASURE_RESULT;

typedef struct _tagCXYEffectPropertyItem
{
    MDWord dwID;
    MDWord dwMinValue;
    MDWord dwMaxValue;
    MDWord dwCurValue;
	MDWord dwStep;
	MDWord dwControlType;
	MBool  bIsUnlimitedMode;
    MBool bIsSupportKeyframe;
    MTChar* pszName;
    MTChar* pszWildCards;
}CXYEffectPropertyItem;

typedef struct _tagCXYEffectPropertyInfo
{
    MDWord dwItemCount;
    CXYEffectPropertyItem* pItems;
}CXYEffectpropertyInfo;




#define CXY_PASTER_SUBTYPE_NORMAL             0x00
#define CXY_PASTER_SUBTYPE_FACIAL             0x01
#define CXY_PASTER_SUBTYPE_FACIAL_ATTACH      0x02
#define CXY_PASTER_SUBTYPE_OT                 0x03
#define CXY_PASTER_SUBTYPE_STATIC             0x04
#define CXY_PASTER_SUBTYPE_DYNAMIC            0x05
#define CXY_COMBO_PASTER_SUBTYPE_NORMAL       0x00
#define CXY_COMBO_PASTER_SUBTYPE_FACIAL       0x01
#define CXY_COMBO_PASTER_SUBTYPE_OT           0x02
#define CXY_COMBO_SUBTYPE_TEXTANIMATION       0x03
#define CXY_FX_SUBTYPE_NORMAL                 0x00
#define CXY_FX_SUBTYPE_SINGING                0x01
#define CXY_FX_SUBTYPE_DANCING                0x02
#define CXY_FX_SUBTYPE_SELFIE                 0x03
#define CXY_TEXT_SUBTYPE_NORMAL               0x00
#define CXY_TEXT_SUBTYPE_ANIMATION            0x01
#define CXY_IE_SUBTYPE_BLEND_CAM_FD           0x07
#define CXY_IE_SUBTYPE_GRAFFITI               AMVE_IE_SUB_TYPE_GRAFFITI
#define CXY_THEME_SUBTYPE_NORMAL              0x00
#define CXY_THEME_SUBTYPE_FUNNY               0x01
#define CXY_THEME_SUBTYPE_STORY               0x02

@interface CXiaoYingStyle : NSObject
{
				
}

@property (readonly, nonatomic) MHandle hStyle;
//@property (readwrite, nonatomic) MHandle hTextThumbnailEngine;
/**
* Makes XiaoYing style handle representing a style file.
* @param pStyleFile The path of the style file.
* @param pszSerialNo The serial number of the style file.
* @param dwBGLayoutMode,landscape or portrail
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Create : (const MVoid*) pStyleFile
                      BGLayoutMode : (MDWord) dwBGLayoutMode
                      SerialNo : (const MVoid*) pszSerialNo;
                      

/**
* Breaks the link between XiaoYingStyle and style file.
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Destory;


/**
* Gets version of the style file.
* @return Version of the style file.
*/

- (MDWord) GetVersion;

/**
* Gets title of the style file.
* @param dwLanguageID Language type of the title.
* @param pszTitle,file title.
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) GetTemplateName : (MDWord) dwLanguageID
	                          Title : (MTChar*) pszTitle;

/**
 * Gets description of the style file.
 * @param dwLanguageID Language type of the description.
 * @param pDescription description string.
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) GetDescription : (MDWord) dwLanguageID
	                         Description : (MTChar*)pDescription;
	                          
/**
* Gets mode of the style file.
* @return Mode of the style file.
*/
- (MDWord) GetMode;	  

/**
* Gets thumbnail of the style file.
* @param pEngine Engine of the video editor ADK.
* @param cvImgBuf image buffer into which the thumbnail of the style file will be stored. 
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) GetThumbnail : (CXiaoYingEngine*) pEngine
	                        ImageBuffer : (CVImageBufferRef) cvImgBuf;


- (UIImage*) GetThumbnailUIImage;

/**
* Gets preview data of the music slide show style file. 
* @param pStoryBoard A XiaoYingStoryBoardSession into which the preview data of the music slide show 
* 						style file will be loaded.
* @param fnCallback Listening progress of the loading.
* @param statehandler,session state call back handler
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) GetPreviewData : (CXiaoYingStoryBoardSession*) pStoryBoard
	                          StateCallBack : (AMVE_FNSTATUSCALLBACK) fnCallback
	                          SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler; 
	                          
/**
* Gets ID of the style file.
* @return ID of the style file.
*/

- (MInt64) GetID;

/**
 * Gets dummry's flag of the style file.
 * @return true or false.
 */
- (MBool) GetDummryFlag;

- (MRESULT) GetTransInfo : (QVET_TRANSITION_INFO*)pTransInfo;


/**
* Gets Bubble template info .
* @param pEngine,Engine instance
* @param dwLanguateID language ID.
* @param pBGSize,back ground size.
* @param pInfo bubble template info.
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) GetBubbleTemplateInfo :(CXiaoYingEngine*)pEngine
                                   LanguageID : (MDWord) dwLanguageID
	                                BGSize : (MSIZE*) pBGSize
	                                TemplateInfo : (QVET_BUBBLE_TEMPLATE_INFO*) pInfo;

/**
 * Gets Bubble template info .
 * @param pEngine,Engine instance
 * @param dwLanguateID language ID.
 * @param dwParamID  Text Param ID
 * @param pBGSize,back ground size.
 * @param pInfo bubble template info.
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetBubbleTemplateInfo :(CXiaoYingEngine*)pEngine
                       LanguageID : (MDWord) dwLanguageID
                       ParamID    : (MDWord) dwParamID
                           BGSize : (MSIZE*) pBGSize
                     TemplateInfo : (QVET_BUBBLE_TEMPLATE_INFO*) pInfo;
/**
* Gets Animated frame template info .
* @param pBGSize, background size.
* @param pInfo  template info.
* @return MERR_NONE if the operation is successful, other value if failed.
*/
- (MRESULT) GetAnimatedFrameTemplateInfo : (MSIZE*)pBGSize
							TemplateInfo : (QVET_ANIMATED_FRAME_TEMPLATE_INFO*)pInfo;
									

/**
 * Extract example file from template
 * @param dstExampleFile example file
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) ExtractExampleFile: (MVoid*) dstExampleFile;

/**
 * Get external file count
 * @param pdwCount count pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetExternalFileCount : (MDWord*) pdwCount;

/**
 * Get external file info
 * @param pInfo file info pointer
 * @param dwCount,info count
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetExternalFileInfos : (QVET_EXTERNAL_ITEM_INFO*) pInfo
                       InfoCount : (MDWord) dwCount;

/**
 * Get supported layouts
 * @param pdwLayOut layout pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetSupportedLayouts : (MDWord*) pdwLayOut;

/**
 * Get categroy id
 * @param pdwCateID categroy id pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetCategroyID : (MDWord*) pdwCateID;


/**
 * Get configure count
 * @param pdwCount count pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetConfigureCount : (MDWord*) pdwCount;


/**
 * Get facial paster subtype and position type
 * @param pFacialType facial paster type
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) GetCategroyFacialType : (MDWord* _Nonnull) pdwSubType;



/**
 * Get sub paster template id from combo paster template
 * @return subpaster array
 */
- (NSArray<NSNumber*>* _Nullable) GetSubPasterID;

/**
 * Get facial paster's expression type
 *@param puiType,pointer to type
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (UInt32) GetPasterExpressionType : (UInt32* _Nonnull) puiType;


/*
 * used to judge if the template is based on Audio-Visualization
 */
- (MBool)IsAudioVisualizationTemplate;

/**
 * Get freeze frame templat basic info
 *@param pInfo,freeze frame basic info
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (SInt32) GetFreezeFrameBasicInfo : (QVET_FREEZE_FRAME_BASICINFO* _Nonnull) pInfo;

/*
 * used to judge if the template supports object tracking
 */
- (MBool) IsOTSupportTemplate;


- (MBool) IsSupportAlphaAdjust;

/**
 * Get switch info for combo paster
 *@param pSwitchInfo,switch info pointer
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (SInt32) GetEffectSwitchInfo : (CXiaoYingEffectSwichInfo* _Nonnull) pSwitchInfo;

/**
 * Get AB Face Info
 *@param pABFaceInfo,AB Face info pointer
 *@return 3D material item array
 */
- (SInt32) GetPasterABFacInfo : (AMVE_EFFECT_ABFACE_INFO* _Nonnull) pABFaceInfo;


/**
 * Get 3D material item array
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (NSArray<CXiaoYing3DMaterialItem*>* _Nullable) Get3DMaterialItemArray;

/**
 * Get filter duration
 * @param puiDuraion,pointer to duraion
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (SInt32) GetFilterDuration : (UInt32* _Nonnull) puiDuration;

+ (MHandle) CreatEffectThumbnailEngine:(CXiaoYingEngine *_Nonnull)pEngine
                               bgSize:(MSIZE *)pBGSize;

+ (MRESULT) GetTextThumbnail : (MHandle)hThumbnailEngine
                    textCount: (MDWord )dwTextCount
                BubbleSource : (AMVE_BUBBLETEXT_SOURCE_TYPE *) pBubbleTextSource
                 contentSize : (MSIZE*)pContentSize
                    ThumbBuf : (CVImageBufferRef)thumb
                    timeStamp:(MDWord)dwTimeStamp;

+ (MRESULT) GetThumbnail : (MHandle)hThumbnailEngine
               templateID:(MInt64)llTemplateID
                     ThumbBuf : (CVImageBufferRef)thumb
                    timeStamp:(MDWord)dwTimeStamp;

+ (MRESULT) DestroyEffectThumbnailEngine : (MHandle) hThumbnailEngine;//销毁对象

- (CXiaoYingTextMulInfo *) GetTextMulInfo:(CXiaoYingEngine *_Nonnull)pEngine
                               languageID:(MDWord)dwLanguageID
                                  bgSize : (MSIZE)bgSize;
/**
 * Judge whether slideshow theme template
 * @return MTrue if yes,otherwise return MFalse
 */
- (MBool) IsSlideShowTheme;

/**
    获取对应场景的时间
 */
- (MDWord) GetSceneDuration;
/**
 * Get slideshow theme's scene config info
 * @return scene config info
 */
- (CXiaoYingSlideShowSceCfgInfo* _Nullable) GetSlideShowSceCfgInfo;

/**
 * Get theme cover position
 * @param puiPosition,pointer to position
 * @return QVET_ERR_NONE if success,other value if failed
 */
- (SInt32) GetThemeCoverPosition : (UInt32*  _Nonnull) puiPosition;

/**
 * Judge whether template is public
 * @param templateID template id
 * @return MTrue if public,else return MFalse.
 */
+ (MBool) IsPublicTemplate : (MInt64 )templateID;

/**
 * Judge whether template is self defined
 * @param templateID template id
 * @return MTrue means this template is defined by customers
 *  MFalse means this template is published by xiaoying team
 */
+ (MBool) IsSelfDefTemplate : (MInt64) templateID;

/**
 * Get template type
 * @param templateID template id
 * @return the template type described by value of MODE_MASK_XXX.
 */
+ (MDWord) GetTemplateType : (MInt64) templateID;


/**
 * Judge whether this template is used in the theme
 * @param templateID template id
 * @return return MTrue means this template is used in the theme,it's a sub template of theme template
 */
+ (MBool) IsThemeSubTemplate : (MInt64) templateID;

/**
 * This function is only available to template which is belong to a theme.
 * If the template is a independent one,this function will return 0.
 * @param templateID template id
 * @return template subsequence id
 */
+ (MDWord) GetTemplateSubSequenceID : (MInt64) templateID;


/**
 * Get template sequence id
 There are two concept:</br>
 * 	1. Template Sequence ID</br>
 * 		1.1 If it's a independent template, it identifies the sequence in the this kind of template.</br>
 * 		1.2 if it belongs to a theme, it's the theme's sequence id. That means this template doesn't have it own SequenceID</br>
 * 	2. Template Sub Sequence ID</br>
 * 		As you see, 1.2 has tell you that the theme-belonged templates doesn't have their own SequenceID. </br>
 * 		But they have "Sub SequenceID", this ID identifies the sub sequence in the theme template group
 * @param templateID template id
 * @return template sequence id
 */
+ (MInt64) GetTemplateSequenceID : (MInt64) templateID;


/**
 * Get template reserved ID
 * @param templateID template id
 * @return template reserved id
 */
+ (MDWord) GetTemplateReservedID : (MInt64) templateID;

/**
 * Judge whether offline template
 * @param templateID template id
 * @return return MTrue if offline template,else return MFalse
 */
+ (MBool) IsOfflineTemplate : (MInt64) templateID;


/**
 * Judge whether photo template
 * @param templateID template id
 * @return return MTrue if photo template,else return MFalse
 */
+ (MBool) IsPhotoTemplate : (MInt64) templateID;


/**
 *  @param pBGSize is only used to find the best template config match the application case.
 *                  it means the bubble is applied to the BG
 *  @param pBubbleSrc contains many text properties such as color, font, text string....
 *  @param pRes is the measure result
 */
+ (MRESULT) measureBubbleByTemplate : (NSString*) templateFile
                             BGSize : (MSIZE*) pBGSize
                      bubbleTextSrc : (AMVE_BUBBLETEXT_SOURCE_TYPE*)pBubbleSrc
                             result : (XY_BUBBLE_MEASURE_RESULT*)pRes/*out, used to put the result into*/;

/**
 *  @param pBGSize is only used to find the best template config match the application case.
 *                  it means the bubble is applied to the BG
 *  @param pBubbleSrc contains many text properties such as color, font, rotate-angle, text string....
 *  @param pContentSize is the original bubble size(without rotation) you want
 *  @param thumb is used to put the thumb bmp. if you wanna get a rotated-thumb-bmp,
 *              you need to calculate the bmp-size after rotation and allocate the buf correctly
 *              otherwise the final bmp will be cropped.....
 *              The rotated-size calculation should be based on the pContentSize
 *              If the rotation angle is 0, it's very easy: the pContentSize is equal to the image-buf size
 */
+ (MRESULT) getBubbleThumbnailFromTemplate : (CXiaoYingEngine*)engine
                                    BGSize : (MSIZE*)pBGSize
                             bubbleTextSrc : (AMVE_BUBBLETEXT_SOURCE_TYPE*)pBubbleSrc
                               contentSize : (MSIZE*)pContentSize
                                  thumbBuf : (CVImageBufferRef)thumb /*out, used to put the bmp into*/
                                 timeStamp : (MDWord)dwTimeStamp;

/**
 * Judge whether funny effect template
 * @param templateID template id
 * @return return MTrue if funny effect template,else return MFalse
 */
+ (MBool) IsFunnyEffectTemplate : (MInt64) templateID;

/**
 * Judge whether face beauty effect template
 * @param templateID template id
 * @return return MTrue if face beautify post process template,else return MFalse
 */
+ (MBool) IsFBPostprocessTemplate : (MInt64) templateID;

/**
 * Judge whether preprocess effect template
 * @param templateID template id
 * @return return MTrue if face beautify pre process template,else return MFalse
 */
+ (MBool) IsFBPreprocessTemplate : (MInt64) templateID;

/**
 * Judge whether preprocess effect template
 * @param templateID template id
 * @return the sub_type of template. the sub_type is defined as CXY_XXX. Such as: CXY_IE_SUBTYPE_GRAFFITI
 */
+ (MDWord) GetTemplateSubType : (MInt64) templateID;

/**
 * Get effect property info
 *@param Xiaoying engine handle
 * @param templateID template id
 * @return return effect property info
 */
+ (CXYEffectpropertyInfo*) GetEffectPropertyInfo : (CXiaoYingEngine*) pEngine
                                      TemplateID : (MInt64) ltemplateID;


/**
 * Release effect property info
 * @param effect property info
 * @return Void
 */
+ (MVoid) ReleasePropertyInfo : (CXYEffectpropertyInfo*) pPropertyInfo;


//这两个接口一开始是用于主题的，后来适用于所有模板，但名字没改
- (MBool) IsFixedSizeTheme;

- (MDWord) GetThemeExportSize: (MSIZE *)pExportSize;

+ (NSArray<NSString *> * _Nullable) GetThemeDefaultMusicPaths:(CXiaoYingEngine*) pEngine
                            ThemePath:(NSString*) templateFile;

+ (MBool) GetBubbleIsAdujestAlpha:(CXiaoYingEngine*) pEngine ID:(MInt64)llTemplateID bgSize:(MSIZE)bgSize;//获取字幕是否可以调节alpha
@end // CXiaoYingStyle


