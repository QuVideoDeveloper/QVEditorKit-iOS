/**
* @author  Jonathan
*
* @version  v1.0
*
* @history init version - 02.09.2018
**/

#ifndef ETEFFECTPLUGINXMLPARSER_H
#define ETEFFECTPLUGINXMLPARSER_H



#include "eteffectplugincomdef.h"
#include "etavadapter.h"



class CVEBaseXmlParser;
class CEffectPlugin;
class COR;
class CORNAR;
class CORAR;
class CSR;




class CEffectPluginXMLParser : public CVEBaseXmlParser
{
public:
	CEffectPluginXMLParser();
	virtual ~CEffectPluginXMLParser();

	/*名字回头再说*/
//	MRESULT openXML(MTChar *file);
	MRESULT openXML(HMSTREAM hStream);
	MVoid    closeXML();

	MRESULT doParse();
	
	MDWord getPluginCnt();
	CEffectPlugin **peekPlugins();

private:
	MVoid uninit();

	CEffectPlugin *parsePlugin();
	MRESULT parseBasicInfo(EFFECT_PLUGIN_BASIC_INFO *info/*in,out*/);
	COR* parseObjectiveRequirement();
	CSR* parseSubjectiveRequirement();

	MRESULT parseObjectiveRequirement_NAR(CORNAR *o);
	TO_IMPLEMENT MRESULT parseObjectiveRequirement_AR(CORAR *o);	

	
private:
	MDWord mPluginCnt;
	CEffectPlugin **mPluginList;
	
};





#endif //endif of ETEFFECTPLUGINXMLPARSER_H




