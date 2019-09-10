//
//  ViewController.m
//  textReader
//
//  Created by Tong Liu on 21/08/2019.
//  Copyright © 2019 Tong Liu. All rights reserved.
//

#import "ViewController.h"

//#import <AVFoundation/AVFoundation.h>
@import FirebaseMLVision;

@interface ViewController () 

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextView *textfield;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) FIRVisionTextRecognizer *textRecognizer;

//@property (nonatomic) AVCaptureSession *captureSession;
//@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
//@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation ViewController

-(void)setImage:(UIImage *)image{
    self.img.image = image;
//    NSLog(@"here is the data %@",aStr);
//    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
//    controller.delegate = self;
//    controller.blurredBackground = YES;
//    [[self navigationController] pushViewController:controller animated:YES];
    [self translateImage:image];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textview.text = @"";
    
    UIImage *img = [[UIImage alloc] init];
    img = [UIImage imageNamed:@"fword.jpg"];
    self.img.image = img;
    // Do any additional setup after loading the view.
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    FIRVision *vision = [FIRVision vision];
    self.textRecognizer = [vision onDeviceTextRecognizer];
    [self translateImage:img];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Attention"
                                     message:@"Device has no camera"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil ];

//    self.captureSession = [AVCaptureSession new];
//    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
//    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if (!backCamera) {
//        NSLog(@"Unable to access back camera!");
//        return;
//    }
//
//    NSError *error;
//    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera
//                                                                        error:&error];
//    if (!error) {
//        //Step 9
//    }
//    else {
//        NSLog(@"Error Unable to initialize back camera: %@", error.localizedDescription);
//    }
//    self.stillImageOutput = [AVCapturePhotoOutput new];
//
//    if ([self.captureSession canAddInput:input] && [self.captureSession canAddOutput:self.stillImageOutput]) {
//
//        [self.captureSession addInput:input];
//        [self.captureSession addOutput:self.stillImageOutput];
//        [self setupLivePreview];
//    }
//
    
    
}

-(void)handleNotification:(NSNotification *)message {
    NSLog(@"DETECTED!!!");
    if ([[message name] isEqualToString:@"_UIImagePickerControllerUserDidCaptureItem"]) {
        // Remove overlay, so that it is not available on the preview view;
        self.picker.cameraOverlayView = nil;
        NSLog(@"DETECTED 2222!!!");
//        [self.picker.ima
//        [self.picker dismi bssViewControllerAnimated:YES completion:NULL];
    }
//    if ([[message name] isEqualToString:@"_UIImagePickerControllerUserDidRejectItem"]) {
//        // Retake button pressed on preview. Add overlay, so that is available on the camera again
//        self.picker.cameraOverlayView = [self addCameraRollButton];
//    }
}

//- (UIView *)addCameraRollButton {
//    float startY = ([[UIScreen mainScreen] bounds].size.height == 568.0) ? 500.0 : 410.0;
//
//    UIButton *rollButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rollButton.frame = CGRectMake(230.0, startY, 60.0, 60.0);
//    rollButton.backgroundColor = [UIColor clearColor];
//
//    [rollButton setImage:self.lastTakenImage forState:UIControlStateNormal];
//    rollButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//    [rollButton addTarget:self action:@selector(prepareCameraRoll) forControlEvents:UIControlEventTouchUpInside];
//
//    return rollButton;
//}


-(void)dismissKeyboard {
    [self.textfield resignFirstResponder];
}

- (IBAction)takePhoto:(id)sender {
    
//    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:NULL];
}

- (IBAction)cropImage:(id)sender {
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:self.img.image];
    controller.delegate = self;
    controller.blurredBackground = YES;
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    self.img.image = croppedImage;
    [self translateImage:croppedImage];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.img.image = chosenImage;
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:chosenImage];
    controller.delegate = self;
    controller.blurredBackground = YES;
    [[self navigationController] pushViewController:controller animated:YES];
    [self translateImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)translateImage:(UIImage *)chosenImage{
    FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:chosenImage];
    [self.textRecognizer processImage:image
                           completion:^(FIRVisionText *_Nullable result,
                                        NSError *_Nullable error) {
                               if (error != nil || result == nil) {
                                   // ...
                                   return;
                               }
                               
                               NSString *resultText = result.text;
                               self.textview.text = resultText;
                               // Recognized text
                           }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cameraSegue"]) {
        CameraViewController *sv = (CameraViewController *)segue.destinationViewController;
        if ([sv respondsToSelector:@selector(setDelegate:)]) {
            sv.delegate=self;
        }else{
            NSLog(@"Warning coming view controller info not found");
        }
    }
}



@end
