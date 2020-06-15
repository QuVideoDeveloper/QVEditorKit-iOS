/*
*CESImageUtils.h
*
*Reference:
*
*Description: Define some imaging utility APIs.
*
*/

#ifndef _CES_IMAGE_UTILS_H_
#define _CES_IMAGE_UTILS_H_


#ifdef __cplusplus
extern "C" {
#endif

#if defined(__IPHONE__)
typedef MVoid (^AssetsURLImageInfoProcessBlock)(LPMDIMGFILEINFO pImgInfo);
    
typedef MVoid (^AssetsURLImageLoadProcessBlock) (MHandle hCGImage,MDWord dwRotation);
#endif
    
MRESULT CESBitmapAlloc(MBITMAP *pBitmap);

MRESULT CESBitmapFree(MBITMAP *pBitmap);

MRESULT CESBitmapMerge( MBITMAP *pBitmap, MBITMAP *pBitmapFore, PMPOINT pPtForePos, 
                       MBITMAP *pBitmapMask, PMPOINT pPtMaskPos, MLong lOpacity);

MRESULT CESBitmapFillColor( MBITMAP *pBitmap,MCOLORREF clrFill, PMRECT prtFillRect,
                           MBITMAP *pMask, MLong lOpacity); 


MRESULT CESBitmapResample( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap );


MRESULT CESBitmapCrop( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap, MRECT *prtCrop );


MRESULT CESBitmapRotate( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap, MLong lDegree );


MRESULT CESBitmapFlip( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap, MDWord dwFlipMode );

//////////////////////////////////////////////////////////////////////////
MRESULT CESBitmapLoad( MHandle hFileStream, MDWord dwImgFormat, MBITMAP *pBitmap );


MRESULT CESBitmapLoad2( MVoid *pFile, MDWord dwImgFormat, MBITMAP *pBitmap );

MRESULT CESBitmapLoad3(MByte* pBuf,MDWord dwImgFormat,MDWord dwOffset,MDWord dwLength,MBITMAP *pBitmap);


MRESULT CESBitmapSave( MHandle hFileStream, MDWord dwImgFormat, MBITMAP *pBitmap );

MRESULT CESBitmapSave2( MVoid *pFile, MDWord dwImgFormat, MBITMAP *pBitmap );

MRESULT CESBitmapSave3(MByte* pBuf,MLong* plLength,MDWord dwImgFormat,MBITMAP* pBitmap);

MRESULT CESFileResize( MVoid *pInputFile, 
                     MLong lWidth, 
                     MLong lHeight, 
                     MDWord dwMaxFileSize, 
                     MVoid *pOutputFile);

MRESULT CESBitmapColorConvert( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap );

MRESULT CESBitmapCropRotFlipResample( MBITMAP *pSrcBitmap, MBITMAP *pDstBitmap, 
                                    MRECT *prtSrc, MRECT *prtDst,
                                    MLong lRotateDegree, MDWord dwFlipMode );

MRESULT CESBitmapLoadFast(MHandle hFileStream, MDWord dwImgFormat, MBITMAP* pBitmap);

MRESULT CESBitmapLoadFast2(MVoid *pFile, MDWord dwImgFormat, MBITMAP* pBitmap);

MHandle CESBitmapOpenInputFile(MVoid* pFile);

MVoid CESBitmapCloseInputFile(MHandle hStream);

MHandle CESBitmapOpenOutputFile(MVoid* pFile);

MVoid CESBitmapCloseOutputFile(MHandle hStream);

MHandle CESBitmapOpenInputStreamFromByteArray(MByte* pData,MDWord dwOffset,MDWord dwLength);

MRESULT CESGetImgFileInfo(MHandle hImgStream, LPMDIMGFILEINFO pImgInfo );
    
#if defined(__IPHONE__)
MRESULT CESGetImgFileInfoFromAssetURL(MVoid* pFile,AssetsURLImageInfoProcessBlock ImgInfoProcessBlock);
    
MRESULT CESGetImgFileInfoFromPhAsset(MVoid* pFile,LPMDIMGFILEINFO pImgInfo);
    
MRESULT CESBitmapLoadFromAssetURL(MVoid* pFile,AssetsURLImageLoadProcessBlock ImageLoadProcessBlock);
    
MRESULT CESBitmapLoadFromPhAsset(MVoid* pFile,MBITMAP* pBitmap);
    
MRESULT CESBitmapLoadFromCGImage(MHandle hCGImage,MDWord dwRotation,MBITMAP* pBitmap);
#endif


MRESULT CESGetJPGThumbnail(MVoid* pFile,MVoid **pThumbnail, MLong *pExifDataLen);

MRESULT CESExifGetIntInfo(MVoid* pFile,MDWord dwFieldID,MDWord* pdwValue);


#ifdef __cplusplus
}
#endif

#endif