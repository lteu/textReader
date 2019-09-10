//
//  ViewController.h
//  avCamera
//
//  Created by Tong Liu on 08/09/2019.
//  Copyright © 2019 Tong Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "ImageCropView.h"

@protocol cameraVCDelegate <NSObject>

-(void)setImage:(UIImage *)anImage; //I am thinking my data is NSString, you can use another object for store your information.

@end


@interface CameraViewController : UIViewController <AVCapturePhotoCaptureDelegate,ImageCropViewControllerDelegate>

@property(nonatomic,strong) id<cameraVCDelegate> delegate;
//@property(nonatomic,strong) NSString *cool;
//-(void) a;
//- (void)setImage:(UIImage*)image;
@end

