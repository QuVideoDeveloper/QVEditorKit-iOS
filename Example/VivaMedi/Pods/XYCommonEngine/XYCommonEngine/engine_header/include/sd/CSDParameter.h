
@interface CSDParameter : NSObject



@property(readwrite, nonatomic)   NSString* song;

@property(assign, nonatomic)  int refBGMStartPos;
@property(assign, nonatomic)  int refBGMEndPos;
@property(assign, nonatomic)  int detectStartPos;
@property(assign, nonatomic)  int detectEndPos;
@property(assign, nonatomic)  int maxGap;
@property(assign, nonatomic)  int maxLength;
@property(assign, nonatomic)  int minLength;


@property(assign, nonatomic)   id <ISDDelegate> delegate;


@end
