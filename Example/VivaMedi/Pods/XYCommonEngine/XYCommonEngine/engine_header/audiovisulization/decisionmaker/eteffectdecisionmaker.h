/**
* @author  Jonathan
*
* @version  v1.0
*
* @history	init version - 02.09.2018
**/



#ifndef  ETEFFECTDECISIONMAKER_H
#define  ETEFFECTDECISIONMAKER_H



#include "eteffectplugincomdef.h"
#include "etavadapter.h"


class CVEBaseXmlParser;
class CEffectPlugin;
class CEffectPluginXMLParser;
class CMPtrListEx;
class CMusicFeatureDescriptor;


typedef struct __tagEP_HOLDER
{
//	EP_TIME_POSITIONS pos;//save pos info for the first round decision 

	//effect time range info list
	MDWord *start;
	MDWord *len;
	MDWord cnt;
	MDWord capacity;

	CEffectPlugin *ep; //arbitrate的时候要用到，但是放在这里，貌似不是很好	

}EP_HOLDER;//for one EP

typedef struct __tagEP_MERGE_RESULT
{
	CEffectPlugin **epList;//only reference from EP_HOLDER, no need to release epList[i], but need to free the epList buf
	MDWord *start;
	MDWord *len;
	MDWord cnt;
	MDWord capacity;	


}EP_MERGE_RESULT; //combinated



class CEffectDecisionMaker
{
public:
	CEffectDecisionMaker();
	virtual ~CEffectDecisionMaker();

	MRESULT init(EDM_PARAM *param);
	MVoid    uninit();

	MRESULT loadPluginByTemplate(MTChar *avTemplate);//CQVETPKGParser
	MVoid    unloadPlugin(MTChar *name);


	MRESULT setPluginProp(MTChar *name, MDWord propID, MVoid* value);
	MRESULT getPluginProp(MTChar *name, MDWord propID, MVoid* value);	


	MRESULT execute();
	TO_IMPLEMENT const VE_EFFECT_LIST* generateVEEffectList(){return MNull;}


	MBool    isPluginLoaded(MTChar *name);
	MBool    isPluginActivated(MTChar *name);


	static MRESULT enquirePlugin(MTChar *pluginTemplate, EFFECT_PLUGIN_BASIC_INFO **list/*out*/, MDWord *cnt/*out*/);
	static MVoid    releasePluginBasicInfoList(EFFECT_PLUGIN_BASIC_INFO *list,     MDWord cnt, MBool bFreeRoot=MFalse);


private:
	MVoid    reset();//for new round execute; clean all old result!!!!!!
	MHandle findHolderNodeByPluginName(MTChar *name);

//	MRESULT decide4SingleEP(CMusicFeatureDescriptor *mfd, EP_HOLDER *epData/*in, out*/);
	TO_IMPLEMENT MRESULT mergeEP(); //也可以不带形参

	


	static MRESULT prepareEPMergeResult(EP_MERGE_RESULT *result, MDWord newCap);
	static MVoid    freeEPMergeResult(EP_MERGE_RESULT *result, MBool bFreeRoot=MFalse);	
	
	static MRESULT prepareTPCache4EPHolder(EP_HOLDER *holder, MDWord newCap);
	static MVoid    freeEPHolder(EP_HOLDER *holder, MBool freeRoot=MFalse);
	

	//@@@@@@@@@@@@@@@@@@@@@@@@ TO Un-Comment @@@@@@@@@@@@@@@@@@@@@@@@
	//static MRESULT loadTP2EPHolder(TIME_POSITIONS *tp, EP_HOLDER *holder);//动态expand data的capacity





	//other function TBD
	MRESULT getOverlapRange();//API    TBD







private:
	CMusicFeatureDescriptor *mMFD; //only a reference	
	CMPtrListEx       mHolderList;//it's ep holder list, not ep list
	EP_MERGE_RESULT mMerged;
};








#endif //endif of ETEFFECTDECISIONMAKER_H
