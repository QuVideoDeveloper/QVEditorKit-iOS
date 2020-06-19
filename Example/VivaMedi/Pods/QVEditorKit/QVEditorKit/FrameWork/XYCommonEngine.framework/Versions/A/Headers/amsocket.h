/*----------------------------------------------------------------------------------------------
*
* This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary and 		
* confidential information. 
* 
* The information and code contained in this file is only for authorized ArcSoft employees 
* to design, create, modify, or review.
* 
* DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
* 
* If you are not an intended recipient of this file, you must not copy, distribute, modify, 
* or take any action in reliance on it. 
* 
* If you have received this file in error, please immediately notify ArcSoft and 
* permanently delete the original and any copy of any file and any printout thereof.
*
*-------------------------------------------------------------------------------------------------*/

#ifndef __AMSOCKET_H__
#define __AMSOCKET_H__

#include "amcomdef.h"
#include "merror.h"

typedef enum {
	MSOCKET_TCP,
	MSOCKET_UDP
}MSOCKETTYPE;

#define		MSOCKET_TCP		0
#define		MSOCKET_UDP		1

#define		MSOCKET_IPTYPE_V4	0
#define		MSOCKET_IPTYPE_V6	1


typedef enum {
	MSOCKET_NOTCONNECTED,
	MSOCKET_BINDING,
	MSOCKET_BINDED,
	MSOCKET_CONNECTING,
	MSOCKET_CONNECTED,
	MSOCKET_LOOKINGUP,
	MSOCKET_DISCONNECTED,
	MSOCKET_SENDING,
	MSOCKET_RECVING
}MSOCKETSTATE;

#define		MSOCKET_NOTCONNECTED	0
#define		MSOCKET_BINDING			1
#define		MSOCKET_BINDED			2
#define		MSOCKET_CONNECTING		3
#define		MSOCKET_CONNECTED		4
#define		MSOCKET_LOOKINGUP		5
#define		MSOCKET_DISCONNECTED	6
#define		MSOCKET_SENDING			7
#define		MSOCKET_RECVING			8

typedef enum {
	MSOCKET_OPTION_CONNECT_TIMEOUT,
	MSOCKET_OPTION_SEND_RECV_TIMEOUT
}MSOCKETOPTION;

#define		MSOCKET_OPTION_CONNECT_TIMEOUT		0
#define		MSOCKET_OPTION_SEND_RECV_TIMEOUT	1			


#define		MHTTP_GET_METHOD	0
#define		MHTTP_POST_METHOD	1
#define		MHTTP_PUT_METHOD	2
#define		MHTTP_DELETE_METHOD 3

#define		MHTTP_STATUS_INIT				0
#define		MHTTP_STATUS_CONNECTING			1
#define		MHTTP_STATUS_CONNECTED			2
#define		MHTTP_STATUS_RECVING			3
#define		MHTTP_STATUS_FINISHED			4
#define		MHTTP_STATUS_ERROR				5
#define		MHTTP_STATUS_SENDING			6

typedef enum{
	MHTTP_OPTION_BUFFERED_SIZE,
	MHTTP_OPTION_CONNECT_TIMEOUT,
	MHTTP_OPTION_SEND_RECV_TIMEOUT,
	MHTTP_OPTION_ASYNC,
	MHTTP_OPTION_CACHE_FILE
}MHTTPOPTION;

#define		MHTTP_OPTION_BUFFERED_SIZE		0
#define		MHTTP_OPTION_CONNECT_TIMEOUT	1
#define		MHTTP_OPTION_SEND_RECV_TIMEOUT	2	
#define		MHTTP_OPTION_ASYNC				3
#define		MHTTP_OPTION_CACHE_FILE			4
#define		MHTTP_OPTION_USERNAME			5
#define		MHTTP_OPTION_PASSWORD			6
#define		MHTTP_OPTION_PROXY_USERNAME		7
#define		MHTTP_OPTION_PROXY_PASSWORD		8
#define		MHTTP_OPTION_PROXY_DOMAIN		9



#define		MSOCKET_AF_INET					0
#define		MSOCKET_AF_INET6				1

#define		MSOCKET_ADDR_SIZE				32


typedef struct __tag_socket_addr{
	MWord	wFamily;
	MChar	szAddrData[MSOCKET_ADDR_SIZE-2];
}MSOCKETADDR;

typedef	struct __tag_in4_addr{
	MDWord	dw;
}MIN4_ADDR;

typedef	struct __tag_in6_addr{
	MWord	w[8];
}MIN6_ADDR;

typedef struct __tag_socket_addr4{
	MWord		wFamily;
	MWord		wPort;
	MIN4_ADDR	sAddr;
	MChar		szReserved[MSOCKET_ADDR_SIZE-8];
}MSOCKET_ADDR4;

typedef struct __tag_socket_addr6{
	MWord		wFamily;
	MWord		wPort;
	MIN6_ADDR	sAddr;
	MChar		szReserved[MSOCKET_ADDR_SIZE-20];
}MSOCKET_ADDR6;


typedef struct __tag_socket_addrinfo{
	MSOCKETADDR						addr;
	struct __tag_socket_addrinfo*	pNext;
}MSOCKETADDRINFO;

	

#define SE_IS_MCASTADDR(x)	(((x)&0xF0000000) == 0xE0000000)

#define RTP_MCASTMEMBERSHIP(socket,type,mcastip,status)	{\
					struct ip_mreq mreq;\
					mreq.imr_multiaddr.s_addr = htonl(mcastip);\
					mreq.imr_interface.s_addr = htonl(m_dwLocalIp);\
					status = setsockopt(socket,IPPROTO_IP,type,(const MChar *)&mreq,sizeof(struct ip_mreq));\
			}




#ifdef __cplusplus
extern "C" {
#endif


/*********************************************************************************
**********************************************************************************
*******************************The socket APIs************************************
**********************************************************************************
**********************************************************************************/

MRESULT	MSocketInit();
MVoid	MSocketFree();

typedef MVoid (*MSOCKETCALLBACK)(MVoid* pUserData, MDWord dwState, MRESULT dwErrorCode);

MRESULT MSocket2Create(MHandle* phSocket, MDWord dwSocketType, MLong lInBufferSize, 
		MLong lOutBufferSize, MSOCKETCALLBACK pfnSocketCB, MVoid* pUserData);

MRESULT MSocket2Close(MHandle hSocket);

MRESULT	MSocket2Connect(MHandle hSocket, MSOCKETADDR* pAddr);

MRESULT	MSocket2Bind(MHandle hSocket, MSOCKETADDR* pAddr);

MRESULT	MSocket2Listen(MHandle hSocket);

typedef MVoid* (*MSOCKET2ACCEPTCALLBACK)(MVoid* pUserData, MHandle hNewSocket, const MSOCKETADDR* pAddr);

MRESULT	MSocket2Accept(MHandle hSocket, MSOCKET2ACCEPTCALLBACK pfnAcceptCB, MVoid* pUserData);

MRESULT MSocket2Send(MHandle hSocket, MByte* pData, MLong* plDataLen);
	
MRESULT	MSocket2Recv(MHandle hSocket, MByte* pBuffer, MLong* plBufferLen, MLong lMinLen);

MRESULT MSocket2SendTo(MHandle hSocket,  MByte* pData, MLong* plDataLen, MSOCKETADDR* pAddr);

MRESULT	MSocket2RecvFrom(MHandle hSocket, MByte* pBuffer, MLong* plBufferLen, MSOCKETADDR* pAddr);

MRESULT MSocket2OnIdle(MHandle hSocket);

MRESULT MSocket2GetBufferedLength(MHandle hSocket, MLong* plInLen, MLong* plOutLen);

MRESULT	MSocket2SetOption(MHandle hSocket, MDWord dwOption, MDWord dwValue);

MRESULT	MSocket2UtilGetLocalIP(MWord wFamily, MSOCKETADDRINFO** ppAddrInfo);

MRESULT MSocket2UtilFreeAddrInfo(MSOCKETADDRINFO* pAddrInfo);

MVoid	MSocketUtilGetHostName(MChar* szHostName, MLong lNameLen);

MVoid	MSocketUtilGetUserName(MChar* szUserName, MLong lNameLen);

MRESULT	MSocketUtilInetPtoN(const MChar* szAddr, MWord wFamily, MSOCKETADDR* pAddr);
MRESULT	MSocketUtilInetNtoP(const MSOCKETADDR* pAddr, MChar* szAddr, MDWord dwSzLen);

MDWord	MSocketUtilNtoHL(MDWord dwNetLong);
MWord	MSocketUtilNtoHS(MWord dwNetShort);
MDWord	MSocketUtilHtoNL(MDWord dwHostLong);
MWord	MSocketUtilHtoNS(MWord dwHostShort);


typedef struct __tag_domain2IP
{
	MChar*		szdomain;
	MDWord		dwAddr[4];
}MSOCKETDOMAIN2IP, *LPMSOCKETDOMAIN2IP;

typedef MRESULT (*MSOCKETDNSRESOLVECALLBACK)(LPMSOCKETDOMAIN2IP pDomain2IP, MVoid* pUserData);

MRESULT MSocketUtilResolveCreate(MHandle* hResolver, MDWord dwIPType, MSOCKETDNSRESOLVECALLBACK pfnDNSResolveCB, MVoid* pUserData);

MRESULT MSocketUtilResolveHostName(MHandle hResolver, const MChar* szDomain);

MRESULT MSocketUtilResolveDestroy(MHandle hResolver);



/*********************************************************************************
**********************************************************************************
*******************************The http APIs**************************************
**********************************************************************************
**********************************************************************************/
#ifdef		M_WIDE_CHAR 
	#define	MHTTPStreamOpen				MHTTPStreamOpenW
	#define	MHTTPStreamOpenViaProxy		MHTTPStreamOpenViaProxyW
	#define MHTTPStreamAddHeader		MHTTPStreamAddHeaderW
	#define MHTTPStreamGetHeader		MHTTPStreamGetHeaderW
#else
	#define	MHTTPStreamOpen				MHTTPStreamOpenS
	#define	MHTTPStreamOpenViaProxy		MHTTPStreamOpenViaProxyS
	#define MHTTPStreamAddHeader		MHTTPStreamAddHeaderS
	#define MHTTPStreamGetHeader		MHTTPStreamGetHeaderS
#endif


typedef struct __tag_callback_data{
	MDWord	dwTotalSize;  
	MDWord	dwDownloadSize;
	MDWord	dwBufferPercent;
	MDWord	dwStatus;
	MDWord	dwBitrate;
	MRESULT	nLastErr;
}MHTTPCALLBACKDATA, *LPMHTTPCALLBACKDATA;

typedef MVoid (*MPFHTTPCALLBACK) (LPMHTTPCALLBACKDATA pCallbackData, MLong lUserData);

typedef struct	_tag_AsyncPara{
	MLong		lUserData;  
	MPFHTTPCALLBACK	pfCallback;
}MASYNCHTTPPARA, *LPMASYNCHTTPPARA;	

MHandle	MHTTPStreamOpenS(const MChar* szURL,MDWord dwMethod);

MHandle	MHTTPStreamOpenW(const MWChar* szURL,MDWord dwMethod);

MHandle	MHTTPStreamOpenViaProxyS(const MChar* szURL, MDWord dwMethod, MChar* szProxy);

MHandle	MHTTPStreamOpenViaProxyW(const MWChar* szURL, MDWord dwMethod, MWChar* szProxy);

MBool	MHTTPStreamClose(MHandle hHTTPStream);

MBool	MHTTPStreamConnect(MHandle  hHTTPStream);

MLong	MHTTPStreamGetSize(MHandle hHTTPStream);

MRESULT	MHTTPStreamRead(MHandle hHTTPStream, MVoid* pBuffer, MLong* lSize);

MRESULT	MHTTPStreamWrite(MHandle hHTTPStream, MVoid* pBuffer, MLong* lSize);

MRESULT MHTTPStreamReset(MHandle hHTTPStream);

MRESULT MHTTPStreamSeek(MHandle hHTTPStream, MDWord	dwStart, MLong lOffset);

MRESULT	MHTTPStreamQueryStatus(MHandle hHTTPStream, MDWord* pdwStatus, MVoid* pParam1, MVoid* pParam2);

MRESULT	MHTTPStreamSetOption(MHandle hHTTPStream, MDWord dwOption, MVoid* pValue);

MRESULT	MHTTPStreamAddHeaderS(MHandle hHTTPStream, MChar* pHeader);

MRESULT	MHTTPStreamAddHeaderW(MHandle hHTTPStream, MWChar* pHeader);

MRESULT	MHTTPStreamGetHeaderS(MHandle hHTTPStream, MChar* pHeader, MLong* plSize);

MRESULT	MHTTPStreamGetHeaderW(MHandle hHTTPStream, MWChar* pHeader, MLong* plSize);

MLong	MHTTPStreamGetStatusCode(MHandle hHTTPStream);











































































/*********************************************************************************
**********************************************************************************
**************Removed following functions which have been deprecated**************
**********************************************************************************
**********************************************************************************/



MRESULT MSocketCreate(MHandle* phSocket, MChar* szDstAddress, MWord wDstPort, MDWord socketType,
	MLong lInBufferSize, MLong lOutBufferSize, MSOCKETCALLBACK pfnSocketCB, MVoid* pUserData);
MRESULT MSocketCreateEx(MHandle* phSocket, MDWord socketType, MLong lInBufferSize, 
		MLong lOutBufferSize, MSOCKETCALLBACK pfnSocketCB, MVoid* pUserData);
MRESULT MSocketClose(MHandle hSocket);
MRESULT	MSocketConnect(MHandle hSocket);
MRESULT	MSocketConnectEx(MHandle hSocket, MChar* szDstAddress, MWord wDstPort);
MRESULT	MSocketBind(MHandle hSocket, MChar* szDstAddress, MWord wDstPort);
MRESULT	MSocketListen(MHandle hSocket);
typedef MVoid* (*MSOCKETACCEPTCALLBACK)(MVoid* pUserData, MHandle hNewSocket, MChar* szDstAddress, MWord wDstPort);
MRESULT	MSocketAccept(MHandle hSocket, MSOCKETACCEPTCALLBACK pfnAcceptCB, MVoid* pUserData);
MRESULT MSocketSend(MHandle hSocket, MByte* pData, MLong lDataLen);	
MLong	MSocketRecv(MHandle hSocket, MByte* pBuffer, MLong lBufferLen, MLong lMinLen);
MRESULT MSocketSendTo(MHandle hSocket,  MByte* pData, MLong lDataLen, MDWord dwDstAddress, MWord wDstPort);
MRESULT	MSocketSendTo2(MHandle hSocket, MByte* pData, MLong lDataLen, MChar* szDstAddress, MWord wDstPort);
MLong	MSocketRecvFrom(MHandle hSocket, MByte* pBuffer, MLong lBufferLen, MDWord* dwDstAddress, MWord* wDstPort);
MLong	MSocketRecvFrom2(MHandle hSocket, MByte* pBuffer, MLong lBufferLen, MChar* szDstAddress,  MLong lDstBufferLen, MWord* wDstPort);
MRESULT	MSocketMulticastMgr(MHandle hSocket, MDWord dwDstAddress, MBool bAdd);
MRESULT	MSocketMulticastMgr2(MHandle hSocket, MChar* szAddress, MBool bAdd);
MRESULT MSocketGetBufferedLength(MHandle hSocket, MLong* plInLen, MLong* plOutLen);
MRESULT	MSocketSetOption(MHandle hSocket, MDWord dwOption, MDWord dwValue);
MDWord	MSocketUtilGetLocalIP();
MDWord	MSocketUtilIPStrToDWord(MChar* szIP);
MVoid	MSocketUtilDWordToIPStr(MLong dwIP, MChar* szIP, MLong len);
MRESULT MSocketOnIdle(MHandle hSocket);


#ifdef __cplusplus
}
#endif

#endif

