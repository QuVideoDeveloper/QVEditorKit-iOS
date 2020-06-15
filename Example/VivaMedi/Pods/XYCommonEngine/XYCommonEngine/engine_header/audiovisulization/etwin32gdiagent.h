#ifndef ET_WIN32_GDI_AGENT_H
#define ET_WIN32_GDI_AGENT_H


#define GDI_AGENT_PROP_NONE			(0)
#define GDI_AGENT_PROP_LINE_COLOR	(1)
#define GDI_AGENT_PROP_LINE_WIDTH	(2)

#define GDI_TEXT_ALIGN_HOR_LEFT		0x00000001
#define GDI_TEXT_ALIGN_HOR_RIGHT		0x00000002
#define GDI_TEXT_ALIGN_HOR_CENTER	0x00000004
#define GDI_TEXT_ALIGN_VER_TOP		0x00000008
#define GDI_TEXT_ALIGN_VER_RIGHT		0x00000010
#define GDI_TEXT_ALIGN_VER_CETNER	0x00000020

class QWin32GDIAgent
{
public:
	QWin32GDIAgent();
	virtual ~QWin32GDIAgent();

	MRESULT Init();
	MVoid	Uninit();
	MRESULT  SetProperty(MDWord dwProp, MVoid *pValue, MDWord dwValueSize);
	MRESULT  GetProperty(MDWord dwProp, MVoid *pValue, MDWord *pdwValueSize);
	
	MRESULT DrawLine(MBITMAP *pBGBmp, MPOINT startPt, MPOINT endPt);
	MRESULT DrawString(MTChar *pszTxt, MRECT txtZone, MDWord dwTxtAlign/*GDI_TEXT_ALIGN_XXX*/);
	MRESULT FillPolygon(MVoid *Points/*win32 POINT struct*/, MDWord dwPtCnt, MDWord dwFillColor/*ABGR*/);
	MRESULT FillRect(MVoid *Rectangle/*win32 Rect struct*/, MDWord dwFillColor/*ABGR*/);

	MRESULT EraseGraphic(MDWord dwColor, MRECT rt);
	MRESULT GetFinalGraphic(MBITMAP *pBmp);

private:
	inline MRESULT	SetMBITMAP(MBITMAP *pBmp, MBool *pbIsNewBmp);
	MRESULT PreparePen();
	MRESULT PrepareFont(MDWord dwFontH);
	MRESULT PrepareBrush(MDWord dwBrushColor);

	MVoid	DrawLine2DebugVariable(MBITMAP *pBGBmp, MPOINT startPt, MPOINT endPt);

private:
	MDWord m_dwLineColor;
	MDWord m_dwLineWidth;

	MBITMAP m_BmpHolder;

	MHandle m_hDC;
	MHandle m_hOldBmp4DC;
	MHandle m_hBITMAP;
	MHandle m_hPen;
	MHandle m_hOldPen;

	MHandle m_hFont;
	MDWord  m_dwFontH;
	MHandle m_hOldFont;

	MHandle m_hBrush;
	MHandle m_hOldBrush;
	MDWord	m_dwBrushColor;
};


#endif
