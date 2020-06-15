/**
 * @author  Jonathan
 *
 * @version  v1.0
 *
 * @history 	1. init version - 02.09.2018
 *				2. refine definition - 02.26.2018
 **/



#ifndef ETEFFECTPLUGIN_H
#define ETEFFECTPLUGIN_H

#ifdef SUPPORT_EFFECT_PLUGIN

#include "eteffectplugincomdef.h"


class COR;
class CSR;
class CMusicFeatureDescriptor;

class CEffectPlugin
{

friend class CEffectPluginXMLParser;

public:
	CEffectPlugin();
	virtual ~CEffectPlugin();

	MRESULT match(CMusicFeatureDescriptor *mfd, MVoid* otherInfo, TIME_POSITIONS *tp/*in,out*/);
	CEffectPlugin *duplicate();

private:
	EFFECT_PLUGIN_BASIC_INFO		mBasicInfo;
	COR		*mOR;
	CSR		*mSR;

};

#endif


#endif //endif of ETEFFECTPLUGIN_H

