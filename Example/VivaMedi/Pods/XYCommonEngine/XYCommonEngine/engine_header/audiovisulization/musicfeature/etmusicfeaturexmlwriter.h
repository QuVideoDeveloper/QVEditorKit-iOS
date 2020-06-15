#ifndef ETMUSICFEATUREXMLWRITER_H
#define ETMUSICFEATUREXMLWRITER_H








#include "amcomdef.h"

class CVEBaseXMLWriter;
class CMusicFeatureDescriptor;
class CMusicFeatureXMLWriter : public CVEBaseXMLWriter
{
public:
	CMusicFeatureXMLWriter();
	virtual ~CMusicFeatureXMLWriter();

	MRESULT save(MTChar *xml, CMusicFeatureDescriptor *mfd);

private:
	MRESULT writeBasicInfo();	
	MRESULT writeFeatureList();
	

	MRESULT writeVolumeData();
//	MRESULT writeOnsetData();
	MRESULT writeMFOnestData();

	MRESULT writeHeavyBeatData(); //strategy 1
	MRESULT writePickedOnsetData(); //strategy 2
	
	MRESULT writeTempoData(){return 0;} //show err only, do nothing
	MRESULT writeSingData(); //show err only, do nothing

	

private:
	CMusicFeatureDescriptor *mMFDRef;
};




#endif




//

