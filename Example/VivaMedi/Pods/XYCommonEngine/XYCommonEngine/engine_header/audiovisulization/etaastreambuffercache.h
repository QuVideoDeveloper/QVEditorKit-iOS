#ifndef ETAA_STREAM_BUFFER_CACHE_H
#define ETAA_STREAM_BUFFER_CACHE_H


class IMV2MediaInputStream;



/**
 *  CQVETAAStreamBufferCache
 *		是对audiostream的封装，隐藏复杂的stream逻辑，用于优化上层调用者的代码逻辑。
 */
class CQVETAAStreamBufferCache
{
public:
	CQVETAAStreamBufferCache();
	virtual ~CQVETAAStreamBufferCache();

	MRESULT Init(AA_SBC_INIT_PARAM *pInitParam);
	MVoid Uninit();


    /*
	 * Function:
	 *	 to get PCM data
	 * Param:
	 *    	[in] dwTimeStamp is the time pos you want
	 *		[out] pBuf is the buffer used to contain pcm
	 *		[in] dwBufRequired is buffer length
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT ReadPCM(MDWord dwTimeStamp, MByte *pBuf, MDWord dwBufRequired);//校验是否是整数个buffer

    /*
	 * Function:
	 *	 获取audio信息
	 * Param:
	 *    	[out] pAudioInfo audio信息
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */	
	MRESULT GetAudioInfo(MV2AUDIOINFO *pAudioInfo);

    /*
	 * Function:
	 *	 获取audio解码的时间范围
	 * Param:
	 *    	[out] pRange 时间范围
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT GetValidAudioRange(AMVE_POSITION_RANGE_TYPE *pRange); //after init() will return valid range


    /*
	 * Function:
	 *	 prepare pcm cache
	 * Param:
	 *    	[in] dwBufLen buffer length
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */	
	MRESULT PrepareCache(MDWord dwBufLen);//PrepareCache单独分出来，是因为外部设定的BufLen是要已经AudioInfo计算之后才能得出的，所以要外部单独调用

//	MBool IsStreamEnd(){return m_bStreamEnd;};

private:
	MBool IsRoundedBufLen4Samples(MV2AUDIOINFO *pAudioInfo, MDWord dwBufLen);
	MBool NeedUpdateCahce(MDWord dwRequireTimePos, MDWord dwBufRequired);
	MRESULT Try2UpdateCache(MDWord dwStartTime, MDWord dwMinBufRequired); //update 有可能满足不了需求，而不成功



private:
	IMV2MediaOutputStream 	*m_pAudioStream;
	QVET_BUFFER				m_Buffer;
	QVET_BUFFER				m_TryBuffer;
	MDWord					m_dwTotalBytesRead; //通过bytes累加的方式，收敛Bytes->TimeSpan的误差
	MV2AUDIOINFO			m_SrcAudioInfo;
	

	MTChar  m_szAudioFile[AMVE_MAXPATH];
	MBool	m_bRepeatAudio;
	AMVE_POSITION_RANGE_TYPE m_SrcAudioRange;
	MDWord  m_dwDstAudioLength;

	MDWord  m_dwCurTimePos;
	MDWord	m_dwTimeStep;//时间步进, 暂时没用
//	MBool	m_bStreamEnd;

	/*
		arcsoft aac dec处理A Happy & Wonderful Life.m4a这类aac audio有问题，第一帧解码会返回0x5009的错误----原因未知
		解决方法: 如果是aac audio file的话，stream read一次如果返回0x5009，则再read一次。
  	*/
	MBool	m_bAACSrc; 
};


#endif
