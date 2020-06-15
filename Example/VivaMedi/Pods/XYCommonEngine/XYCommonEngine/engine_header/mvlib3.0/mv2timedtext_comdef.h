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

/*
 * MV2TimedText_Comdef.h
 *
 * Description:
 *
 *	The common used marco and structure for timed text in MVLIB2.0
 *
 *
 * Code History
 *    
 * --2005-1-31 Weigang Guan(wGuan@arcsoft.com.cn)
 *   initial version  
 *
 */


#ifndef _MV2TEXTCOMDEF_H_
#define _MV2TEXTCOMDEF_H_

#include "amcomdef.h"
#include "amstring.h"
#include "mv2config.h"
#include "mediafilecomdef.h"


//==================================================

//	config for timed text extend interface

//==================================================

/*=============================================
ID:
	MV2_CFG_PLAYER_TEXT_REGISTERCALLBACK
	
Descrpition:
	register timed text call back function for player

Value type:
	MV2PLAYERTEXTSOURCE * 

Note: 
================================================*/
#define MV2_CFG_PLAYER_TEXT_REGISTERCALLBACK	(MV2_CFG_PLAYER_BASE+6)	


/*=============================================
ID:
	MV2_CFG_PLAYER_TEXT_INFO
	
Descrpition:
	get timed text information

Value type:
	MV2TEXTINFO * 

Note: 
================================================*/
#define MV2_CFG_PLAYER_TEXT_INFO				(MV2_CFG_PLAYER_BASE+7)	


/*===================================================
ID:
	MV2_CFG_SPLITER_GETTEXTSOURCE
	
Description:
	 Get extend interface for spliter
Value type:
	COutPutTextSource ** ; 
Note:
    only for get 
 =====================================================*/
#define MV2_CFG_SPLITER_GETTEXTSOURCE			(MV2_CFG_MEDIAFILE_BASE + 100)


/*====================================================
ID:
	MV2_CFG_MUXER_GETTEXTSOURCE
	
Description:
	 Get extend interface for muxer
Value type:
	CInPutTextSource ** ; 
Note:
    only for get 
=======================================================*/
#define MV2_CFG_MUXER_GETTEXTSOURCE			(MV2_CFG_MEDIAFILE_BASE + 101)



/*===========================================================

   define text frame information for text extend interface

=============================================================*/

//for font type
#define MV2_FONT_UNKNOW              MEDIA_FONT_UNKNOW
#define MV2_FONT_SERIF               MEDIA_FONT_SERIF
#define MV2_FONT_SANS_SERIF			 MEDIA_FONT_SANS_SERIF
#define MV2_FONT_MONOSPACE			 MEDIA_FONT_MONOSPACE

//for language type(ISO639-2 code)
#define MV2_LANGUAGE_UNKNOW             MEDIA_LANGUAGE_UNKNOW
#define MV2_LANGUAGE_ENGLISH            MEDIA_LANGUAGE_ENGLISH
#define MV2_LANGUAGE_CHINESE            MEDIA_LANGUAGE_CHINESE
#define MV2_LANGUAGE_JAPANESE           MEDIA_LANGUAGE_JAPANESE

//for face style
#define MV2_FACE_STYLE_NONE				MEDIA_FACE_STYLE_NONE 
#define MV2_FACE_STYLE_BOLD				MEDIA_FACE_STYLE_BOLD
#define MV2_FACE_STYLE_ITALIC			MEDIA_FACE_STYLE_ITALIC    
#define MV2_FACE_STYLE_UNDERLINE		MEDIA_FACE_STYLE_UNDERLINE     

//for justification
typedef  Media_Type_JustifH  MV2_Type_JustifH;
typedef  Media_Type_JustifV  MV2_Type_JustifV;
//for scroll direction
typedef Media_Type_Scroll MV2_Type_Scroll;

typedef MEDIACOLOR MV2COLOR;

//for information attached to every text frame;
typedef  MEDIATFATTACHINFO     MV2TFATTACHINFO;
typedef  LPMEDIATFATTACHINFO   LPMV2TFATTACHINFO;

//the information for all text frames;
typedef  MEDIATEXTINFO     MV2TEXTINFO;
typedef  LPMEDIATEXTINFO   LPMV2TEXTINFO;

/*===========================================================

   define text frame information for text extend interface for player

=============================================================*/  

//player text callback data
typedef struct _tag_player_text_data {
	MTChar*				pTextBuf;				// the buffer of current text data,the chars are Unicode16
	MDWord				dwStartTime;            // the text start time
	MDWord				dwDuration;				// the text duration
	MV2_Type_JustifH	JustificationH;         // horizontal justification
	MV2_Type_JustifV	JustificationV;			// vertical justification
	MDWord				dwFaceStyle;            // face style		
	MDWord				dwFontSize;			    // font size
	MV2COLOR			FontColor;              // font color
	MV2COLOR			BKColor;                // background color
	MBool				bScrollIn;              // whether scroll in
	MBool				bScrollOut;             // whether scroll out
	MV2_Type_Scroll		SrollDirect;	        // scroll direction              
	MBool				bBlink;                 // whether blink   
}MV2PLAYERTEXTDATA, *LPMV2PLAYERTEXTDATA;

//player text callback funtion
typedef MVoid  (*PMV2PLAYERTEXTCALLBACK) ( LPMV2PLAYERTEXTDATA lpPlaybackData , MLong lUserData);

typedef struct _tag_player_text_source
{
	PMV2PLAYERTEXTCALLBACK  pTextCallback;
	MLong                   lUserData;

}MV2PLAYERTEXTSOURCE, *LPMV2PLAYERTEXTSOURCE;


#endif  //_MV2TEXTCOMDEF_H_