#ifndef ETMUSICFEATUREXMLREADER_H
#define ETMUSICFEATUREXMLREADER_H


#include "amcomdef.h"

class CVEBaseXmlParser;
class CMusicFeatureDescriptor;
class CMusicFeatureXMLReader : public CVEBaseXmlParser
{
public:
	CMusicFeatureXMLReader();
	virtual ~CMusicFeatureXMLReader();

	MRESULT load(MTChar *xml, CMusicFeatureDescriptor* mfd);

private:
	MRESULT openXML(MTChar *xml);
	MVoid    closeXML();

	MRESULT readAllData();

	MRESULT readBasicInfo();
	MRESULT readFeatureList();

	MRESULT readVolumnData();
	MRESULT readOnsetData();
	MRESULT readTempoData(){return 0;} //show err only, do nothing
	MRESULT readSingData(); //show err only, do nothing


private:
	CMusicFeatureDescriptor *mMFDRef;
	HMSTREAM  mFileStream;

};






#endif




