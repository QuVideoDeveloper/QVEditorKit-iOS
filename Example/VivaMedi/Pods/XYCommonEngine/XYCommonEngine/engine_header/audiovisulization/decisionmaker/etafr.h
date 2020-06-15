/**
* @author  Jonathan
*
* @version  v1.0
*
* @history	init version - 02.26.2018
**/



#ifndef ETAFR_H
#define ETAFR_H


class CMusicFeatureDescriptor;
class CAFR		//AFR=Audio Feature Requirement
{
public:
	CAFR(){mType[0] = 0;}
	virtual ~CAFR(){}


	virtual CAFR* duplicate() = 0;
	virtual MRESULT locateEffectTimePosition(CMusicFeatureDescriptor *mfd, TimePositions &tp) = 0; //TBD

	static CAFR** duplicateList(CAFR** list, MDWord cnt);

public:
	MTChar mType[MAX_TYPE_CHAR_COUNT];
};




#endif //endif of   ETAFR_H






