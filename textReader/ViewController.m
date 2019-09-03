//
//  ViewController.m
//  textReader
//
//  Created by Tong Liu on 21/08/2019.
//  Copyright © 2019 Tong Liu. All rights reserved.
//

#import "ViewController.h"
@import FirebaseMLVision;

@interface ViewController () 

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UITextView *textfield;
@property (strong, nonatomic) FIRVisionTextRecognizer *textRecognizer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textview.text = @"new text";
    
    UIImage *img = [[UIImage alloc] init];
    img = [UIImage imageNamed:@"fword.jpg"];
    self.img.image = img;
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    FIRVision *vision = [FIRVision vision];
    self.textRecognizer = [vision onDeviceTextRecognizer];
    FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:img];
    
    
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
    
}

-(void)dismissKeyboard {
    [self.textfield resignFirstResponder];
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)cropImage:(id)sender {
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:self.img.image];
    controller.delegate = self;
    controller.blurredBackground = YES;
//    // set the cropped area
//    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    self.img.image = croppedImage;
    [self translateImage:croppedImage];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
//    self.img.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.img.image = chosenImage;
    
    
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:chosenImage];
    controller.delegate = self;
    controller.blurredBackground = YES;
    controller.cropArea = CGRectMake(0, 0, 100, 200);
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


@end
