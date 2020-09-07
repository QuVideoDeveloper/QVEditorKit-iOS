/*
 * CXiaoYingTextAdvstyle.h
 *
 *
 * History
 *
 * 2020-05-26 WanHanHe
 * - Init version
 *
 */
/*字幕高级属性参数*/
@interface CXiaoYingMColorRGB : NSObject
{
    MByte _R;
    MByte _G;
    MByte _B;
}
@property(readwrite,nonatomic) MByte R;
@property(readwrite,nonatomic) MByte G;
@property(readwrite,nonatomic) MByte B;
- (id) initWithR : (MByte) r
               G : (MByte) g
               B : (MByte) b;
@end

@interface CXiaoYingTextGradientPoint : NSObject
{
    Float32 _position;
    CXiaoYingMColorRGB* _pColor;
}
@property(readwrite,nonatomic) Float32 position;
@property(readwrite,nonatomic) CXiaoYingMColorRGB* pColor;
@end

@interface CXiaoYingTextGradientStyle : NSObject
{
    Float32 _angle;
    Float32 _scale;
    NSMutableArray <CXiaoYingTextGradientPoint*>* _pTextGradientPoints;
}
@property(readwrite,nonatomic) Float32 angle;
@property(readwrite,nonatomic) Float32 scale;
@property(readwrite,nonatomic) NSMutableArray* pTextGradientPoints;
@end

@interface CXiaoYingTextStorkeItem : NSObject
{
    Float32 _opacity;
    Float32 _size;
    CXiaoYingMColorRGB* _pColor;
}
@property(readwrite,nonatomic) Float32 opacity;
@property(readwrite,nonatomic) Float32 size;
@property(readwrite,nonatomic) CXiaoYingMColorRGB* pColor;
@end

@interface CXiaoYingTextShadowItem : NSObject
{
    Float32 _opacity;
    Float32 _size;
    Float32 _spread;
    Float32 _angle;
    Float32 _distance;
    CXiaoYingMColorRGB* _pColor;
}
@property(readwrite,nonatomic) Float32 opacity;
@property(readwrite,nonatomic) Float32 size;
@property(readwrite,nonatomic) Float32 spread;
@property(readwrite,nonatomic) Float32 angle;
@property(readwrite,nonatomic) Float32 distance;
@property(readwrite,nonatomic) CXiaoYingMColorRGB* pColor;
@end

#define FILL_TYPE_PURE_COLOR  (0)
#define FILL_TYPE_PATH_STROKE  (1)
#define FILL_TYPE_GRIENDT_COLORR  (2)
#define FILL_TYPE_FILL_IMAGE  (3)

@interface CXiaoYingTextAdvanceFill : NSObject
{
    MInt32 _fillType;
    Float32 _opacity;
    CXiaoYingMColorRGB* _pColor;
    Float32 _pathStrokeSize;
    CXiaoYingTextGradientStyle* _pGradient;
    NSMutableString* _pFillImagePath;
}
@property(readwrite,nonatomic) MInt32 fillType;
@property(readwrite,nonatomic) Float32 opacity;
@property(readwrite,nonatomic) CXiaoYingMColorRGB* pColor;
@property(readwrite,nonatomic) Float32 pathStrokeSize;
@property(readwrite,nonatomic) CXiaoYingTextGradientStyle* pGradient;
@property(readwrite,nonatomic) NSMutableString* pFillImagePath;
@end

@interface CXiaoYingTextBoardConfig : NSObject
{
    MBool _showBoard;
    Float32 _boardRound;
    CXiaoYingTextAdvanceFill* _pBoardFill;
}
@property(readwrite,nonatomic) MBool showBoard;
@property(readwrite,nonatomic) Float32 boardRound;
@property(readwrite,nonatomic) CXiaoYingTextAdvanceFill* pBoardFill;
- (MRESULT) ConvertToCBoardConfig : (MVoid*) pBoardConfig
                             Flag : (MBool) bFlag;
@end

@interface CXiaoYingTextAdvStyle : NSObject
{
    CXiaoYingTextAdvanceFill* _pFontFill;
    NSMutableArray <CXiaoYingTextStorkeItem*>* _pStrokes;
    NSMutableArray <CXiaoYingTextShadowItem*>* _pShadows;
}
@property(readwrite,nonatomic) CXiaoYingTextAdvanceFill* pFontFill;
@property(readwrite,nonatomic) NSMutableArray* pStrokes;
@property(readwrite,nonatomic) NSMutableArray* pShadows;
- (MRESULT) ConvertToCAdvStyle : (MVoid*) pAdvStyleParam
                          Flag : (MBool) bFlag;
@end

