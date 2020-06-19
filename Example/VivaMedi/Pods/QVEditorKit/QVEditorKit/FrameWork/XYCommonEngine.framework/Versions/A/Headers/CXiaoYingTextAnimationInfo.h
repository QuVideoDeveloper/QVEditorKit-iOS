/*CXiaoYingTextAnimationInfo.h
*
*Reference:
*
*Description: Define XiaoYing text animation info API.
*
*/

@interface CXiaoYingTextAnimationInfo : NSObject
{
    UInt32 _muiPosition;   //文字在storyboard中的预览时间点
    NSString* _mpStrText;  //当前文字
    NSString* _mpStrDefText; //模板中默认文字
    UInt32 _muiParamID; //对应的effect param id
    UInt32 _muiTextEditable; //文字编辑属性
    UInt32 _muiAlignment; //文字对齐属性
    NSString* _mpStrFontPath; //字体文件路径
    Float32 _mfFontSize; //字体大小
    UInt32 _muiFontColor; //字体颜色
    BOOL _mbStoryboardTA; //是否属于storyboard ta effect
    UInt32 _muiIndex; //如果是storyboard上得TA effect,则表示effect index,否则表示secene clip index
     UInt64 _mlllTemplateID;
    CXIAOYING_RECT _mRegion; //文字显示区域
    
}

@property(readonly, nonatomic) UInt32 muiPosition;
@property(readwrite, nonatomic,strong) NSString* mpStrText;
@property(readonly, nonatomic) NSString* mpStrDefText;
@property(readonly, nonatomic) UInt32 muiParamID;
@property(readonly, nonatomic) UInt32 muiTextEditable;
@property(readonly, nonatomic) UInt32 muiAlignment;
@property(readonly, nonatomic) NSString* mpStrFontPath;
@property(readonly, nonatomic) Float32 mfFontSize;
@property(readonly, nonatomic) UInt32 muiFontColor;
@property(readonly, nonatomic) BOOL mbStoryboardTA;
@property(readonly, nonatomic) UInt32 muiIndex;
@property(readonly, nonatomic) UInt64 mlllTemplateID;
@property(readwrite,nonatomic) CXIAOYING_RECT mRegion;


- (id) initWithTASource : (AMVE_TEXTANIMATION_SOURCE_TYPE*) pTASource
         IsStoryboardTA : (BOOL) bStoryboardTA
                  Index : (UInt32) uiIndex;


//设置字体
- (SInt32) SetFont : (NSString*) pStrFont;

//设置字体大小
- (SInt32) SetFontSize : (Float32) fFontSize;

//设置文字颜色
- (SInt32) SetfontColor : (UInt32) uiFontColor;

-(MRESULT)TextAnimationInfo:(AMVE_TEXTANIMATION_SOURCE_TYPE *)pTASource From:(bool)biOSToC;
@end // CXiaoYingTextAnimationInfo 


