#ifndef ETMUSICFEATUREDESCRIPTOR_H
#define ETMUSICFEATUREDESCRIPTOR_H



#include "amvedef.h"
#include "qvasp.h"

#include "etavadapter.h"
#include "etavcomdef.h"

#define MFD_CFG_NONE						0x00000000
#define MFD_CFG_VOLUME_DB_MODE				0x00000001	//true or false
#define MFD_CFG_VOLUME_TIMESPAN				0x00000002	//ms
#define MFD_CFG_VOLUME_THRESHOLD			0x00000003	//	
#define MFD_CFG_MUSIC_RANGE					0x00000004
#define MFD_CFG_AE_FPS						0x00000005 //only the effect designer need this, related to AE they used
#define MFD_CFG_ONSET_PICK_CONDITION		0x00000006
//#define MFD_CFG_HB_ABS_VOLUME_THRESHOLD		0x00000006 //onset区间内的最大音量必须大于这个值
//#define MFD_CFG_HB_DELTA_VOLUME_THRESHOLD	0x00000007 
//#define MFD_CFG_HB_CHECK_SPAN				0x00000008
//#define MFD_CFG_HB_COVERED_SPAN				0x00000009



class CMusicFeatureXMLReader;
class CMusicFeatureXMLWriter;
class CMusicFeatureDescriptor
{

friend class CMusicFeatureXMLReader;
friend class CMusicFeatureXMLWriter;
//friend class CEffectDecisionMaker;

public:
	CMusicFeatureDescriptor();
	virtual ~CMusicFeatureDescriptor();


	MRESULT init(MTChar* musicID);
	MVoid	 uninit();
	MVoid    cleanAllData(); //@@all data clean should be done here!!!!

	MRESULT setConfig(MDWord cfg, MVoid* value);
	MRESULT getConfig(MDWord cfg, MVoid* value);

	const MTChar* getMusicID();


	//add API for MFE's call
	MRESULT addOnsetData(ASP_ONSET_DETECTION_RESULT* onsetData);
	MRESULT addVolumeRawData(ASP_AMPLITUDE_DETECT_RESULT* volumnData);//@@@to refine API definition
	MRESULT addSingData(ASP_SAD_RESULT* singData);

	//xml operation 
	MRESULT saveToXml(MTChar* xml);
	MRESULT loadFromXml(MTChar* xml);


private:
	MRESULT extractHighLevelData();
	MRESULT extractMFVolume(); // by threshold
	MRESULT extractHeavyBeatData_old();
	MRESULT extractPickedOnsetData();


	MRESULT getherOriginalMFOnsetData();
	MRESULT pickMFVolumeStep(MF_VOLUME_DATA *volData, MDWord span, MDWord centerPos, 
							MFloat *maxVol, MFloat *minVol, MBool *toBeLoud);	
	MRESULT filterOnsetByVolDeltaPeak(MF_ONSET_DATA *hb, MF_ONSET_DATA *pickedout = MNull); //if pickedout == MNull, picked result is saved to the input
	MRESULT filterOnsetByVolThreshold(MF_ONSET_DATA *inputOD);

	
private:
	MTChar *mMusicID;
	AMVE_POSITION_RANGE_TYPE mMusicRange;
	

	ASP_ONSET_DETECTION_RESULT 		mAspOnset;
	ASP_AMPLITUDE_DETECT_RESULT		mVolumeData; //original volume data
	ASP_SAD_RESULT		mSingData;


	//high level data
	MFloat mMaxVolume;
	MFloat mMinVolume;
	MFloat mVolumeThreshold; //the filtered result is saved to HighVolume
	MF_VOLUME_DATA mMFVolume;

	
	MF_ONSET_DATA		mHeavyBeatData;
	MF_ONSET_DATA		mHBLeft; //onset which is un-qualified by the HB Condition
	MF_ONSET_DATA		mMFOnset;


	MF_ONSET_PICK_CONDITION mOnsetCond;
	MF_ONSET_DATA		mPickedOnset;

	CMusicFeatureXMLReader *mXmlRead;
	CMusicFeatureXMLWriter *mXmlWriter;


	MDWord mAEFPS; //only for designer
};




#endif









