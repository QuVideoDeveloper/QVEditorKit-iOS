/*----------------------------------------------------------------------------------------------
* This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary and 		
* confidential information. 
* 
* The information and code contained in this file is only for authorized ArcSoft employees 
* to design, create, modify, or review.
* 
* DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
* 
* If you are not an intended recipient of this file, you must not copy, distribute, modify, 
* or take any action in reliance on it. 
* 
* If you have received this file in error, please immediately notify ArcSoft and 
* permanently delete the original and any copy of any file and any printout thereof.
*-------------------------------------------------------------------------------------------------*/

/*
 * File Name:	AMPKPackerHead.h   					
 *
 * Reference:
 *
 * Description: This file define Interface API
 * 
 * History:		09-09-2008 - initial version 
 *
 * CodeReview Log:
 * 
 */


#ifndef	__QVPK_PACKER_HEAD_H__
#define	__QVPK_PACKER_HEAD_H__

#define QVPK_FILE_VERSION_V1		0x00010001 //请注意区分:  QVPK_FILE_VERSION_XX(是对pkg文件本身格式的版本描述)，QVET_TEMPLATE_VERSION是对打包到模板文件里的*.xml版本的描述
#define QVPK_FILE_VERSION_V2		0x00020000


#define QVPK_MD5TYPE_TC				0x00000001	//TC MD5: Template Content MD5
#define QVPK_MD5TYPE_TV				0x00000002	//TV MD5: Template Validity MD5

#define QVPK_ENCRYPT_ARITHMETIC_NONE	0x00000000
#define QVPK_ENCRYPT_ARITHMETIC_SIMPLE	0x00000001

/*
*	QVPK_TEMPLATE_TCMD5_FILEOFFSET
*	QVPK_TEMPLATE_TVMD5_FILEOFFSET
*	1. 这个两个File Offset的具体值是跟 QVET_PACKAGE_HEADER 以及 QVET_TEMPLATE_INFO具体的数据结构有关的
*	2. TCMD5 和 TVMD5 是 QVET_TEMPLATE_INFO 里的重要 成员变量，是模板文件生成后再人为加上去的
*/
#define QVPK_TEMPLATE_TCMD5_FILEOFFSET	(sizeof(QVET_PACKAGE_HEADER)+sizeof(MDWord)*4)		//目前=36
#define QVPK_TEMPLATE_TVMD5_FILEOFFSET  (sizeof(QVET_PACKAGE_HEADER)+sizeof(MDWord)*4+sizeof(MD5ID)) //目前=52



typedef struct 
{
	MDWord dwFileTag;			//'QVPK'
	MDWord dwFileVersion;		
	MDWord dwPackageInfoSize;   //the sample does not include
	MDWord dwFileCount;			  
	MDWord dwReserved;
} QVET_PACKAGE_HEADER;

typedef struct 
{
	MDWord dwEncrypt;	//加密算法， QVPK_ENCRYPT_ARITHMETIC_XXXX
	MDWord dwFileId;	//item id
	MDWord dwFormat;	//jpeg, mp4, 3gp, etc.
	MDWord dwOffset;
	MDWord dwLength;
} QVET_PACKAGE_ITEM_INFO;

typedef struct  
{
	MDWord dwMaxCount;
	MDWord dwUseCount;
	MDWord dwPrevMapOffset;	//前一个表在文件里的位置
	MDWord dwNextMapOffset; //下一个表在文件里的位置
} QVET_PACKAGE_FILE_MAP;

typedef struct
{
	MDWord dwID[4];
}MD5ID, *LPMD5ID;


extern const MByte QVPK_SIMPLE_ENCRPYT_KEY[];
#define QVPK_SIMPLE_ENCRPYT_KEY_LEN		10


/*******************Version v1.x File Special***************************
|-------------------|
| Package Header    |---------------> QVET_PACKAGE_ITEM_INFO
|-------------------|
| Package info      |
|-------------------|
| File_1 info       |-----|
|-------------------|     |
| File_2 info       |     |       
|-------------------|     |---------> QVET_PACKAGE_ITEM_INFO       
| ......            |     |
|-------------------|     | 
| File_n info       |     |
|-------------------|-----|
| File_1 data       |
|-------------------|
| File_2 data       |
|-------------------|
| .......           |
|-------------------|
| File_n data       |
|-------------------|

************************************************************************/

/*******************Version v2.x File Special***************************
|-------------------|
| Package Header    |---------------> QVET_PACKAGE_ITEM_INFO
|-------------------|
| Package info      |
|-------------------|
| File Map 1		|
|-------------------|
| File_1 info       |-----|
|-------------------|     |
| File_2 info       |     |       
|-------------------|     |---------> QVET_PACKAGE_ITEM_INFO       
| ......            |     |
|-------------------|-----|
| File_1 data       |
|-------------------|
| File_2 data       |
|-------------------|
| .......	        |
|-------------------|
| File Map 2		|
|-------------------|
|......             |

************************************************************************/

#endif  // __QVPK_PACKER_HEAD_H__


