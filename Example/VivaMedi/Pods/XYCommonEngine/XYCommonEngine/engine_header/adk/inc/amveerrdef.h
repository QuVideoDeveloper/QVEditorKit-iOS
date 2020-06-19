/*
 * amveerrdef.h
 *
 * This file has defined error macro for the interface function of video editor engine 
 * 
 *
 * History
 * 
 *
 */

#ifndef _AMVEERRDEF_H_
#define _AMVEERRDEF_H_

#include "merror.h"

#define QVET_ERR_NONE				0

#define QVET_ERR_INTERNAL_MASK      0x10000000 // mask for internal error

/*
*	类名段:
*	错误段:
*/

#define QVET_ERR_BASE               0x00800000//MERR_LIBRARY_BASE

/*
*	以下是针对session core里每个cpp的err 分段
*/
//[0x00800000, 0x00801000)
#define QVET_ERR_TRANS_TRACK_BASE 	(QVET_ERR_BASE)				//ettransitiontrack.cpp  					0x00800000
#define QVET_ERR_TRANS_SLDOS_BASE	(QVET_ERR_BASE+0x00000100)	//ettransitionslideoutputstream.cpp			0x00800100
#define QVET_ERR_ATSPARSER_BASE		(QVET_ERR_BASE+0x00000200)	//etalphatransitionstyleparse.cpp  			0x00800200
#define QVET_ERR_TRANS_AMOS_BASE	(QVET_ERR_BASE+0x00000300)	//ettransitionanimatedmaskoutputstream.cpp  0x00800300
#define QVET_ERR_CVTT_BASE			(QVET_ERR_BASE+0x00000400)	//etcombovideotransitiontrack.cpp			0x00800400
#define QVET_ERR_CVTRANSOS_BASE		(QVET_ERR_BASE+0x00000500)	//etcombovideotransitionoutputstream.cpp	0x00800500
#define QVET_ERR_TRANS_DM_BASE		(QVET_ERR_BASE+0x00000600)	//ettransitiondatamgr.cpp					0x00800600
#define QVET_ERR_TRANS_BOS_BASE	    (QVET_ERR_BASE+0x00000700)	//ettransitionbaseoutputstream.cpp			0x00800700
#define QVET_ERR_TRANS_SFOS_BASE	(QVET_ERR_BASE+0x00000800)	//ettransitionsingleframeoutputstream.cpp	0x00800800
#define QVET_ERR_TRANS_BDOS_BASE	(QVET_ERR_BASE+0x00000900)	//ettransitionBlendoutputstream.cpp			0x00800900
#define QVET_ERR_FACEDTUTIL_BASE    (QVET_ERR_BASE+0x00000A00)  //etfacedtutils.cpp							0x00800A00
#define QVET_ERR_QEIDWEBP_BASE		(QVET_ERR_BASE+0x00000B00)  //qeidwebp.cpp								0x00800B00
#define QVET_ERR_IEFWR_BASE			(QVET_ERR_BASE+0x00000C00)  //etieframewebpreader.cpp					0x00800C00
#define QVET_ERR_WEBPTRACK_BASE		(QVET_ERR_BASE+0x00000D00)  //vewebptrack.cpp							0x00800D00
#define QVET_ERR_WEBPOS_BASE		(QVET_ERR_BASE+0x00000E00)  //etwebpoutputstream.cpp					0x00800E00
#define QVET_ERR_BIOPS_BASE			(QVET_ERR_BASE+0x00000F00)	//etblackimageoutputstream.cpp  			0x00800F00

//[0x00801000, 0x00802000)
#define QVET_ERR_POSTER_BASE		(QVET_ERR_BASE+0x00001000)	//etposter.cpp								0x00801000
#define QVET_ERR_PADAPTER_BASE		(QVET_ERR_BASE+0x00001100)	//etposteradpater		   					0x00801100
#define QVET_ERR_PTHREAD_BASE		(QVET_ERR_BASE+0x00001200)	//etposterthread.cpp   						0x00801200
#define QVET_ERR_PXMLP_BASE			(QVET_ERR_BASE+0x00001300)	//etposterxmlparser.cpp   					0x00801300
#define QVET_ERR_FFRAME_PARSER_BASE (QVET_ERR_BASE+0x00001400)  //vefreezeframesettingparser.cpp                                0x00801400
#define QVET_ERR_FREEZE_FRAME_BASE  (QVET_ERR_BASE+0x00001500)  //vefreezeframe.cpp                                                  0x00801500
#define QVET_ERR_FFRAME_STREAM_BASE (QVET_ERR_BASE+0x00001600)  //etfreezeframevideooutputstream.cpp                       0x00801600
#define QVET_ERR_OT_UTILS_BASE      (QVET_ERR_BASE+0x00001700)  //etobjecttracking.cpp                                              0x00801700
#define QVET_ERR_LYRIC_PARSER_BASE  (QVET_ERR_BASE+0x00001800)  //etlyricparser.cpp                                                    0x00801800
#define QVET_ERR_LRC_ST_PARSER_BASE (QVET_ERR_BASE+0x00001900)  //velyricstyleparser.cpp                                             0x00801900
#define QVET_ERR_LRCCOM_EFTTCK_BASE (QVET_ERR_BASE+0x00001A00)  //etlyriccomboeffecttrack.cpp                                   0x00801A00
#define QVET_ERR_DIVA_COMB_FFRAME_TRACK_BASE  (QVET_ERR_BASE+0x00001B00) //etdivacombofreezeframevideotrack.cpp             0x00801B00
#define QVET_ERR_DIVA_COMB_FFRAME_STREAM_BASE (QVET_ERR_BASE+0x00001C00) //etdivacombofreezeframevideooutputstream.cpp 0x00001C00
#define QVET_ERR_QEIF_ITX_READER_BASE		  (QVET_ERR_BASE+0x00001D00) // qeifitxreader.cpp							0x00801D00
#define QVET_ERR_IEFR_ITX_BASE				  (QVET_ERR_BASE+0x00001E00) // etieframeitxreader.cpp						0x00801E00
#define QVET_ERR_AUDIO_PROVIDER_BASE          (QVET_ERR_BASE+0x00001F00) //veaudioprovider.cpp                                              0x00801F00
//[0x00802000, 0x00803000)
#define QVET_ERR_VGFD_PARSER_BASE	(QVET_ERR_BASE+0x00002000)	//vevgframedescparser.cpp					0x00802000
#define QVET_ERR_VG2DOS_BASE		(QVET_ERR_BASE+0x00002100)	//etvg2doutputstream.cpp					0x00802100
#define QVET_ERR_AP_THREAD_BASE     (QVET_ERR_BASE+0x00002200)  //veaudioproviderthread.cpp                              0x00802200
#define QVET_ERR_AP_SESSION_BASE    (QVET_ERR_BASE+0X00002300)  //veaudioprovidersession.cpp                             0x00802300
#define QVET_ERR_AP_ENGINE_BASE     (QVET_ERR_BASE+0X00002400)  //veaudioproviderengine.cpp                              0x00802400
#define QVET_ERR_AP_NATIVE_BASE     (QVET_ERR_BASE+0X00002500)  //veaudioprovidernative.cpp                               0x00802500
#define QVET_ERR_RAW_VIDEO_OPS_BASE	     (QVET_ERR_BASE+0X00002600)  //verawvideooutputstream.cpp    0x00802600	
#define QVET_ERR_RAW_VIDEO_TRACK_BASE     (QVET_ERR_BASE+0X00002700)  //verawtrack.cpp    0x00802700	
#define QVET_ERR_COMB_VIDEO_IE_BASE (QVET_ERR_BASE+0X00002800) //vecombovideoie.cpp
#define QVET_ERR_COMBO_IE_STYLE_BASE (QVET_ERR_BASE+0X00002900) //vecomboiestyleparser.cpp
//[0x00803000, 0x00804000)
#define QVET_ERR_COMBO_IE_OUT_STREAM_BASE (QVET_ERR_BASE+0X00003000) //etcombovideoieoutputstream.cpp
//0x00803100
#define QVET_ERR_ANITEXTUITLS_BASE		  (QVET_ERR_BASE+0x00003100) //etanimationtextutils
//0x00803200
#define QVET_ERR_SUBSTREAM_FACTORY_BASE	  (QVET_ERR_BASE+0x00003200) //etsubeffectstreamfactory.cpp
//0x00803300
#define QVET_ERR_AUDIOANA_NATIVE_BASE     (QVET_ERR_BASE+0x00003300)  //veaudioanalyzenative.cpp
//0x00803400
#define QVET_ERR_KEY_LINE_PARSER     (QVET_ERR_BASE+0x00003400)  //vekeylineparser.cpp
//0x00803500
#define QVET_ERR_KEY_LINE_MGR		 (QVET_ERR_BASE+0x00003500)  //vekeylinemgr.cpp
//0x00803600
#define QVET_ERR_KEY_LINE_STYLE_PARSER     (QVET_ERR_BASE+0x00003600)  //vekeylinestyleparser.cpp
#define QVET_ERR_SEGMENT_UTILS_BASE   (QVET_ERR_BASE+0x00003700)       //etsegmentutils

//0x00803800
//0x00803900
//0x00803A00
//0x00803B00
//0x00803C00
//0x00803D00
//0x00803E00
//0x00803F00
//[0x00804000, 0x00805000)
//
//
#define QVET_ERR_EFOS_BASE			(QVET_ERR_BASE+0x00005000)	//eteffectoutputstream.cpp   				0x00805000
#define QVET_ERR_ECFGPS_BASE		(QVET_ERR_BASE+0x00006000)	//etechocfgparser.cpp   					0x00806000
#define QVET_ERR_MIFOS_BASE			(QVET_ERR_BASE+0x00007000)	//etmutliinputfilteroutputstream.cpp   		0x00807000
#define QVET_ERR_RFOS_BASE			(QVET_ERR_BASE+0x00008000)	//etrenderfilteroutputstream.cpp   			0x00808000
#define QVET_ERR_IEAM_BASE			(QVET_ERR_BASE+0x00009000)	//etieanimatemove.cpp   					0x00809000
#define QVET_ERR_EFTPS_BASE			(QVET_ERR_BASE+0x0000A000)	//eteffectprocessor.cpp   					0x0080A000
#define QVET_ERR_IEFDP_BASE			(QVET_ERR_BASE+0x0000B000)	//etieframedataprovider.cpp   				0x0080B000
#define QVET_ERR_IEFDR_BASE			(QVET_ERR_BASE+0x0000C000)	//etieframedatareader.cpp   				0x0080C000
#define QVET_ERR_IEFIR_BASE			(QVET_ERR_BASE+0x0000D000)	//etieframeimagereader.cpp   				0x0080D000
#define QVET_ERR_IEFMR_BASE			(QVET_ERR_BASE+0x0000E000)	//etieframemporeader.cpp   		0x0080E000
#define QVET_ERR_SCDP_BASE			(QVET_ERR_BASE+0x0000F000)	//etscenedataprovider.cpp   	0x0080F000
#define QVET_ERR_IEFR_BASE			(QVET_ERR_BASE+0x00010000)	//etieframereader.cpp   		0x00810000
#define QVET_ERR_IEFSR_BASE			(QVET_ERR_BASE+0x00011000)	//etieframesvgreader.cpp   		0x00811000
#define QVET_ERR_DATA_THREAD_BASE	(QVET_ERR_BASE+0x00012000)	//etdatapreparethread.cpp   	0x00812000
#define QVET_ERR_IEFVR_BASE			(QVET_ERR_BASE+0x00013000)	//etieframevideoreader.cpp   	0x00813000
#define QVET_ERR_MR_BASE			(QVET_ERR_BASE+0x00014000)	//etmporeader.cpp   			0x00814000
#define QVET_ERR_OSCM_BASE			(QVET_ERR_BASE+0x00015000)	//etoptsplittercachemgr.cpp   	0x00815000
#define QVET_ERR_AMUT_BASE			(QVET_ERR_BASE+0x00016000)	//etieanimatemoveutils.cpp   	0x00816000
#define QVET_ERR_PPARSER_BASE		(QVET_ERR_BASE+0x00017000)	//etpkgparser.cpp   			0x00817000
#define QVET_ERR_LZ4_BASE           (QVET_ERR_BASE+0x00018000)  //etCompressLz4Interface.cpp    //0x00018000
//0x00019000
//0x0001A000
//0x0001B000
#define QVET_ERR_IEFTR_BASE			(QVET_ERR_BASE+0x0001C000)	//etieframetrackreader.cpp   	0x0081C000
#define QVET_ERR_AEE_BASE			(QVET_ERR_BASE+0x0001D000)	//veaudioeditorengine.cpp   	0x0081D000
#define QVET_ERR_AFRAME_BASE		(QVET_ERR_BASE+0x0001E000)	//veaudioframe.cpp				0x0081E000
#define QVET_ERR_AFOPS_BASE			(QVET_ERR_BASE+0x0001F000)	//veaudioframeoutputstream.cpp  0x0081F000   
#define QVET_ERR_AFTRACK_BASE		(QVET_ERR_BASE+0x00020000)	//veaudioframetrack.cpp   		0x00820000
#define QVET_ERR_AMOPS_BASE			(QVET_ERR_BASE+0x00021000)	//veaudiomuteoutputstream.cpp   0x00821000
#define QVET_ERR_AMTRACK_BASE		(QVET_ERR_BASE+0x00022000)	//veaudiomutetrack.cpp   		0x00822000
#define QVET_ERR_AOPS_BASE			(QVET_ERR_BASE+0x00023000)	//veaudiooutputstream.cpp   	0x00823000
#define QVET_ERR_ATRACK_BASE		(QVET_ERR_BASE+0x00024000)	//veaudiotrack.cpp   			0x00824000
#define QVET_ERR_BAOPS_BASE			(QVET_ERR_BASE+0x00025000)	//vebaseaudiooutputstream.cpp   0x00825000
#define QVET_ERR_BCLIP_BASE			(QVET_ERR_BASE+0x00026000)	//vebaseclip.cpp   			0x00826000
#define QVET_ERR_BDCM_BASE			(QVET_ERR_BASE+0x00027000)	//vebasedatacachemgr.cpp   	0x00827000
#define QVET_ERR_BEFFECT_BASE		(QVET_ERR_BASE+0x00028000)	//vebaseeffect.cpp   		0x00828000
#define QVET_ERR_BENGINE_BASE		(QVET_ERR_BASE+0x00029000)	//vebaseengine.cpp   		0x00829000
#define QVET_ERR_BMTRACK_BASE		(QVET_ERR_BASE+0x0002A000)	//vebasemediatrack.cpp   	0x0082A000
#define QVET_ERR_BOPS_BASE			(QVET_ERR_BASE+0x0002B000)	//vebaseoutputstream.cpp   	0x0082B000
#define QVET_ERR_BSESSION_BASE		(QVET_ERR_BASE+0x0002C000)	//vebasesession.cpp   		0x0082C000
#define QVET_ERR_BTRACK_BASE		(QVET_ERR_BASE+0x0002D000)	//vebasetrack.cpp   		0x0082D000
#define QVET_ERR_BVEOPS_BASE		(QVET_ERR_BASE+0x0002E000)	//vebaseveoutputstream.cpp   	0x0082E000
#define QVET_ERR_BVC_BASE			(QVET_ERR_BASE+0x0002F000)	//vebasevideocomposer.cpp   	0x0082F000
#define QVET_ERR_BVOPS_BASE			(QVET_ERR_BASE+0x00030000)	//vebasevideooutputstream.cpp   0x00830000
#define QVET_ERR_BVTRACK_BASE		(QVET_ERR_BASE+0x00031000)	//vebasevideotrack.cpp   		0x00831000
#define QVET_ERR_BXMLP_BASE			(QVET_ERR_BASE+0x00032000)	//vebasexmlparser.cpp   		0x00832000
#define QVET_ERR_BXMLW_BASE			(QVET_ERR_BASE+0x00033000)	//ebasexmlwriter.cpp   			0x00833000
#define QVET_ERR_BMARK_BASE			(QVET_ERR_BASE+0x00034000)	//vebenchmark.cpp   			0x00834000
#define QVET_ERR_BTOPS_BASE			(QVET_ERR_BASE+0x00035000)	//vebubbletextoutputstream.cpp  0x00835000
#define QVET_ERR_BTTRACK_BASE		(QVET_ERR_BASE+0x00036000)	//vebubbletexttrack.cpp   		0x00836000
#define QVET_ERR_CLIPE_BASE			(QVET_ERR_BASE+0x00037000)	//veclipengine.cpp				0x00837000
#define QVET_ERR_CAOPS_BASE			(QVET_ERR_BASE+0x00038000)	//vecomboaudiooutputstream.cpp	0x00838000
#define QVET_ERR_CATRACK_BASE		(QVET_ERR_BASE+0x00039000)	//vecomboaudiotrack.cpp			0x00839000
#define QVET_ERR_CBTRACK_BASE		(QVET_ERR_BASE+0x0003A000)	//vecombobasetrack.cpp   		0x0083A000
#define QVET_ERR_CVOPS_BASE			(QVET_ERR_BASE+0x0003B000)	//etcombovideooutputstream.cpp 	0x0083B000
#define QVET_ERR_CVTRACK_BASE		(QVET_ERR_BASE+0x0003C000)	//vecombovideotrack.cpp			0x0083C000
#define QVET_ERR_COVERE_BASE		(QVET_ERR_BASE+0x0003D000)	//vecoverengine.cpp   			0x0083D000
//[0x0003E000, 0x0003F000)
#define QVET_ERR_DL_BASE			(QVET_ERR_BASE+0x0003E000)	//veduallist.cpp			   	0x0083E000
#define QVET_ERR_AADL_BASE			(QVET_ERR_BASE+0x0003E100)	//etaudioanalysisduallist.cpp  	0x0083E100
#define QVET_ERR_AVTP_BASE			(QVET_ERR_BASE+0x0003E200)	//etavtemplateparser.cpp	  	0x0083E200
#define QVET_ERR_AVUL_BASE			(QVET_ERR_BASE+0x0003E300)	//etavutils.cpp		0x0083E300
#define QVET_ERR_AATG_BASE			(QVET_ERR_BASE+0x0003E400)	//etaatarget.cpp		0x0083E400
#define QVET_ERR_AVPD_BASE			(QVET_ERR_BASE+0x0003E500)	//etavparamterdemonstrator.cpp		0x0083E500
#define QVET_ERR_32GA_BASE			(QVET_ERR_BASE+0x0003E600)	//etwin32gdiagent.cpp		0x0083E600
#define QVET_ERR_GXP_BASE				(QVET_ERR_BASE+0x0003E700)	//etgcsxmlparser.cpp		0x0083E700
#define QVET_ERR_AVGCS_BASE			(QVET_ERR_BASE+0x0003E800)	//etavgcsoutputstream.cpp		0x0083E800
#define QVET_ERR_SBC_BASE				(QVET_ERR_BASE+0x0003E900)	//etaastreambuffercache.cpp		0x0083E900
#define QVET_ERR_AAUL_BASE			(QVET_ERR_BASE+0x0003EA00)	//etaautils.cpp		0x0083EA00
#define QVET_ERR_WMD_BASE			(QVET_ERR_BASE+0x0003EB00)	//etwmdetector.cpp		0x0083EB00
#define QVET_ERR_SD_BASE			(QVET_ERR_BASE+0x0003EC00)	//qvsingdetector.cpp	0x0083EC00
#define QVET_ERR_MFE_BASE			(QVET_ERR_BASE+0x0003ED00)	//etmusicfeatureextractor.cpp	0x0083ED00
#define QVET_ERR_MFD_BASE			(QVET_ERR_BASE+0x0003EE00)	//etmusicfeaturedescriptor.cpp	0x0083EE00
#define QVET_ERR_MFXR_BASE			(QVET_ERR_BASE+0x0003EF00)	//etmusicfeaturexmlreader.cpp	0x0083EF00
#define QVET_ERR_TMCFG_BASE			(QVET_ERR_BASE+0x0003F000)	//etthemecachecfgparser.cpp		0x0083F000
#define QVET_ERR_MFXW_BASE			(QVET_ERR_BASE+0x0003F100)	//etmusicfeaturexmlwriter.cpp	0x0083F100
#define QVET_ERR_EDM_BASE			(QVET_ERR_BASE+0x0003F200)	//eteffectdecisionmaker.cpp	0x0083F200
#define QVET_ERR_EPXP_BASE			(QVET_ERR_BASE+0x0003F300)	//eteffectpluginxmlparser.cpp	0x0083F300
#define QVET_ERR_AV_ADPT_BASE	(QVET_ERR_BASE+0x0003F400)	//etavadaptor.cpp	0x0083F400




#define QVET_ERR_IESP_BASE			(QVET_ERR_BASE+0x00040000)	//veiestyleparser.cpp		   	0x00840000
#define QVET_ERR_LOTM_BASE			(QVET_ERR_BASE+0x00041000)	//etlayoutmapparser.cpp		   	0x00841000
#define QVET_ERR_TTCM_BASE			(QVET_ERR_BASE+0x00042000)	//etthemetexturecachemgr.cpp   	0x00842000
#define QVET_ERR_IMGE_BASE			(QVET_ERR_BASE+0x00043000)	//veimageengine.cpp			   	0x00843000
#define QVET_ERR_IOPS_BASE			(QVET_ERR_BASE+0x00044000)	//etimageoutputstream.cpp	   	0x00844000
#define QVET_ERR_CFGM_BASE			(QVET_ERR_BASE+0x00045000)	//etstyleconfiguremapparser.cpp   	0x00845000
#define QVET_ERR_ETCR_BASE			(QVET_ERR_BASE+0x00046000)	//eteffectcachemgr.cpp		   	0x00846000
#define QVET_ERR_MU_BASE			(QVET_ERR_BASE+0x00047000)	//vemarkup.cpp		   		0x00847000
#define QVET_ERR_MXU_BASE			(QVET_ERR_BASE+0x00048000)	//vematrixutility.cpp	   	0x00848000
#define QVET_ERR_MSCM_BASE			(QVET_ERR_BASE+0x00049000)	//vemediastreamcachemgr.cpp	0x00849000
#define QVET_ERR_CVBOS_BASE			(QVET_ERR_BASE+0x0004A000)	//etcombovideobaseoutputstream.cpp  	0x0084A000
#define QVET_ERR_CVCLIPOS_BASE		(QVET_ERR_BASE+0x0004B000)	//etcombovideoclipoutputstream.cpp		   	0x0084B000
#define QVET_ERR_MPOOPS_BASE		(QVET_ERR_BASE+0x0004C000)	//vempooutputstream.cpp	   	0x0084C000
#define QVET_ERR_DVTP_BASE			(QVET_ERR_BASE+0x0004D000)	//etdivatemplateparser.cpp		   	0x0084D000
#define QVET_ERR_NVC_BASE			(QVET_ERR_BASE+0x0004E000)	//venormalvideocomposer.cpp	0x0084E000
#define QVET_ERR_OPS_BASE			(QVET_ERR_BASE+0x0004F000)	//veoutputstream.cpp	   	0x0084F000
#define QVET_ERR_OPSKFF_BASE		(QVET_ERR_BASE+0x00050000)	//veoutputstreamkeyframefinder.cpp	0x00850000
#define QVET_ERR_PE_BASE			(QVET_ERR_BASE+0x00051000)	//veplayerengine.cpp	   	0x00851000
#define QVET_ERR_PS_BASE			(QVET_ERR_BASE+0x00052000)	//veplayersession.cpp	   	0x00852000
#define QVET_ERR_PSE_BASE			(QVET_ERR_BASE+0x00053000)	//veplayersessionengine.cpp	0x00853000
#define QVET_ERR_PPCM_BASE			(QVET_ERR_BASE+0x00054000)	//vepostprocesscachemgr.cpp	0x00854000
#define QVET_ERR_PDE_BASE			(QVET_ERR_BASE+0x00055000)	//veproducerengine.cpp   	0x00855000
#define QVET_ERR_PDS_BASE			(QVET_ERR_BASE+0x00056000)	//veproducersession.cpp	   	0x00856000
#define QVET_ERR_PDT_BASE			(QVET_ERR_BASE+0x00057000)	//veproducerthread.cpp	   	0x00857000
#define QVET_ERR_PRJE_BASE			(QVET_ERR_BASE+0x00058000)	//veprojectengine.cpp   	0x00858000
#define QVET_ERR_PRJT_BASE			(QVET_ERR_BASE+0x00059000)	//veprojectthread.cpp	   	0x00859000
#define QVET_ERR_SC_BASE			(QVET_ERR_BASE+0x0005A000)	//vesessioncontext.cpp	   	0x0085A000
#define QVET_ERR_SCM_BASE			(QVET_ERR_BASE+0x0005B000)	//vesplittercachemgr.cpp	0x0085B000
#define QVET_ERR_STBCLIP_BASE		(QVET_ERR_BASE+0x0005C000)	//vestoryboardclip.cpp	   	0x0085C000
#define QVET_ERR_STBCV_BASE			(QVET_ERR_BASE+0x0005D000)	//vestoryboardcover.cpp	   	0x0085D000
#define QVET_ERR_STBD_BASE			(QVET_ERR_BASE+0x0005E000)	//vestoryboarddata.cpp	   	0x0085E000
#define QVET_ERR_STBE_BASE			(QVET_ERR_BASE+0x0005F000)	//vestoryboardengine.cpp   	0x0085F000
#define QVET_ERR_STBS_BASE			(QVET_ERR_BASE+0x00060000)	//vestoryboardsession.cpp  	0x00860000
#define QVET_ERR_STBXP_BASE			(QVET_ERR_BASE+0x00061000)	//vestoryboardxmlparser.cpp	0x00861000
#define QVET_ERR_STBXW_BASE			(QVET_ERR_BASE+0x00062000)	//vestoryboardxmlwriter.cpp	0x00862000
#define QVET_ERR_SF_BASE			(QVET_ERR_BASE+0x00063000)	//vestylefinder.cpp  		0x00863000
#define QVET_ERR_SIP_BASE			(QVET_ERR_BASE+0x00064000)	//vestyleinfoparser.cpp		0x00864000
#define QVET_ERR_SPK_BASE			(QVET_ERR_BASE+0x00065000)	//vestylepacker.cpp  		0x00865000
#define QVET_ERR_SPRC_BASE			(QVET_ERR_BASE+0x00066000)	//vestyleprocer.cpp  		0x00866000
#define QVET_ERR_SPRS_BASE			(QVET_ERR_BASE+0x00067000)	//vestyleprocess.cpp  		0x00867000
#define QVET_ERR_SVGE_BASE			(QVET_ERR_BASE+0x00068000)	//vesvgengine.cpp	  		0x00868000
#define QVET_ERR_SVGOPS_BASE		(QVET_ERR_BASE+0x00069000)	//vesvgoutputstream.cpp		0x00869000
#define QVET_ERR_CBEFT_BASE			(QVET_ERR_BASE+0x0006A000)	//etcomboeffecttrack.cpp	        0x0086A000
#define QVET_ERR_DVCBEFT_BASE       (QVET_ERR_BASE+0x0006A100)  //etdivacomboeffecttrack.cpp    0x0086A100
#define QVET_ERR_TFM_BASE			(QVET_ERR_BASE+0x0006B000)	//vetempfilemgr.cpp  		0x0086B000
#define QVET_ERR_TSU_BASE			(QVET_ERR_BASE+0x0006C000)	//vetextstyleutility.cpp	0x0086C000
#define QVET_ERR_TE_BASE			(QVET_ERR_BASE+0x0006D000)	//vethemeengine.cpp  		0x0086D000
#define QVET_ERR_TSP_BASE			(QVET_ERR_BASE+0x0006E000)	//vethemestyleparser.cpp	0x0086E000
#define QVET_ERR_TT_BASE			(QVET_ERR_BASE+0x0006F000)	//vethemethread.cpp  		0x0086F000
#define QVET_ERR_TVC_BASE			(QVET_ERR_BASE+0x00070000)	//vethreadvideocomposer.cpp 0x00870000
#define QVET_ERR_TD_BASE			(QVET_ERR_BASE+0x00071000)	//vetrackdata.cpp			0x00871000
#define QVET_ERR_TSCM_BASE			(QVET_ERR_BASE+0x00072000)	//vetrackstreamcachemgr.cpp	0x00872000
#define QVET_ERR_FTTK_BASE			(QVET_ERR_BASE+0x00073000)	//eteffecttrack.cpp			0x00873000
#define QVET_ERR_UFE_BASE			(QVET_ERR_BASE+0x00074000)	//veutilfuncengine.cpp		0x00874000
#define QVET_ERR_UTL_BASE			(QVET_ERR_BASE+0x00075000)	//veutility.cpp				0x00875000
//#define QVET_ERR_RDBFT_BASE			(QVET_ERR_BASE+0x00076000)	//etglbasefilter.cpp	0x00876000
#define QVET_ERR_CVSTBOS_BASE		(QVET_ERR_BASE+0x00077000)	//etcombovideostoryboardoutputstream.cpp			0x00877000
#define QVET_ERR_VF_BASE			(QVET_ERR_BASE+0x00078000)	//vevideoframe.cpp				0x00878000
#define QVET_ERR_SCENE_OPS_BASE		(QVET_ERR_BASE+0x00079000)	//etsceneoutputstream.cpp	0x00879000
#define QVET_ERR_SCENE_TK_BASE		(QVET_ERR_BASE+0x0007A000)	//etscenetrack.cpp			0x0087A000
#define QVET_ERR_VIE_BASE			(QVET_ERR_BASE+0x0007B000)	//vevideoie.cpp					0x0087B000
#define QVET_ERR_VICM_BASE			(QVET_ERR_BASE+0x0007C000)	//vevideoinfocachemgr.cpp		0x0087C000
#define QVET_ERR_VOPS_BASE			(QVET_ERR_BASE+0x0007D000)	//vevideooutputstream.cpp		0x0087D000
#define QVET_ERR_VT_BASE			(QVET_ERR_BASE+0x0007E000)	//vevideotrack.cpp				0x0087E000
#define QVET_ERR_GIF_BASE			(QVET_ERR_BASE+0x0007F000)	//vethreadgifcomposer.cpp		0x0087F000
#define QVET_ERR_AA_API_BASE        (QVET_ERR_BASE+0x00080000)  //etaudio_api.cpp
#define QVET_ERR_PCME_BASE			(QVET_ERR_BASE+0x00080100)  //etpcmextractor.cpp  0x00880100
//0x0007F000
//0x00080000
//0x00081000
//0x00082000
//0x00083000
//0x00084000
#define QVET_ERR_IOSTVC_BASE		(QVET_ERR_BASE+0x00085000) //veiosthreadvideocomposer.cpp 0x00885000
#define QVET_ERR_VEIESP_BASE        (QVET_ERR_BASE+0x00086000)  //veiesettingparamparser.cpp    0x00886000
#define QVET_ERR_CBEFOS_BASE		(QVET_ERR_BASE+0x00087000)  //etcomboeffectoutputstream.cpp    0x00887000
#define QVET_ERR_PZOS_BASE			(QVET_ERR_BASE+0x00088000)  //etcombovideopanzoomoutputstream.cpp    0x00888000
#define QVET_ERR_VESURTEXO_BASE     (QVET_ERR_BASE+0x00089000) //etsurfacetextureoutputstream.cpp
#define QVET_ERR_MPO_DEC_THREAD_BASE	(QVET_ERR_BASE+0x0008A000) //etmpodecodethread.cpp
#define QVET_ERR_TRCLP_BASE				(QVET_ERR_BASE+0x0008B000) //ettrclyricsparser.cpp 	0x0088B000
#define QVET_ERR_AUDIO_ANALYZER_BASE		(QVET_ERR_BASE+0x0008C000) //etaudioanalyzer.cpp	 	0x0088C000
#define QVET_ERR_SECNECLIP_BASE			(QVET_ERR_BASE+0x0008D000) //etsceneclip.cpp 	0x0088D000
#define QVET_ERR_TRCSVGREADER_BASE		(QVET_ERR_BASE+0x0008E000) //etieframetrcsvgreader.cpp 	0x0088E000
#define QVET_ERR_TXTENGINE_BASE			(QVET_ERR_BASE+0x0008F000) //ettextengine.cpp 	0x0088F000
#define QVET_ERR_TPME_BASE				(QVET_ERR_BASE+0x00090000) //ettemplateparamengine.cpp 	0x00890000
#define QVET_ERR_TPM_DIVA_BASE			(QVET_ERR_BASE+0x00091000) //ettemplateparamobjectdiva.cpp 	0x00891000
#define QVET_ERR_PIP_PARAM_BASE			(QVET_ERR_BASE+0x00092000) //etpipparam.cpp 0x00892000
#define QVET_ERR_PIP_PO_BASE			(QVET_ERR_BASE+0x00093000) //etpipparamobject.cpp 0x00893000
#define QVET_ERR_WATERMARK_BASE			(QVET_ERR_BASE+0x00094000) //etwatermark.cpp 0x00894000
#define QVET_ERR_BFRD_BASE				(QVET_ERR_BASE+0x00095000) //etieframebufferreader.cpp 0x00895000
#define QVET_ERR_ADTSOS_BASE			(QVET_ERR_BASE+0x00096000) //etaudiotransitionoutputstream.cpp 0x00896000
#define QVET_ERR_SFTK_BASE				(QVET_ERR_BASE+0x00097000) //etsingleframetrack.cpp 0x00897000
#define QVET_ERR_SFOS_BASE				(QVET_ERR_BASE+0x00098000) //etsingleframeoutputstream.cpp 0x00898000
#define QVET_ERR_GIFOPS_BASE            (QVET_ERR_BASE+0x00099000) //etgifoutputstream.cpp 0x00899000
#define QVET_ERR_GIFTRACK_BASE          (QVET_ERR_BASE+0x0009A000) //vegiftrack.cpp 0x0089a000
#define QVET_ERR_TVRC_BASE              (QVET_ERR_BASE+0x0009B000) //vethreadreversevideocomposer.cpp 0x0089b000
#define QVET_ERR_IOSTVRC_BASE           (QVET_ERR_BASE+0x0009C000) //veiosthreadreversevideocomposer.cpp 0x0089c000
#define QVET_ERR_BR_BASE				(QVET_ERR_BASE+0x0009D000) //etieframebubblereader.cpp 0x0089D000
#define QVET_ERR_BE_BASE				(QVET_ERR_BASE+0x0009E000) //etbubbleengine.cpp 0x0089E000
#define QVET_ERR_GLET_BASE				(QVET_ERR_BASE+0x0009F000) //etgleffecttrack.cpp 0x0089F000
#define QVET_ERR_TSGE_BASE				(QVET_ERR_BASE+0x000A0000) //ettransitiongleffectoutputstream.cpp 0x008A0000
#define QVET_ERR_VEIESPV3_BASE          (QVET_ERR_BASE+0x000A1000) //veiesettingparamparsev3.cpp 0x008a1000
#define QVET_ERR_IETMPUTIL_BASE         (QVET_ERR_BASE+0x000A2000) //eteffecttemplateutils.cpp 0x008a2000
#define QVET_ERR_FRMST_PSV3_BASE        (QVET_ERR_BASE+0x000A3000) //veframesettingparserv3.cpp   0x008a3000
#define QVET_ERR_PSOS_BASE				(QVET_ERR_BASE+0x000A4000) //etpsoutputstream.cpp
#define QVET_ERR_PSSETTING_PARSER_BASE	(QVET_ERR_BASE+0x000A5000) //vepssettingparser.cpp
#define QVET_ERR_ANMPTOPT_BASE          (QVET_ERR_BASE+0x000A6000) //etieanimatpointoperator.cpp
#define QVET_ERR_HWCODECAP_PAR_BASE     (QVET_ERR_BASE+0x000A7000) //vehwcodeccapxmlparser.cpp
#define QVET_ERR_SLSH_SEEN_BASE         (QVET_ERR_BASE+0x000A8000) //veslideshowsessionengine.cpp
#define QVET_ERR_SLSH_SE_BASE           (QVET_ERR_BASE+0x000A9000) //veslideshowsession.cpp
#define QVET_ERR_SLSH_XMLPA_BASE        (QVET_ERR_BASE+0x000AA000) //veslideshowxmlparser.cpp
#define QVET_ERR_SLSH_XMLWR_BASE        (QVET_ERR_BASE+0x000AB000) //veslideshowxmlwriter.cpp
#define QVET_ERR_THEME_SCECFG_PA_BASE   (QVET_ERR_BASE+0x000AC000) //vethemescecfgparser.cpp
#define QVET_ERR_SLSH_EN_BASE           (QVET_ERR_BASE+0x000AD000) //etslideshowengine.cpp
#define QVET_ERR_TA_PARSER_BASE         (QVET_ERR_BASE+0x000AE000) //vetextanimationparamparser.cpp
#define QVET_ERR_ETTXRDFLT_BASE         (QVET_ERR_BASE+0x000AF000) //ettextrenderfilteroutputstream.cpp
#define QVET_ERR_3DOS_BASE				(QVET_ERR_BASE+0x000AF200) //et3doutputstream.cpp
#define QVET_ERR_FACEOS_BASE			(QVET_ERR_BASE+0x000AF300) //etfaceoutputstream.cpp
#define QVET_ERR_3DSETTING_PARSE_BASE	(QVET_ERR_BASE+0x000AF400) //ve3dsettingparser.cpp
#define QVET_ERR_TAE_BASE	            (QVET_ERR_BASE+0x000AF500) 
#define QVET_ERR_PEN_XMLPARSER_BASE		(QVET_ERR_BASE+0x000AF600)   	//0x008AF600 etpenxmlparser.cpp
#define QVET_ERR_PEN_STREAM_BASE			(QVET_ERR_BASE+0x000AF700)   	//0x008AF700 etpenoutputstream.cpp
#define QVET_ERR_AR3D_STREAM_BASE		(QVET_ERR_BASE+0x000AF800)   	//0x008AF700 etar3dstream.cpp
#define QVET_ERR_AR3D_SCENE_PARSER_BASE	(QVET_ERR_BASE+0x000AF900)   	//0x008AF700 etar3dstream.cpp
#define QVET_ERR_RIPPLE_XMLPARSER_BASE	(QVET_ERR_BASE+0x000B0000)   	//0x000B0000 etripplexmlparser.cpp
#define QVET_ERR_RIPPLE_STREAM_BASE		(QVET_ERR_BASE+0x000B0100)   	//0x000B0100 etripplrstream.cpp
#define QVET_ERR_LAYER_STYLR_XMLPARSER_BASE		(QVET_ERR_BASE+0x000B0300)   	//0x000B0300 etlayerStylexmlparser.cpp
#define QVET_ERR_LAYER_STYLR_STREAM_BASE		(QVET_ERR_BASE+0x000B0400)   	//0x000B0400 etlayerStylestream.cpp
#define QVET_ERR_WEBP_BASE                (QVET_ERR_BASE+0x000B1200)       //0x008B1200 vethreadwebpcomposer.cpp
#define QVET_ERR_PARTICLE_BASE			(QVET_ERR_BASE+0x000B1300)		//0x008B1300 particle lib
#define QVET_ERR_PARTICLE_END			(QVET_ERR_BASE+0x000B14FF)		//0x008B14FF particle lib
#define QVET_ERR_ATOM3D_BASE			(QVET_ERR_BASE+0x000B2000)		//0x008B2000 atom3d lib	
#define QVET_ERR_ATOM3D_END				(QVET_ERR_BASE+0x000B6FFF)		//0x008B6FFF atom3d lib
#define QVET_ERR_COLORCURVE_BASE		(QVET_ERR_BASE+0x000B7000)		//0x008B7000 etcolorcurveoutputstream.cpp
#define QVET_ERR_DISTRIBUTE_BASE		(QVET_ERR_BASE+0x000B8000)		//0x008B8000 etdistributestream.cpp
#define QVET_ERR_MOTIONTILE_BASE		(QVET_ERR_BASE+0x000B9000)		//0x008B9000 motiontile.cpp
#define QVET_ERR_MOTIONTILE_PARSER_BASE (QVET_ERR_BASE+0x000BA000)		//0x008BA000 motiontileparser.cpp
#define QVET_ERR_MESHWARP_BASE		    (QVET_ERR_BASE+0x000BB000)		//0x008BB000 meshwarp.cpp
#define QVET_ERR_MESHWARP_PARSER_BASE	(QVET_ERR_BASE+0x000BC000)		//0x008BC000 meshwarpparser.cpp
#define QVET_ERR_PSSCATTEROS_BASE		(QVET_ERR_BASE+0x000BF000)		//0x008BF000 etparticlescatter.cpp
/*
* Error Definition Zone for FilePackage Tools
* Range: [0x008B0000, 0x008BF000]
*/
#define QVET_ERROR_PACKER_BASE		(QVET_ERR_BASE+0x000B0000)
#define QVET_ERROP_UNPACKER_BASE	(QVET_ERR_BASE+0x000B1000)

/*
 *  Error Definition Zone for iOS engine-object-c
 *  Range: [0x008C0000, 0x008CF000)
 */

#define QVERR_OCCE_BASE             (QVET_ERR_BASE+0x000C0000)  //CXiaoYingCamEngine.mm 0x008C0000
#define QVERR_OCCLIP_BASE           (QVET_ERR_BASE+0x000C1000)  //CXiaoYingClip.mm      0x008C1000
#define QVERR_OCEFFECT_BASE         (QVET_ERR_BASE+0x000C2000)  //CXiaoYingEffect.mm    0x008C2000
#define QVERR_OCENGINE_BASE         (QVET_ERR_BASE+0x000C3000)  //CXiaoYingEngine.mm    0x008C3000
#define QVERR_OCPLAYER_BASE         (QVET_ERR_BASE+0x000C4000)  //CXiaoYingPlayerSession.mm     0x008C4000
#define QVERR_OCPOSTER_BASE         (QVET_ERR_BASE+0x000C5000)  //CXiaoYingPoster.mm    0x008C5000
#define QVERR_OCPD_BASE             (QVET_ERR_BASE+0x000C6000)  //CXiaoYingProducerSession.mm   0x008C6000
#define QVERR_OCS_BASE              (QVET_ERR_BASE+0x000C7000)  //CXiaoYingSession.mm   0x008C7000
#define QVERR_OCSTB_BASE            (QVET_ERR_BASE+0x000C8000)  //CXiaoYingStoryboardSession.mm 0x008C8000
#define QVERR_OCSTREAM_BASE         (QVET_ERR_BASE+0x000C9000)  //CXiaoYingStream.mm    0x008C9000
#define QVERR_OCSTYLE_BASE          (QVET_ERR_BASE+0x000CA000)  //CXiaoYingStyle.mm     0x008CA000
#define QVERR_OCUTILS_BASE          (QVET_ERR_BASE+0x000CB000)  //CXiaoYingUtils.mm     0x008CB000
#define QVERR_OCCOVER_BASE          (QVET_ERR_BASE+0x000CC000)  //CXiaoYingCover.mm     0x008CC000
#define QVERR_QCSCENECLIP_BASE      (QVET_ERR_BASE+0x000CD000)  //CXiaoYingSceneClip.mm 0x008CD000
#define QVERR_OCPIPPO_BASE          (QVET_ERR_BASE+0x000CE000)  //CXiaoYingPIPPO.mm     0x008CE000
#define QVERR_OCAMPOT_BASE          (QVET_ERR_BASE+0x000CF000)  //CXiaoYingAnimatePointOperator.mm 0x008CF000
#define QVERR_SLSHSE_BASE           (QVET_ERR_BASE+0x000D0000)  //CXiaoYingSlideShowSession.mm 0x008D0000
#define QVERR_TAINFO_BASE           (QVET_ERR_BASE+0x000D1000)  //CXiaoYingTextAnimationInfo.mm 0X008D1000
#define QVERR_OCWMD_BASE            (QVET_ERR_BASE+0x000D1100)  //CWMD.mm 0X008D1100
#define QVERR_FACEDT_BASE           (QVET_ERR_BASE+0x000D1200)  //CXiaoyingFaceDTUtils.mm    0x008D1200
#define QVERR_OCSD_BASE             (QVET_ERR_BASE+0x000D1300)  //CSD.mm    0x008D1300
#define QERR_OC_CEBASE              (QVET_ERR_BASE+0x000D1400)  //QCamBase.mm    0x008D1400
#define QERR_OC_CE_INTERNAL_FN      (QVET_ERR_BASE+0x000D1500)  //QCamInternalFn.mm    0x008D1500
#define QERR_OC_CEAR                (QVET_ERR_BASE+0x000D1600)  //QCamAR.mm    0x008D1600
#define QERR_OC_CEBASE_PROTECTED    (QVET_ERR_BASE+0x000D1700)  //QCamBase+Protected.mm    0x008D1700
#define QERR_OC_PCME_BASE           (QVET_ERR_BASE+0x000D1800)  //QPCMExtractor.mm    0x008D1800
#define QERR_OC_AUDIO_PROVIDER_BASE         (QVET_ERR_BASE+0x000D1B00)      //0X000D1B00  CXiaoYingAudioProvider.cmm

/*
*	以下是针对 JNI层的cpp err分段
*		"计划"占用err段落区间为   [0x008E0000,  0x008FE000) 总计30段(不含0x008FE000)
*/
#define QVET_ERR_JBN_BASE			(QVET_ERR_BASE+0x000E0000)	//vebasenative.cpp		0x008E0000
#define QVET_ERR_JCN_BASE			(QVET_ERR_BASE+0x000E1000)	//veclipnative.cpp		0x008E1000
#define QVET_ERR_JCVN_BASE			(QVET_ERR_BASE+0x000E2000)	//vecovernative.cpp		0x008E2000
#define QVET_ERR_JPN_BASE			(QVET_ERR_BASE+0x000E3000)	//veplayernative.cpp	0x008E3000
#define QVET_ERR_JPDN_BASE			(QVET_ERR_BASE+0x000E4000)	//veproducernative.cpp 	0x008E4000
#define QVET_ERR_JSBN_BASE			(QVET_ERR_BASE+0x000E5000)	//vestoryboardnative.cpp 	0x008E5000
#define QVET_ERR_JUTL_BASE			(QVET_ERR_BASE+0x000E6000)	//veutilfunc.cpp	 		0x008E6000
#define QVET_ERR_JPTN_BASE			(QVET_ERR_BASE+0x000E7000)	//etposternative.cpp 		0x008E7000
#define QVET_ERR_JFRN_BASE			(QVET_ERR_BASE+0x000E8000)	//etframereadernative.cpp 	0x008E8000
#define QVET_ERR_JSTO_BASE          (QVET_ERR_BASE+0x000E9000)  //vesurfacetextureownerjava.cpp
#define QVET_ERR_JSCPN_BASE         (QVET_ERR_BASE+0x000EA000)  //vesceneclipnative.cpp
#define	QVET_ERR_JPIPFP_BASE		(QVET_ERR_BASE+0x000EB000)	//jni_pip_fp.cpp
#define QVET_ERR_JSLSHN_BASE        (QVET_ERR_BASE+0x000EC000)  //veslideshowsessionnative.cpp       0x008EC000
#define QVET_ERR_JWMD_BASE		    (QVET_ERR_BASE+0x000EC100)  //etwmdnative.cpp       0x008EC100
#define QVET_ERR_JSD_BASE		    (QVET_ERR_BASE+0x000EC200)  //etsdnative.cpp       0x008EC200
#define QVET_ERR_MEDIA_PREPARE_THREAD (QVET_ERR_BASE+0x000EC300)  //etmediadatapreparethread.cpp       0x008EC300
#define QVET_ERR_JPCME_BASE			(QVET_ERR_BASE+0x000EC400)  //etpcmenative.cpp       0x008EC400


/*
*	QVET_ERR_COMMON_BASE 	是一个特殊错误代码段，此段不是给任何cpp所专用。此段主要用于在不同cpp间需要传递的err定义
*							代码书写时，如果没有cpp之间耦合的的情况，要避免在此段新增err定义
*							"计划"只占用0x008FE000 段
*/

#define QVET_ERR_COMMON_BASE				(QVET_ERR_BASE + 0x000FE000) //0x008FE000
#define QVET_ERR_COMMON_FN_CALLBACK			(QVET_ERR_COMMON_BASE + 1)	 //0x008FE001
#define QVET_ERR_COMMON_PAUSE				(QVET_ERR_COMMON_BASE + 2)	 //0x008FE002
#define QVET_ERR_COMMON_STOP				(QVET_ERR_COMMON_BASE + 3)	 //0x008FE003
#define QVET_ERR_COMMON_CANCEL				(QVET_ERR_COMMON_BASE + 4)	 //0x008FE004
#define QVET_ERR_COMMON_TEMPLATE_MISSING	(QVET_ERR_COMMON_BASE + 5)	 //
#define QVET_ERR_COMMON_NO_MORE_VALID_DATA			(QVET_ERR_COMMON_BASE + 6) //在处理AAStreamBufCache的时候引入的，用于与调用者通信，应对不同required buffer length的需要
#define QVET_ERR_COMMON_PRJLOAD_CLIPFILE_MISSING	(QVET_ERR_COMMON_BASE + 7)
#define QVET_ERR_COMMON_CALLFN_INVALID_PARAM		(QVET_ERR_COMMON_BASE + 8)	//宏定义 CALL_AMVE_FUNC()专用的错误码
#define QVET_ERR_COMMON_JAVA_NOT_INIT				(QVET_ERR_COMMON_BASE + 9)   //给引擎java代码用的,C层不会出现
#define QVET_ERR_COMMON_JAVA_FAIL					(QVET_ERR_COMMON_BASE + 10)  //给引擎java代码用的,C层不会出现
#define QVET_ERR_COMMON_JAVA_INVALID_PARAM			(QVET_ERR_COMMON_BASE + 11)  //给引擎java代码用的,C层不会出现
#define QVET_ERR_COMMON_EXPORT_SIZE_EXCEEDED		(QVET_ERR_COMMON_BASE + 12)
#define QVET_ERR_COMMON_HWCODEC_EXCEPTION           (QVET_ERR_COMMON_BASE + 13)
#define QVET_ERR_COMMON_EXPORT_CLOSE_FILE_ERROR     (QVET_ERR_COMMON_BASE + 14)
#define QVET_ERR_COMMON_FONT_SIZE_NOTEDITALBE       (QVET_ERR_COMMON_BASE + 15)
#define QVET_ERR_COMMON_FONT_COLOR_NOTEDITABLE      (QVET_ERR_COMMON_BASE + 16)
#define QVET_ERR_COMMON_QVET_ERR_COMMON             (QVET_ERR_COMMON_BASE + 17)



/*
*	QVET_ERR_APP_BASE 	是为了方便 testbed，或是app
*						"计划"只占用0x008FF000 段
*/
#define QVET_ERR_APP_BASE					(QVET_ERR_BASE + 0x000FF000) //0x008FF000
#define QVET_ERR_APP_MEM_ALLOC				(QVET_ERR_APP_BASE + 1) 	 //0x008FF001
#define QVET_ERR_APP_FAIL					(QVET_ERR_APP_BASE + 2) 	 //0x008FF002
#define QVET_ERR_APP_NULL_POINTER			(QVET_ERR_APP_BASE + 3) 	 //0x008FF003
#define QVET_ERR_APP_NOT_SUPPORT			(QVET_ERR_APP_BASE + 4) 	 //0x008FF004
#define QVET_ERR_APP_FILE_OPEN				(QVET_ERR_APP_BASE + 5) 	 //0x008FF005
#define QVET_ERR_APP_NOT_READY				(QVET_ERR_APP_BASE + 6) 	 //0x008FF006
#define QVET_ERR_APP_INVALID_PARAM			(QVET_ERR_APP_BASE + 7) 	 //0x008FF007
#define QVET_ERR_APP_SMALL_BUF				(QVET_ERR_APP_BASE + 8) 	 //0x008FF008































#endif	// _AMVEERRDEF_H_
