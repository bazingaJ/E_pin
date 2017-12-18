

#import "FileHander.h"

@implementation FileHander

/*
 *获取LibraryDirectory 文件夹目录
 */
-(NSString *)getPath{
    NSString *FilePath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    return FilePath;
}
/*
 * @pragma  根据文件路径判断文件夹是否存在，如果存在返回yes，
 *          不存在创建自动创建创建文件夹，创建失败返回NO
 * filePath 文件路径
 * return   yes 成功，NO 失败
 */
-(NSString *)getDirectoryForname:(NSString *)DirName{
  //拼装文件夹路径
    NSString *direcPath=[[self getPath] stringByAppendingPathComponent:DirName];
  //创建文件夹
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:direcPath withIntermediateDirectories:YES attributes:0 error:&error]) {
        NSLog(@"====%@",error);
        return nil;
      }
    //返回文件路径
    return direcPath;
}
/*
 * @pragma 根据文件路径判断文件是否存在，如果存在返回yes，
 *          不存在创建自动创建文件，创建失败返回NO
 *  filePath 文件路径
 *  return yes 成功，NO 失败
 */
-(BOOL)getFilePath:(NSString *)filePath{
    //文件管理器对象
    NSFileManager *manger=[NSFileManager defaultManager];
    //判断文件是否存在
    if (![manger fileExistsAtPath:filePath]) {
     //创建文件
        if (![manger createFileAtPath:filePath contents:nil attributes:0]) {
            NSLog(@"=====失败");
            return NO;
        }
    }
    //返回文件路径
    return YES;
}
/*
 *创建单例对象
 */
+(instancetype)shardFileHand{
    static dispatch_once_t once;
    static FileHander *hander;
    dispatch_once(&once, ^{
        hander=[FileHander new];
    });
    return hander;
}


-(BOOL)saveFile:(NSDictionary *)file withForName:(NSString *)fileName
      withError:(NSString**)error{
    //文件路径
    NSString *filePath=[[self getPath] stringByAppendingPathComponent:fileName];
   BOOL isExist=[self getFilePath:filePath];
    
  //把文件写入本
    if (isExist) {
        //写入本地
        if (![file writeToFile:filePath atomically:YES]) {
            NSString *info=@"cuowu";
            *error=info;
            return NO;
           
        };
    }else{
        NSString *info=@"cuowu";
        *error=info;
        return NO;
    }
    return YES;
}


-(BOOL)saveFile:(NSDictionary *)file withForName:(NSString *)fileName withDirName:(NSString *)DirName withError:(NSError**)error{
  //获取文件夹路径
    NSString *dirPath=[self getDirectoryForname:DirName];
    if (dirPath) {
     //创建文件路径
        NSString *filePath=[dirPath stringByAppendingPathComponent:fileName];
       //判断文件是否存在
        BOOL isexist=[self getFilePath:filePath];
        if (isexist) {
            if(![file writeToFile:filePath atomically:YES]){
                return NO;
            }
            return YES;
        }else{
            return NO;
        }
    }
     return NO;
}

-(NSDictionary *)readFile:(NSString *)fileName{
    //文件路径
     NSString *filePath=[[self getPath] stringByAppendingPathComponent:fileName];
    //返回读取的数据
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}
-(NSDictionary *)readFile:(NSString *)fileName WithForDirName:(NSString *)direName{
    //文件夹路径
    NSString *direPath=[[self getPath]stringByAppendingPathComponent:direName];
    //文件路径
    NSString *filePath=[direPath stringByAppendingPathComponent:fileName];
    //返回读取的数据
    return [[NSDictionary alloc] initWithContentsOfFile:filePath];
}


-(BOOL)saveImage:(NSData *)data imageWithName:(NSString *)imageName{
  //文件路径
    NSString *filePath=[[self getPath] stringByAppendingPathComponent:imageName];
   //判断文件路径是否存在
    if ([self getFilePath:filePath]) {
    //写入操作
        if ([data writeToFile:filePath atomically:YES]){
          return YES;
          }
        return NO;
    }
    return NO;
}
-(BOOL)saveImage:(NSData *)data imageWithName:(NSString *)imageName WithForDirName:(NSString *)direName{
   //文件夹路径
    NSString *dirPath=[self getDirectoryForname:direName];
    if (!dirPath) {
        NSLog(@"====文件夹创建失败");
        return NO;
    }
    //文件路径
    NSString *filePath=[dirPath stringByAppendingPathComponent:imageName];
    
    //判断文件路径是否存在
    if(![self getFilePath:filePath]){
        NSLog(@"====文件创建失败");
        return NO;
    }
    
    if(![data writeToFile:filePath atomically:YES]){
        NSLog(@"====文件写入失败");
        return NO;
    }
    return YES;
}
-(NSData *)readImage:(NSString *)imageName{
    //文件路径
    NSString *filePath=[[self getPath] stringByAppendingPathComponent:imageName];
    //读取文件
    return [[NSData alloc] initWithContentsOfFile:filePath];
}

-(NSData *)readImage:(NSString *)imageName WithForDirName:(NSString *)direName{
 //获取文件夹路径
    NSString *dirPath=[self getDirectoryForname:direName];
 //文件路径
    NSString *filePath=[dirPath stringByAppendingPathComponent:imageName];
 //读取文件
  return [[NSData alloc] initWithContentsOfFile:filePath];
}

@end
