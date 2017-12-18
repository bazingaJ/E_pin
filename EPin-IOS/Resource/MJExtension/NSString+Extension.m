

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}
-(CGSize)sizeWithFont:(UIFont *)font With:(CGFloat)with{
    CGSize size = CGSizeMake(with, MAXFLOAT);//限制文字显识的一个区域
    NSDictionary *att = @{NSFontAttributeName : font};//文字显示的属性
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];//计算出文字显示需要的大小
    return rect.size;
}

@end
