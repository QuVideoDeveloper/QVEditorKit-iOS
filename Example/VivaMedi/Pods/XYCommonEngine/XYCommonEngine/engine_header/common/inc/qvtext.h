#ifndef QV_TEXT_H
#define QV_TEXT_H

#include "amcomdef.h"
#include "amdisplay.h"

#ifndef AMVE_MAXPATH
	#if defined (_LINUX_) || (__IPHONE__)
		#define AMVE_MAXPATH 1024
	#elif defined(_WINCE_)
		#define AMVE_MAXPATH 260
	#else
		#define AMVE_MAXPATH 256
	#endif //(_LINUX_)
#endif	//AMVE_MAXPATH


#define QVTEXT_ALIGNMENT_NONE		0x00000000
#define QVTEXT_ALIGNMENT_FREE_STYLE	QVTEXT_ALIGNMENT_NONE
#define QVTEXT_ALIGNMENT_LEFT		0x00000001
#define QVTEXT_ALIGNMENT_RIGHT		0x00000002
#define QVTEXT_ALIGNMENT_TOP		0x00000004
#define QVTEXT_ALIGNMENT_BOTTOM     0x00000008
#define QVTEXT_ALIGNMENT_MIDDLE     0x00000010
#define QVTEXT_ALIGNMENT_HOR_CENTER   0x00000020 //added by jgong: 用于区分之前简单的middle
#define QVTEXT_ALIGNMENT_VER_CENTER   0x00000040 //added by jgong: 用于区分之前简单的middle
#define QVTEXT_ALIGNMENT_HOR_FULLFILL 0x00000080
#define QVTEXT_ALIGNMENT_VER_FULLFILL 0x00000100
#define QVTEXT_ALIGNMENT_UNDER_CENTER 0x00000200
#define QVTEXT_ALIGNMENT_ABOVE_CENTER 0x00000400





typedef struct __tagQVTEXT_DRAW_PARAM
{
	/*
	*	szAuxilliaryFont:
	*		可以为空
	*		iOS 是Font的Family Name
	*		Android 上是一个font文件的完整路径
	*/
	MTChar 		szAuxiliaryFont[AMVE_MAXPATH];


	MBool		bBold;
	//MDWord		dwTxtColor;
	MDWord		dwTxtAlignment; //QVTEXT_ALIGNMENT_XXXX
	MBool		bAutoMultiLine; //false 表示字符串源本身也是单行的
	
	MFloat		fAngle; //AntiClockWise angle
	MRECT		TxtRect;//based on pixel on content bg
	MLong		TxtLineRatio;//扩展功能, 可用于文字着色进度, 基于1/10000;暂时还没启用
	MSIZE		ContentBGSize;//based on pixel ----这是个辅助参数，文字位置的计算会用到这个参数, 这是指文字所相对的bubble BG的尺寸，请与bubble所相对的video frame BG做区分，不要搞混
	//content bg size是指content bmp没有旋转时的尺寸，如果有旋转，旋转后外接矩形框肯定比原来的content bmp大----旋转后代码会做相应处理....
	//TxtRect: 是基于"content bg"，而且是指content bg还没旋转的时候，txt在它上面的位置----
	//		  (旋转后的content bg 是会小于外接矩形的, 代码会做一坨坐标变换的计算.....)
	//		  因此,此变量准确的命名应为TxtRectOnContentBG
	//		  同时务必清楚目前的代码逻辑: 文字旋转后默认是画在以外接矩形为框的bmp里，如果外面传入的bmp比这个外接矩形还大，那是不支持的，会出问题.....

	//all the variable names start with "D" mean it's only UI Design value, 
	//it may be modified by auto-fit-calculation, such as auto-multi-line calculation
	MDWord		dwShadowColor;
	MFloat		fDTxtSize;
	MFloat		fDShadowBlurRadius; //fDShadowBlurRadius: iOS必须>=0; android 上必须 > 0;
	MFloat		fDShadowXShift;
	MFloat		fDShadowYShift;

	//MDWord		dwStrokeColor;
	//MFloat		fStrokeWPercent; //WidthPercent,这个参数是按iOS的定义走的，android要做转换，转换成绝对值
    
	// fill type
	// 0 -> none
    // 1 -> pure color // color from dwTxtColor
    // 2 -> linear gradient
    MDWord dwTxtFillType;//
    struct FillConfig {
        
        // for gradient
        MDWord color0;
        MDWord color1;
		MDWord angle;
		// start point
        //MDWord x0;
        //MDWord y0;
		// stop point
        //MDWord x1;
        //MDWord y1;
        
    } txtFillConfig;
    
	MDWord dwTxtStrokeType;//
    struct StrokeConfig {
        
        // for gradient
        MDWord color0;
        MDWord color1;
		MDWord angle;
		// start point
        //MDWord x0;
        //MDWord y0;
		// stop point
        //MDWord x1;
        //MDWord y1;

		MFloat fWidthPercent;

    } txtStrokeConfig;

	MBool bItalic;
    
}QVTEXT_DRAW_PARAM;



typedef struct __tagQVTE_GLYPH_STYLE
{
    //当调用者作为输入参数时，无需关心dwGStartIdx
	MDWord dwGStartIdx;	//the start index of glyphs which have the same style in string, idx started by 0
	MDWord dwGCount;	//glyph counts which has the same style in string by sequence
	
	MTChar  pszAuxiliaryFont[AMVE_MAXPATH];
	MDWord	dwGColor;
    MFloat  fSizeFactor; //考虑到一段文字的字号可以不同，同时文字又可以缩放----非绝对字号，所以用这个尺寸因子来描述。常规大小取1.0即可
	
	//all the variable names start with "D" mean it's only UI Design value, 
	//it may be modified by auto-fit-calculation, such as auto-multi-line calculation
	MDWord		dwShadowColor;
	MFloat		fDFontSize;
	MFloat		fDShadowBlurRadius; //fDShadowBlurRadius: iOS必须>=0; android 上必须 > 0;
	MFloat		fDShadowXShift;
	MFloat		fDShadowYShift;

	MDWord		dwStrokeColor;
	MFloat		fStrokeWPercent; //WidthPercent,这个参数是按iOS的定义走的，android要做转换，转换成绝对值
	
}QVTE_GLYPH_STYLE;

/*
 *	Definition of Processing Mode:
 */
#define QVTE_AUTO_MULTILINE_AND_AUTO_SCALE		(0x00000001)
#define QVTE_AUTO_MULTILINE_AND_NO_SCALE		(0x00000002)
#define QVTE_SINGLELINE_AND_AUTO_SCALE			(0x00000003)




/*
 *  MDM: Measure and Rendering Mode
 */
#define QVTE_MRM_DEFAULT                        (0x00000000)
#define QVTE_MRM_LINE                           QVTE_MRM_DEFAULT
#define QVTE_MRM_GLYPH_BY_GLYPH                 (0x00000001)


typedef struct __tagQVTE_PARAGRAPH_INFO
{
	MTChar pszText[AMVE_MAXPATH];	//先定义成UTF8，届时底层模块视情况转换

	MDWord dwProcessMode;	//AUTO_MULTILINE_XXX or SINGLELINE
    MDWord dwMRMode;     //QVTE_MRM_XXXXXX
    MFloat fKernPercent; //releated to dwMRMode
    
	MDWord dwAlignMode; //QVTEXT_ALIGNMENT_XXXX
	MSIZE  OriTextSize;	//原先设计时的单行最大尺寸,cy表示的是磅值, cx表示的像素宽度

	QVTE_GLYPH_STYLE *pStyleList;
	MDWord dwStyleCnt;

	MDWord dwMaxLines; //描述处理后最大不能超过的行数，暂时只在QVTE_AUTO_MULTILINE_AND_NO_SCALE模式一下有用
    MDWord dwMaxGCnt;
}QVTE_PARAGRAPH_INFO;


typedef struct __tagQVTE_LINE_INFO
{
	MRECTF LineRect; //based on pixel, corresponding to the Backgroud
	MDWord dwGCnt;	//本行所包含的Glyph count
}QVTE_LINE_INFO;

typedef struct __tagQVTE_PARAGRAPH_MEASURE_RESULT
{
	MSIZE_FLOAT  PGSize;  //PG = paragraph, 测算结果中Paragraph的整体宽高是可能与用来渲染的bmp BGSize的尺寸不一样的，因为BMP考虑到OpenGL的性能，尺寸会使用2的N次方的尺寸；
					//这里指的是Paragraph的实际图形尺寸，PGSize <= BGSize
						   
	MRECTF *pGRectList;	//G =glyph, it's glyph rect info list: it's based on pixel
	MDWord dwGCnt;	//G =glyph

	QVTE_LINE_INFO *pLineInfoList;
	MDWord dwLines;

}QVTE_PARAGRAPH_MEASURE_RESULT;


#ifdef __cplusplus
extern "C" {
#endif



/*
*	QVTextDraw_RotateText()
*		MBITMAP *pBGBmp: this is the BG Bmp which is already rotated, and this function need to rotated text
*/
MRESULT QVTextDraw_RotateText(MBITMAP *pBGBmp, MTChar *pszTxt, QVTEXT_DRAW_PARAM *pTDP);

/*
*	QVTextDraw_RotateBG
*		MBITMAP *pSrcBGBmp: this is the Src BG which has not been rotated, text will be draw to it directly
*		MBITMAP *pOutBmp: this is the dst Bmp which the Src BG is drawn to by the required angle
*/
MRESULT QVTextDraw_RotateBG(MBITMAP *pSrcBGBmp, MTChar *pszTxt, QVTEXT_DRAW_PARAM *pTDP, MBITMAP *pOutBmp);



/*
 *	QVTE_XXXX函数引入的背景:
 *		新产品形态要求文字能够实现单体动画---即每个字都有自己动画。
 *		在这种前提下，新的文字功能与就有文字功能有着质的区别----文字Render模块不能给出一个已经带背景bmp，只能给出一个纯文字的bmp。
 *		后续再由其他模块将单体字的bmp一个个合成到背景bmp上。由此，文字功能上层逻辑将分成"有单体动画"和"整体动画"两种
 *		"整体动画"的功能可以继续沿用之前的代码，"单体动画"功能将走新的代码逻辑
 */


/*
 *	MBool bByOpenGLSize = MTrue 测算结果PGSize是2的N次方，否则就是实际文章渲染大小
 *	此函数有内存分配行为，外部调用者需要负责释放ppResult
 */
//MRESULT QVTE_MeasureGlyphInParagraph(QVTE_PARAGRAPH_INFO *pPGInfo, MBool bByOpenGLSize, QVTE_PARAGRAPH_MEASURE_RESULT **ppResult);


/*
 *	MBool bByOpenGLSize = MTrue 测算结果PGSize是2的N次方，否则就是实际文章渲染大小
 *	此函数有内存分配行为，外部调用者需要负责释放pResult和pBmp
 */
MRESULT QVTE_GenerateParagraphBmp(QVTE_PARAGRAPH_INFO *pPInfo, MBool bByOpenGLSize, QVTE_PARAGRAPH_MEASURE_RESULT *pPMR/*out*/, MBITMAP *pBmp/*out*/);

/*
 *	QVTE_ReleaseParagraphMeasureResult: 工具函数
 */
MVoid QVTE_ReleaseParagraphMeasureResult(QVTE_PARAGRAPH_MEASURE_RESULT *pResult);

MDWord QVTE_GetStringGlyphCount(MTChar *pszTxt);

/*
 *  QVTE_GetStringGlyphCountEx:
 *      MTChar *pszFont: iOS上是FontName， Android上是TTF的文件路径
 *
 */
MDWord QVTE_GetStringGlyphCountEx(MTChar *pszTxt, MTChar *pszFont);
    
    

/*
 *
 */
MHandle QVTE_TextRendererCreate(QVTE_PARAGRAPH_INFO *pPInfo);

MRESULT QVTE_TextRendererProcess(MHandle hTR);
    
MBITMAP* QVTE_TextRendererGetBmp(MHandle hTR);

QVTE_PARAGRAPH_MEASURE_RESULT *QVTE_TextRendererGetMeasureResult(MHandle hTR);
    
MVoid QVTE_TextRendererDestroy(MHandle hTR);

MRESULT QVTE_ConvertToUTF8Str(MTChar* pszStr,MTChar** ppszUTF8Str);
    
#ifdef __cplusplus
}
#endif
    
#endif
