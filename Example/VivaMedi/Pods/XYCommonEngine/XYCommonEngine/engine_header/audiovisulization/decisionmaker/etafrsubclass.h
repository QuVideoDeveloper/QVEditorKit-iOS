/**
* @author  Jonathan
*
* @version  v1.0
*
* @history	init version - 02.26.2018
**/


class CAFR;

class CAFRVolume : public CAFR
{
public:
	CAFRVolume();
	virtual ~CAFRVolume();


	virtual CAFR* duplicate();
	virtual MRESULT locateEffectTimePosition(CMusicFeatureDescriptor *mfd);


public:
	MFloat mMax;
	MFloat mMin;
};


class CAFRHeavyBeat : public CAFR
{
public:
	CAFRHeavyBeat();
	virtual ~CAFRHeavyBeat();

	virtual CAFR* duplicate();
	virtual MRESULT locateEffectTimePosition(CMusicFeatureDescriptor *mfd);

public:
	MFloat mThreshold;

};




