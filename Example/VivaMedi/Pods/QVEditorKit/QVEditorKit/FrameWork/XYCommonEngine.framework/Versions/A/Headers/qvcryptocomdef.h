#ifndef QVCRYPTOCOMDEF_H
#define QVCRYPTOCOMDEF_H


#define AES_DEFAULT_KEY			"EB8DC4E3D6AA025F"
#define AES_DEFAULT_HEAD		"QVCTCDH"


typedef struct __tagENC_DATA
{
    MByte *data;
    MDWord dataLen;
}ENC_DATA;

typedef struct __tagAES_KEY_DESCRIPTION
{
	MDWord version;
	MTChar *keyName;
	MTChar *key;
}AES_KEY_DESCRIPTION;




#define QVCT_CHECK_POINTER_GOTO(p, err)	\
		if (!(p))	{ res = (err); goto FUN_EXIT;	}

#define QVCT_SET_ERR_GOTO(err)	\
		{res = (err); goto FUN_EXIT;}




#endif //endif of QVCRYPTOCOMDEF_H
