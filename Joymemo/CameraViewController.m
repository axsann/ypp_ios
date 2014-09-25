//
//  CameraViewController.m
//  CameraTest01
//
//  Created by 天野 裕介 on 2013/02/21.
//  Copyright (c) 2013年 天野 裕介. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //カメラを起動
    [self kickCamera];
}

//カメラを起動
- (void)kickCamera
{
    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc] init];
    
    //カメラ機能を選択
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePickerController.delegate = self;
    
    //YESにしないと、UIImage(カメラで撮ったデータ) が取得できない
    imagePickerController.allowsEditing = YES;
    
    //モーダルビューでカメラ起動
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//カメラ撮影後のデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //撮ったデータをUIImageにセットする
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //追加箇所 by白浜 アップロード
    [self postMultiData:image];
    
    //カメラロールに画像を保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingImage:didFinishSavingWithError:contextInfo:), nil);
    
    //モーダルビューを消す
    [self dismissViewControllerAnimated:YES completion:nil];
}

//画像保存完了後。非同期で呼ばれる
- (void) didFinishSavingImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //画像保存完了したよ、とアラートを出す
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"保存完了"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


// 追加箇所 by 白浜 from
// http://chicketen.blog.jp/archives/1282033.html

- (void)postMultiData:(UIImage *)image
{
    NSURL* url = [NSURL URLWithString:@"http://ec2-54-64-76-200.ap-northeast-1.compute.amazonaws.com/images/add_images"];
    //NSURL* url = [NSURL URLWithString:@"http://www.akg.t.u-tokyo.ac.jp/~shirahama/test/upload.php"];
    NSString* boundary = @"MyBoundaryString";
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders =
    @{
      @"Content-Type" : [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
      };
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    // アップロードする画像
    //NSString* path = [[NSBundle mainBundle] pathForResource:@"sample1" ofType:@"jpg"];
    //NSData* imageData = [NSData dataWithContentsOfFile:path];
    NSData * imageData = UIImageJPEGRepresentation( image,0.3 );
    
    // postデータの作成
    NSMutableData* data = [NSMutableData data];
    
    // テキスト部分の設定
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", @"3F66970F-C960-4EF9-A499-DE780546AD64"] dataUsingEncoding:NSUTF8StringEncoding]];
    

    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"item_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"%@\r\n", @"977859899"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 画像の設定
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"upfile"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", @"sample3.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:imageData];
    [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 最後にバウンダリを付ける
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                // 完了時の処理
                                                NSLog(@"%@", [error localizedDescription]);
                                            }];
    
    
    [task resume];
}

@end
