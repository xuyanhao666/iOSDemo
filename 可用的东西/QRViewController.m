//
//  QRViewController.m
//  iOS自带二维码扫描
//
//  Created by iOS Dev on 14/11/4.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()
{
    NSTimer *_timer;
    UIImageView *_imageView;
    
    UIImageView *_lineImageView;
}
@end

@implementation QRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = YES;
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self initUiConfig];
}


- (void)initUI:(CGRect)previewFrame
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(qrCodeError:)]) {
            [self.delegate qrCodeError:error];
        }
        
        NSLog(@"你手机不支持二维码扫描!");
        return;
    }
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    self.session = [[AVCaptureSession alloc]init];
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame = previewFrame;
    
    [self.view.layer addSublayer:self.preview];
    
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    [self.session startRunning];
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    [self.session stopRunning];
    
    [self.preview removeFromSuperlayer];
    
    NSString *val = nil;
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        val = obj.stringValue;
        
        if ([self.delegate respondsToSelector:@selector(qrCodeComplete:)]) {
            [self.delegate qrCodeComplete:val];
        }
    }    
}



- (void)initUiConfig
{
    [self initUI:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    _imageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 140, self.view.bounds.size.height * 0.5 - 140, 280, 280);
    [self.view addSubview:_imageView];

    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _lineImageView.image = [UIImage imageNamed:@"line.png"];
    [_imageView addSubview:_lineImageView];
    
    
    UIButton *customBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [customBtn setTitle:@"取消" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}



- (void)animation
{
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
    }];
}

- (void)cancelBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
