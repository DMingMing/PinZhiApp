//
//  ScanningViewController.m
//  PinZhiApp
//
//  Created by MingMing on 16/12/21.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "ScanningViewController.h"
#import <ZBarSDK.h>
#import <SDAutoLayout.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanningViewController ()<ZBarReaderViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL torchIsOn;
    ZBarCameraSimulator*cameraSim;
    ZBarReaderView *readerview;
}
@end

@implementation ScanningViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setScanView];
    
   
}
#pragma mark----------------------二维码扫描区域的创建
- (void)setScanView
{
    //创建扫描区域
    readerview = [[ZBarReaderView alloc]init];
    readerview.frame = CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height-20);
    readerview.readerDelegate = self;
    readerview.userInteractionEnabled = YES;
    [self.view addSubview:readerview];
    
    //返回主页面的按钮
    UIButton* buttonScn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonScn setBackgroundImage:[UIImage imageNamed:@"pinBack_normal"] forState:UIControlStateNormal];
    [buttonScn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [readerview addSubview:buttonScn];
    buttonScn.sd_layout
    .leftSpaceToView(readerview,10)
    .topSpaceToView(readerview,10)
    .heightIs(readerview.bounds.size.width*0.1)
    .widthEqualToHeight();
    
    //底部闪光灯
    UIButton* buttonflash = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonflash setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [buttonflash addTarget:self action:@selector(LightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [readerview addSubview:buttonflash];
    buttonflash.sd_layout
    .leftSpaceToView(readerview,readerview.bounds.size.width/2-readerview.bounds.size.width*0.2/2)
    .bottomSpaceToView(readerview,readerview.bounds.size.width*0.06)
    .heightIs(readerview.bounds.size.width*0.26)
    .widthIs(readerview.bounds.size.width*0.2);
    
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerview;
    }
    [readerview start];
    
    
}

#pragma mark----------------------读取二维码内容
//实现代理方法 进行读取二维码的内容
- (void)readerView: (ZBarReaderView*) readerView
    didReadSymbols: (ZBarSymbolSet*) symbols
         fromImage: (UIImage*) image{
    for(ZBarSymbol *sym in symbols) {
        
        NSString *code = sym.data;
        //在这解析 获取信息之后 将model传入下一个展示页面 判断进入那个页面
        if (!code) {
            
        }else{
            //扫描到内容之后就发送通知 给前面的页面进行页面内容的更换
            [[NSNotificationCenter defaultCenter]postNotificationName:@"scanCode" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:code,@"code", nil]];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        break;
    }
    
}

#pragma mark----------------------开启闪光灯功能
- (void) turnTorchOn: (bool) on {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}








#pragma mark----------------------点击闪光灯按钮进行开关
-(void)LightBtnClick:(UIButton*)button{
    button.selected = !button.selected;
    if (button.selected) {
        [button setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
    [self turnTorchOn:button.selected];
}
#pragma mark----------------------点击扫描返回按钮
-(void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
