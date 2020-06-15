/*CXiaoYingUtils.h
*
*Reference:
*
*Description: Define XiaoYing Utils API.
*
*/

@interface CXiaoYingUtils : NSObject
{
			
}

/**
	 * Generates target svg file with input parameters.
	 * 
	 * @param svgFile Target svg file path.
	 * @param fontFile template file of font.
	 * @param bubbleFile template file of bubble.
	 * @param text text displayed in the bubble.
	 * @param dwBubbleColor color of the bubble.
	 * @param dwTextColor color of the text.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed
*/

//+ (MRESULT) generateSVGFile : (MTChar*) svgFile
//                   FontFile : (MTChar*) fontFile
//                 BubbleFile : (MTChar*) bubbleFile
//                       Text : (MWChar*)text
//                BubbleColor : (MDWord) dwBubbleColor
//                  TextColor : (MDWord) dwTextColor;




/**
	 * Generates target svg file from the bubble template
	 * @param layoutMode means which layout this template is used to. </br>
	 * 			it's LAYOUT_MODE_LANDSCAPE or LAYOUT_MODE_PORTRAIT
 */	

//+ (MRESULT) generateSVGFileFromTemplate : (MDWord) dwLayOutMode
//                                SVGFile : (MTChar*)dstSVGFile
//                               FontFile : (MTChar*)fontFile
//                     BubbleTemplateFile : (MTChar*)bubbleTemplateFile
//                                   Text : (MWChar*) text
//                            BubbleColor : (MDWord) dwBubbleColor
//                              TextColor : (MDWord) dwTextColor
//                              TextLines : (MDWord*)pTxtLine/*out*/;


//+ (MRESULT) getSVGOriginalSize : (MTChar*)pszSVGFile
//                          size : (MSIZE*)pSize;
/**
	 * Gets rgb32 data from input svg file and parameters.
	 * 
	 * @param pEngine Engine of video editor library.
	 * @param psvgImgBuf SVG image buffer.
	 * @param pBubbleSource Structure data of source svg.
	 * @param dwWidth Width of the thumbnail.
	 * @param dwHeight Height of the thumbnail.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed
*/

	                                      
//+ (MRESULT) getSVGThumbnail : (CXiaoYingEngine*)pEngine
//                SVGImageBuf : (CVImageBufferRef)psvgImgBuf
//           BubbleTextSource : (AMVE_BUBBLETEXT_SOURCE_TYPE*)pBubbleSource
//                      Width : (MDWord) dwWidth
//                     Height : (MDWord) dwHeight;


/**
* Gets rgb32 data from input svg file and parameters.
*
* @param pEngine Engine of video editor library.
* @param svgFile Target svg file path.
* @param psvgImgBuf SVG image buffer.
*
* @return MERR_NONE if the operation is successful, other value if failed
*/


//+ (MRESULT) getSVGThumbnail : (CXiaoYingEngine*)pEngine
//                    SVGFile : (MTChar*)szSVGFile
//                SVGImageBuf : (CVImageBufferRef)psvgImgBuf;

/**
	 * Checks if input file is editable.
	 *
	 * @param pEngine engine of video editor library.
	 * @param fileName The path of source file.
	 * @param flag one of CHECK_NO_AUDIO_TRACK,CHECK_VIDEO.
	 * 
	 * @return constants used to identify un-support reasons defined in amvedef.h
*/


+ (MDWord) isFileEditable : (CXiaoYingEngine*) pEngine
                 FileName : (MTChar*)fileName
                     Flag : (MDWord)flag;


/**
	 * Gets the information of a video file.
	 * 
	 * @param pEngine engine of video editor library.
	 * @param pSourceFile The path of source file.
	 * @param pVideoInfo,output param video info.
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/
+ (MRESULT) getVideoInfo : (CXiaoYingEngine*) pEngine
                FilePath : (MTChar*)pSourceFile
               VideoInfo : (AMVE_VIDEO_INFO_TYPE*)pVideoInfo;


+ (MRESULT) getVideoInfoEx : (CXiaoYingEngine*) pEngine
                  FilePath : (MTChar*)pSourceFile
                 VideoInfo : (AMVE_VIDEO_INFO_TYPE*)pVideoInfo
                   ExtInfo : (AMVE_SOURCE_EXT_INFO*)pExtInfo;
/*
 *  getCurSysTimeStamp:
 *      get the system timestamp since 1970.1.1
 */
+ (NSTimeInterval)getCurSysTimeStamp;


/*
 *  encapsulateXYBmp:
 *      this function is only available for RGB32 input/output
 */
+ (MRESULT)encapsulateXYBmp : (MBITMAP*)pOutBmp
                       from : (CVImageBufferRef)srcImgBuf;

/*
 * @param pdwRect is based on 1/100
 *
 */
+ (MRESULT) getResampleSizeAndRegion : (MDWord) dwSrcWidth
                                SrcH : (MDWord) dwSrcHeight
                                DstW : (MDWord*) pdwDstW
                                DstH : (MDWord*) pdwDstH
                     SrcRelativeRect : (MRECT*) pdwRect /*out*/
                        ResampleMode : (MDWord) dwResampleMode
                          UseFullSrc : (MBool) bUseFullSrc;

#define SRC_PICK_RECT   1
#define DST_PICK_RECT   2
+ (MRECT) calculatePickRect : (MSIZE)srcSize
                    dstSize : (MSIZE)dstSize
            src2dstRotation : (MDWord)rotation
                    fitMode : (MDWord)fitMode
              calculateType : (MDWord)calType;


+ (MRESULT) getFitSize : (MDWord) dwSrcWidth
                  SrcH : (MDWord) dwSrcHeight
                  DstW : (MDWord*) pdwDstW
                  DstH : (MDWord*) pdwDstH
          ResampleMode : (MDWord) dwResampleMode;

+ (MRESULT) GetAnimatedFrameInfo : (CXiaoYingEngine*) pEngine
					   FrameFile : (MTChar*) pFrameFile
					      BGSzie : (MSIZE*) pBGSize
					   FrameInfo : (QVET_ANIMATED_FRAME_TEMPLATE_INFO*) pInfo;

+ (MRESULT) GetAnimatedFrameBitmap : (CXiaoYingEngine*) pEngine
						 FrameFile : (MTChar*) pFrameFile
						  Position : (MDWord) dwPos
                            Bitmap : (CVImageBufferRef)image;//(MBITMAP*) pOutBmp;

+ (MDWord) GetProjectVersion : (MTChar*) pszFilePath;

+ (MDWord) GetStoryboardAveFps : (CXiaoYingStoryBoardSession*) pStoryboardSession;

/**
 *  Get the max fps in storyboard
 *@param pStoryboardSession,storybard session
 *@param dwMaxExpFPS,allowed max export fps
 *@return max fps
 **/
+ (UInt32) GetStoryboardMaxFps: (CXiaoYingStoryBoardSession*) pStoryboardSession
                    MaxExpFPS : (MDWord) dwMaxExpFPS;

/**
 *  CaculateVideoBitrate
 *  @param  dwFPS [in] fps of target video
 *  @param  dwWidth [in] width of target video
 *  @param  dwHeight  [in] height of target video
 *  @param  dwProfile [in] profile of target video
 *  @param dwBitrateMode [in] bitrate mode,low or high
 **/
+ (MDWord) CaculateVideoBitrate : (MDWord) dwFPS
                          Width : (MDWord) dwWidth
                         Height : (MDWord) dwHeight
                         Profile: (MDWord) dwProfile
                     BitrateMode: (MDWord) dwBitrateMode;

+ (UInt32) convertPosition : (UInt32) uiPosition
                 TimeScale : (Float32) fTimeScale
                converFlag : (Boolean) bToOriginal;


/**
 *  GetTemplateParamData
 *  @param  engine [in]
 *  @param  pszFile [in] template file
 *  @param  cfgIdx  [in] it's configuration index to indentify which effect configuration you want to choose
 *  @param  pResolution [in] the background graphic size which you apply this effect to
 *  @param  pData  [in, out] it's the template-parameter data got for you. If the target data is got, 
 *                 this API will allocate new memory for AMVE_USER_DATA_TYPE.pbyUserData, and don't forget to
 *                 free it when you never use it.
 *                 Before you sent the AMVE_USER_DATA_TYPE struct to this API, make sure that
 *                 you have free the old pbyUserData, otherwise there will be memory-leakage
 *
 **/
+ (MRESULT) GetTemplateParamData : (CXiaoYingEngine*) engine
                        Template : (MTChar*)pszFile
                       ConfigIdx : (MLong)cfgIdx
                      Resolution : (MSIZE*)pResolution
                          TP2Get : (AMVE_USER_DATA_TYPE*)pData;

/**
 *  ReleaseTASourceList
 *  @param  pSourceList [in] ta source list
 *  @param bFreeHandle [in] free handle flag
 **/
+ (MVoid) ReleaseTASourceList : (AMVE_TEXTANIMATION_SOURCE_LIST*) pSourceList
                   FreeHandle : (MBool)bFreeHandle;


+ (NSString*)getWMTagFrom : (NSString*)videoFile;


/**
 *  getAudioDeltaPitch
 *  @param  fTimeScale [in] time scale
 *  @return audio delta pitch calculated according to time scale
 *
 **/
+ (float) getAudioDeltaPitch : (float)fTimeScale;

/**
 *  check the background is pure color or not
 * @param cvImgBuf[in] img buf
 * @param pdwColor[in/out] if bg is pure color, save color message - color space:rgba
 * @param pPoint[in/out]
 * @return false - not pure color, true - pure color
*/
+ (MBool) IsPureBG : (CVImageBufferRef) cvImgBuf
           BGColor : (MDWord*) pdwColor
           BGPoint : (MPOINT*) pPoint
       BGColorType : (MInt8*) pcColorType;

@end // CXiaoYingUtils


