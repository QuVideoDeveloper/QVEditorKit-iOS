/*CXiaoYingStream.h
*
*Reference:
*
*Description: Define XiaoYing stream  API.
*
*/




@interface CXiaoYingStream : NSObject
{
		
}

@property (readonly, nonatomic) MHandle hStream;
/**
 * Opens a stream. 
 * 
 * @param pSource,include source type,clip manager handle and storyboard session handle
 * @param pParam,include frame widht,height and start,end position
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) Open : (AMVE_STREAM_SOURCE_TYPE*) pSource
     StreamParam : (AMVE_STREAM_PARAM_TYPE*) pParam;

/**
 * Closes the stream.
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) Close;	    

- (MRESULT) SetBGColor : (MDWord) dwBGColor;

- (MDWord) GetBGColor;           

@end // CXiaoYingStream


