#ifndef _ETTEXT_PARAM_DEF_
#define _ETTEXT_PARAM_DEF_

#include "amcomdef.h"
#include<vector>
#include<string>
struct MCOlORRGB {
	MByte R,G,B;
};

struct QEVTTextGradientPoint {
	MFloat position;//[0~1]; 
	MCOlORRGB color;
};

struct QEVTTextGradientStyle {
	MFloat angle;// anticlockwise ratate [0-360°]  show horizontal gradient(angle==0°) and colorpoint(position==0) in left
	MFloat scale;// [0.1~1.5] less make colors closer
	std::vector<QEVTTextGradientPoint> colors; //rgb color points count range [2~20];
	QEVTTextGradientStyle() :angle(-90.0f), scale(1.0f) {
		colors.resize(2, { 0 });
		colors[1] = { 1,{0xFF,0xFF,0xFF} };
	}
};

struct QEVTTextStrokeItem {
	MFloat opacity;//[0 - 1]
	MCOlORRGB color;
	MFloat size;//[0-1.0]
};

struct QEVTTextShadowItem {
	MFloat opacity;//[0 - 1]
	MCOlORRGB color;
	MFloat size;//[0-1.0]
	MFloat spread;//[0-1] show same as stroke when spread==1
	MFloat angle;
	MFloat distance;
};



struct QTextAdvanceFill {

	enum class FillType :MInt32
	{
		PURE_COLOR = 0, //save field: fillColor
		PATH_STROKE = 1, //save field: fillColor PathStrokeSize
		GRIENDT_COLOR = 2, //save field: Gradient
		FILL_IMAGE = 3 //save field: FillIamgeRef
	};

	FillType Type;
	MFloat Opacity;//[0-1]

	MCOlORRGB FillColor;// 
	MFloat PathStrokeSize;//use it when type == PATH_STROKE（路径描边镂空效果）
	QEVTTextGradientStyle Gradient;//use it when type == GRIENDT_COLOR(渐变颜色)
	std::string FillImagePath; //use it when type == FILL_IMAGE(填充纹理来自路径)
	QTextAdvanceFill() :Type(FillType::PURE_COLOR), Opacity(1.0f), PathStrokeSize(0.0f), FillColor({ 0xFF,0xFF,0xFF }), Gradient(), FillImagePath("") {}
};

struct QTextBoardConfig {
	MBool showBoard;
	MFloat boardRound; //[0 - 1]
	QTextAdvanceFill boardFill;
	QTextBoardConfig() :showBoard(MFalse), boardRound(0), boardFill() {}
};



struct QTextAdvanceStyle
{
	QTextAdvanceFill fontFill;

	std::vector<QEVTTextStrokeItem> strokes;
	std::vector<QEVTTextShadowItem> shadows;
	
	QTextAdvanceStyle() :fontFill(), strokes(0), shadows(0){}

};


#endif
