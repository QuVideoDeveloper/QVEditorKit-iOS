/*CXiaoYingSession.h
*
*Reference:
*
*Description: Define XiaoYing session API.
*
*/
@protocol AMVESessionStateDelegate <NSObject>
- (MDWord) AMVESessionStateCallBack : (AMVE_CBDATA_TYPE*) pCBData;

@end

@protocol AMVEThemeOptDelegate <NSObject>

- (MRESULT) AMVEThemeOperationCallBack : (AMVE_THEME_OPERATE_TYPE*) pThemeOp;
@end

@interface CXiaoYingSession : NSObject
{
    @protected
    MHandle _hSession;
    MHandle _hAMCM;
    MHandle _hSessionContex;
    id<AMVESessionStateDelegate> _sessionstatehandler;
    id<AMVEThemeOptDelegate> _themeopthandler;
    MBool _bSessionNeedDestroy;
}

@property(readwrite, nonatomic) MHandle hSession;
@property(readonly, nonatomic) id<AMVESessionStateDelegate> sessionstatehandler;
@property(readonly, nonatomic) id<AMVEThemeOptDelegate> themeopthandler;
@property(readonly, nonatomic) MHandle hAMCM;
@property(readonly, nonatomic) MHandle hSessionContex;
@property(readonly, nonatomic) MBool bSessionNeedDestroy;
//@property(readonly, nonatomic) MHandle hSession;

//@property(readonly, nonatomic) AMVE_FNSTATUSCALLBACK* pstatuscallback;


/**
 * Initializes the session.
 * 
 * @param pEngine XiaoYing engine instance.
 * @param statehandler,session state call back handler
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
 

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;


/**
* Destroys the session.
 * 
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) UnInit;

/**
	 * Sets property of the session.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) setProperty : (MDWord) dwPropertyID
	                      Value : (MVoid*) pValue;
/**
	 * Gets property of the session.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) getProperty : (MDWord) dwPropertyID
	                      Value : (MVoid*) pValue;

/**
 * This function is provided for the application to retrieve the operation state of the session, 
 * and update application UI accordingly.
 * @param pState, state struct,session specific
 *        AMVE_PLAYER_STATE_TYPE for player session
 *        AMVE_PRODUCER_STATE_TYPE for producer session
 *        AMVE_DETECTOR_STATE_TYPE for auto cut session.
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) getState : (MVoid*) pState;



@end // CXiaoYingSession



