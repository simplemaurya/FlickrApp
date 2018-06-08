//
//  ShowFullImage.m
//  AppFlickr
//
//  Created by Sword Software on 12/01/18.
//  Copyright © 2018 Sword Software. All rights reserved.
//

#import "ShowFullImage.h"

@interface ShowFullImage ()
@property (weak, nonatomic) IBOutlet UIImageView *largeImage;

@end

@implementation ShowFullImage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    UIImage *imgv = [UIImage imageWithData:self.data];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    img.image = imgv;
   
    [self.view addSubview:img];
//    [self.largeImage setImage:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
