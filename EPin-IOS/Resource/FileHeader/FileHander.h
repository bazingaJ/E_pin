

#import <Foundation/Foundation.h>

@interface FileHander : NSObject

+(instancetype)shardFileHand;
/*
 * @pragma 文件存储
 * file 存储文件对象 
 * fileName 存储文件的名称
 * error: 错误信息
 * return BOOL YES成功 NO 存储失败
 * 文件存储默认存在libar目录下
 */
-(BOOL)saveFile:(NSDictionary *)file withForName:(NSString *)fileName
    withError:(NSString**)error;
/*
 * @pragma 文件存储
 * file 存储文件对象
 * fileName 存储文件的名称
 * DirName 文件夹名称，文件夹放在libr下  dirname不能为空 文件存储DireName下
 * error: 错误信息
 * return BOOL YES成功 NO 存储失败
 */
-(BOOL)saveFile:(NSDictionary *)file withForName:(NSString *)fileName withDirName:(NSString *)DirName withError:(NSError**)error;
/*
 * pragma   文件读取操作
 * fileName 存储的文件名称
 * return   NSDictionary 字典类型
 */
-(NSDictionary *)readFile:(NSString *)fileName;
/*
 * pragma   文件读取操作
 * fileName 存储的文件名称
 * direName 文件存储的文件夹名称
 * return   NSDictionary 字典类型
 */
-(NSDictionary *)readFile:(NSString *)fileName WithForDirName:(NSString *)direName;
/*
 * @pragma 图片存储
 * data   图片对象
 * imageName 图片存储的名称
 * return BOOL YES成功 NO 存储失败
 * 文件存储默认存在libar目录下
 */
-(BOOL)saveImage:(NSData *)data imageWithName:(NSString *)imageName;
/*
 * @pragma 图片存储
 * data   图片存储对象
 * imageName 图片存储的名称
 * DirName 文件夹名称，文件夹放在libr下  dirname不能为空 文件存储DireName下
 * return BOOL YES成功 NO 存储失败
 */
-(BOOL)saveImage:(NSData *)data imageWithName:(NSString *)imageName WithForDirName:(NSString *)direName;
/*
 * @pragma 图片读取操作
 * imageName 图片存储的名称
 * return NSData 对象
 */
-(NSData *)readImage:(NSString *)imageName;
/*
 * @pragma 图片读取操作
 * imageName 图片存储的名称
 * DirName 文件夹名称，文件夹放在libr下  dirname不能为空 文件存储DireName下
 * return NSData 对象
 */
-(NSData *)readImage:(NSString *)imageName WithForDirName:(NSString *)direName;

@end
