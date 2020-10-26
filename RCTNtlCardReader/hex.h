@interface hex : NSObject
+(NSData *)hexFromString:(NSString *)cmd;
void StrToHex(unsigned char *pbDest, char *szSrc, unsigned int dwLen);
int filterStr(char *szSrc, unsigned int dwLen);
@end
