//
//  ViewController.h
//  textReader
//
//  Created by Tong Liu on 21/08/2019.
//  Copyright © 2019 Tong Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropView.h"
#import "CameraViewController.h"

@interface ViewController : UIViewController <cameraVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCropViewControllerDelegate>
//@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

