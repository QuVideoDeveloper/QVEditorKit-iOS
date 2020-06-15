#ifndef ETAVADAPTER_H
#define ETAVADAPTER_H


#include "amcomdef.h"
#include "amvedef.h"






typedef struct __QVET_SD_CBDATA
{
	MDWord total;
	MDWord curPos; //current postion detected

	MDWord status;	//AMVE_PROCESS_STATUS_XXX
	MRESULT err;

	MDWord offset; //all result need to add this offset, because detection will start from non-zero postion
	MDWord resultCnt;
	const MDWord *startList;
	const MDWord *endList;
}QVET_SD_CBDATA;

typedef MVoid (*QVET_SINGDETECTING_CALLBACK)(QVET_SD_CBDATA *cbData, MVoid* userData);


typedef struct __QVET_SD_PARAM
{
	MTChar *song;
	AMVE_POSITION_RANGE_TYPE refBGMRange;//the main music rythm section
	AMVE_POSITION_RANGE_TYPE detectRange; //which range of  the song you wanna detect


	MDWord maxGap;// = 200;
	MDWord maxLength;// = 25000;
	MDWord	minLength;// = 1000;


	QVET_SINGDETECTING_CALLBACK callback;
	MVoid* userdata;
}QVET_SD_PARAM;


MHandle QVET_SingDetectorCreate(QVET_SD_PARAM *param);
MRESULT QVET_SingDetectorStart(MHandle h);
MRESULT QVET_SingDetectorPause(MHandle h);
MRESULT QVET_SingDetectorResume(MHandle h);
MRESULT QVET_SingDetectorStop(MHandle h);
MVoid	 QVET_SingDetectorDestroy(MHandle h);
	
	
	
	
	
	//for music feature extractor and descriptor
#define MUSIC_FEATURE_NONE			0x00000000
#define MUSIC_FEATURE_ONSET			0x00000001
#define MUSIC_FEATURE_VOLUMN			0x00000002
#define MUSIC_FEATURE_SING				0x00000004
#define MUSIC_FEATURE_TEMPO				0x00000008
#define MUSIC_FEATURE_HEAVY_BEAT		0x00000010
#define MUSIC_FEATURE_OTHER_B			0x00000020 //has not been used
	
	

/*
 * MFD = music feature descriptor, it's only the data keeper, all its data comes from MFE defined below
 */
MHandle MFDCreate(MTChar* id);
MVoid	 MFDDestroy(MHandle h);
MRESULT MFDSaveToXML(MHandle h, MTChar *xmlFile);
MRESULT MFDLoadFromXML(MHandle h, MTChar *xmlFile);



typedef struct __tagMFE_CBDATA
{
	MDWord total;
	MDWord curPos;//current position

	MDWord	status;
	MRESULT err;
}MFE_CBDATA;


typedef MVoid (*MFE_CALLBACK)(MFE_CBDATA *cbData, MVoid* userData);


typedef struct __tagMF_ONSET_PICK_CONDITION
{
	MDWord temp;

	MDWord stepSpan; //判断音量阶跃的timespan
	MDWord filterSpan; //在这段span里，只留一个onset

	MFloat absVolThreshold; //绝对音量阈值
	MFloat deltaVolThreshold; //前后音量变化阈值


}MF_ONSET_PICK_CONDITION;

typedef struct __tagMFE_PARAM
{
	MTChar *music;
	MDWord	features; //combined by MUSCI_FEATURE_XXX

	MDWord detectStartPos; //also need to save to MFD by  MFD Config
	MDWord detectLen; //also need to save to MFD by MFD Config

	MHandle hMFD; //MFE will save the result to the MFD automatically, it's the handle created by MFDCreate


	//for volume detector
	MBool  vdIsOnDB;
	MDWord vdTimeSpan;
	MFloat vdThreshold;

	//for heavy beat
//	MFloat heavyBeatValue; //0~1.0 要更名为hbDeltaVol
//	MFloat hbAbsVol;
//	MFloat hbDeltaVol;
//	MDWord hbCheckSpan;
//	MDWord hbCoveredSpan;
	MF_ONSET_PICK_CONDITION onsetCond;

	//for sing detector
	MDWord sdBGMStartPos;
	MDWord sdBGMLen;
	MDWord sdMaxGap;// = 200;
	MDWord sdMaxLength;// = 25000;
	MDWord sdMinLength;// = 1000;


	MDWord aeFPS;//只是素材设计师要用
	

	//for callback
	MFE_CALLBACK callback;
	MVoid*		userData;
}MFE_PARAM;


typedef struct __tagMF_TEMPO
{

}MF_TEMPO;

/*

Grave		16~39	
Largo		40~59	
Larghetto		60~65	
Adagio		66~75	
Andante 	76~89	

Moderato		90~104	
Allegretto		105~114 "分界点可以设置为120"

Allegro 	115~129 
Vivace		130~167 

Presto		168~199 
Prestissimo 	200~

*/

//MFE = music feature extractor.  The feature will be analyzed and extracted from music, and the feature data will be save to MFD defined above
MHandle MFECreate(MFE_PARAM *param); //MFD will be set to MFE to contain the analying result
MRESULT MFEStart(MHandle h);
MRESULT MFEPause(MHandle h);
MRESULT MFEResume(MHandle h);
MRESULT MFEStop(MHandle h);
//MRESULT MFERefine(MHandle h);  //this API perform refining operation of feature data. it should be called after MFE's stop.
MVoid	 MFEDestroy(MHandle h);
	
	
//EDM: effect decision maker	
#define EDM_PLUGIN_PROP_BASE				0x00000000
#define EDM_PLUGIN_PROP_CANDIDATE_PROBABILITY			(EDM_PLUGIN_PROP_BASE + 1)
#define EDM_PLUGIN_PROP_OVERLAP_WEIGHT					(EDM_PLUGIN_PROP_BASE + 2)
	
	
#define EDM_PLUGIN_NAME_LENGTH			64
	
typedef struct __tagEDM_PARAM
{
	MHandle hMFD;
	MTChar *avTemplate;
}EDM_PARAM;


typedef struct __tagVE_EFFECT_LIST
{
	MDWord cnt;
	MHandle *hEffects;
}VE_EFFECT_LIST;


MHandle EDMCreate(EDM_PARAM *param);
MVoid	 EDMDestroy(MHandle hMaker);
MRESULT EDMLoadPluginByTemplate(MHandle hMaker, MTChar *avTemplate);
MVoid	 EDMUnloadPlugin(MHandle hMaker, MTChar *name); //需要plugin list

MRESULT EDMSetPluginProperty(MHandle hMaker, MTChar *pluginName, MDWord propID, MVoid* value);
MRESULT EDMGetPluginProperty(MHandle hMaker, MTChar *pluginName, MDWord propID, MVoid* value);

MRESULT EDMExecute(MHandle hMaker);

//const EDM_VE_EFFECT_LIST* EDMPeekExecuteResult(MHandle hMaker);//@@@返回什么，还要再仔细考虑

const VE_EFFECT_LIST* EDMGenerateVEEffectList(MHandle hMaker);

MBool	 EDMIsPluginLoaded(MHandle hMaker, MTChar *name);
MBool	 EDMIsPluginActivated(MHandle hMaker, MTChar *name); //call after execute


typedef struct __tagEFFECT_PLUGIN_BASIC_INFO
{
	MDWord version;
	MDWord visualEffectType;
	MUInt64 visualEffectID;
	MTChar name[EDM_PLUGIN_NAME_LENGTH];

	MFloat candidateProbability;
	MDWord overlapPickWeight;
	
	MTChar recommendingMusic[EDM_PLUGIN_NAME_LENGTH];
	MDWord originalDesignLen;
}EFFECT_PLUGIN_BASIC_INFO;


MRESULT EDMEnquirePlugin(MTChar *pluginTemplate, EFFECT_PLUGIN_BASIC_INFO **list/*out*/, MDWord *cnt/*out*/);
MVoid	 EDMReleasePluginBasicInfoList(EFFECT_PLUGIN_BASIC_INFO *list,		  MDWord cnt, MBool bFreeRoot);




	








#endif //endif of ETAVADAPTER_H



