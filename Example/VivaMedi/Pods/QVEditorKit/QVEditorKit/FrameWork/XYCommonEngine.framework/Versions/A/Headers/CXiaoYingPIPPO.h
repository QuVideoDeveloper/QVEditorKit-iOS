

MRESULT QVET_DuplicatePIPSource(QVET_PIP_SOURCE *pSrc, QVET_PIP_SOURCE *pDst);
MVoid   QVET_ReleasePIPSource(QVET_PIP_SOURCE *pSrc, MBool bReleaseStruct);

#define	 PIP_ALIGNMENT_DEFAULT		0x00000000
#define	 PIP_ALIGNMENT_LEFT			0x00000001
#define	 PIP_ALIGNMENT_RIGHT		0x00000002
#define	 PIP_ALIGNMENT_TOP			0x00000004
#define	 PIP_ALIGNMENT_BOTTOM		0x00000008
#define	 PIP_ALIGNMENT_MIDDLE		0x00000010
#define	 PIP_ALIGNMENT_HOR_CENTER	0x00000020 
#define	 PIP_ALIGNMENT_VER_CENTER	0x00000040

@interface CXiaoYingPIPPO : NSObject
{
    
    
}



- (MRESULT) create : (id <CXiaoYingTemplateAdapter>) ta
        templateID : (MInt64)llTemplateID
        rotation   : (MDWord)dwRotation
       bgPixelSize : (MSIZE*)pBGSize;



- (MVoid) destroy;


- (MRESULT) getElementCount : (MDWord*)pdwCount;


- (MRESULT) getElementRegion : (MDWord)dwElementIdx
                 regionToGet : (MRECT*)pRegion;



- (MRESULT) getTemplateID : (MInt64*)pllTID;


- (MRESULT) setTemplateID : (MInt64)llTemplateID
              bgPixelSize : (MSIZE*)pBGSize;



- (MRESULT) getElementSrc : (MDWord)dwElementIdx
                 srcToGet : (QVET_PIP_SOURCE*) pSrc;


- (MRESULT) setElementSrc : (MDWord)dwElementIdx
                srcToSet : (QVET_PIP_SOURCE*) pSrc;


- (MRESULT) getElementIdxByPoint : (MPOINT*)pPoint
                        idxToGet : (MDWord*)pdwIdx;

- (MRESULT) getElementTipsLocation : (MDWord)dwElementIdx
						  location : (MPOINT*)pPoint;

- (MRESULT) getElementSourceAlignment : (MDWord)dwElementIdx
							alignment :	(MDWord*)pdwAlignment;

- (CXiaoYingPIPPO*) duplicate;
/*
 * app had better not call getHandle()
 */
- (MHandle) getHandle;
@end // CXiaoYingPIPPO