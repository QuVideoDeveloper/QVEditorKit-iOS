#ifndef FFMPEG_SWSCALE_
#define FFMPEG_SWSCALE_
#include <stdint.h>
#include "amcomdef.h"
extern "C" {
#include "libavutil/opt.h"
}

#define MAX_FFMPEG_SCALE_DIM	4



class FFMPEGSwScale 
{
public:
	FFMPEGSwScale();
	~FFMPEGSwScale();
	MRESULT Init(ScaleVideoInof  *pSwScaleInfo);
	MRESULT SwScale(MByte	*pBuffer);
	
	static enum AVPixelFormat MapColorSpaceToAVPixelFormat(MDWord dwColrSpace);
	static MDWord MapAVPixelFormatToColorSpace(enum AVPixelFormat avPixFmt);

protected:
	ScaleVideoInof  m_ScaleVideoInfo;

	int						m_dwInputScalelinesize[MAX_FFMPEG_SCALE_DIM];
	MByte					*m_pInputScaleBuf[MAX_FFMPEG_SCALE_DIM];

	int						m_dwOutputScalelinesize[MAX_FFMPEG_SCALE_DIM];
	MByte					*m_pOutputScaleBuf[MAX_FFMPEG_SCALE_DIM];

	struct SwsContext		*m_pImgConvertCtx;
	enum AVPixelFormat		m_inScalePixelFormat;
	enum AVPixelFormat 		m_outScalePixelFormat;
	MDWord					m_outScalePixelSize;

	

};

#endif
