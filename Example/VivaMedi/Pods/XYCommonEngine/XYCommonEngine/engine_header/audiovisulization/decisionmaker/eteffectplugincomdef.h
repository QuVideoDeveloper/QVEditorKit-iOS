/**
* @author  Jonathan
*
* @version  v1.0
*
* @history	init version - 02.25.2018
**/


#ifndef ETEFFECTPLUGINCOMDEF_H
#define ETEFFECTPLUGINCOMDEF_H

#include "amvedef.h"

#define TO_IMPLEMENT
#define UNSUPPORT		(-2)



#define MAX_TYPE_CHAR_COUNT	32


#define REQUIREMENT_TYPE_SBJ			"RT_SBJ"
#define REQUIREMENT_TYPE_OBJ_NAR		"RT_Obj_NAR"
#define REQUIREMENT_TYPE_OBJ_AR			"RT_Obj_AR"


//AF= audio feature
#define AF_REQUIREMENT_TYPE_ONSET				"AFRT_onset"
#define AF_REQUIREMENT_TYPE_VOLUME		  	"AFRT_volume"
#define AF_REQUIREMENT_TYPE_HEAVY_BEAT		"AFRT_heavy_beat"


//typedef struct __tagTIME_POSITIONS
//{
//	MDWord *start;
//	MDWord *len;
//	MDWord cnt;
//	MDWord capacity;
//}TIME_POSITIONS;

class TimePositions
{
public:
	TimePositions();
	TimePositions(MDWord capacity);	
	TimePositions(const TimePositions& old);

	virtual ~TimePositions();
	
	TimePositions& operator =(const TimePositions& other);

	MVoid addTime(MDWord start, MDWord len);

	MDWord *start;
	MDWord *len;
	MDWord cnt;
	MDWord capacity;
};



#endif //endif of ETEFFECTPLUGINCOMDEF_H

