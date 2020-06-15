
@interface QFilterParam : NSObject
//{
//    unsigned int ID;
//    int value;
//}

@property(assign, nonatomic) unsigned int ID;
@property(assign, nonatomic) int value;

-(id)clone;

@end
