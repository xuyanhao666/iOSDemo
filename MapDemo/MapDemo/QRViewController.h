//
//  QRViewController.h
//  iOS自带二维码扫描
//
//  Created by iOS Dev on 14/11/4.
//  Copyright (c) 2014年 语境. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol QRViewControllerDelegate <NSObject>

- (void)qrCodeComplete:(NSString *)codeString;

- (void)qrCodeError:(NSError *)error;



@end


@interface QRViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>


@property(assign,nonatomic)id<QRViewControllerDelegate> delegate;

@property (strong,nonatomic)AVCaptureDevice *device;

@property (strong,nonatomic)AVCaptureMetadataOutput *output;

@property (strong,nonatomic)AVCaptureDeviceInput *input;

@property (strong, nonatomic)AVCaptureSession *session;

@property (strong, nonatomic)AVCaptureVideoPreviewLayer *preview;

@end
