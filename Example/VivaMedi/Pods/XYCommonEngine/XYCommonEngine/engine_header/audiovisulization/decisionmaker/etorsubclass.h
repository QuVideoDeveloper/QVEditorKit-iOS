/**
 * @author  Jonathan
 *
 * @version  v1.0
 *
 * @history init version - 02.26.2018
 **/



#ifndef ETORSUBCLASS_H
#define ETORSUBCLASS_H



class COR;
class CAFR;

class CORAR : public COR	//AR=audio related
{
public:
	CORAR();
	virtual ~CORAR();

	virtual COR* duplicate();
	TO_IMPLEMENT virtual MRESULT match(CMusicFeatureDescriptor *mfd, MVoid* otherInfo, TimePositions &tp/*in, out*/);

protected:
	MVoid uninit();

public:
	CAFR**	mAFRList;
	MDWord  mAFRCnt;
};






class CORNAR : public COR			//NAR=non-audio related
{
public:
	CORNAR();
	virtual ~CORNAR();

	virtual COR* duplicate();
	TO_IMPLEMENT virtual MRESULT match(CMusicFeatureDescriptor *mfd, MVoid* otherInfo, TimePositions &tp/*in, out*/);

public:
	MDWord mStartPos;
//	MDWord mOffset; //or it can be defined as range

};













#endif //endif of ETORSUBCLASS_H



