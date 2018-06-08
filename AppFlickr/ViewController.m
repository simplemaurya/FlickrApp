//
//  ViewController.m
//  AppFlickr
//
//  Created by Sword Software on 09/01/18.
//  Copyright © 2018 Sword Software. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"
#import "ShowFullImage.h"

@interface ViewController ()
{  // UITableView *tableView;
    
    NSMutableArray *smallImage;
    NSMutableArray *largeImageURL;
    NSMutableArray *photoTitles;
    
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
//@property (strong, nonatomic) NSMutableArray *photoTitles;
- (IBAction)showButton:(UIButton *)sender;
@end

@implementation ViewController
NSString *const APIKey = @"f36dc4a0eb32c67066aa9149c68c426a";

//-(id)init{
//    if(self = [super init])
//    {
//    }
//    return self;
//}

-(void)searchFlickrPhotos:(NSString*)text{
    //NSLog(@"hiiii");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=20&format=json&nojsoncallback=1",APIKey,text]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self.tableView reloadData];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Jsonstring :%@",jsonString);
    NSDictionary *results = [jsonString JSONValue];
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    for(NSDictionary *photo in photos)
    {
        NSString *title = [photo objectForKey:@"title"] != nil && ![[photo objectForKey:@"title"] isEqualToString:@""]?[photo objectForKey:@"title"]:@"untitlted";
        [photoTitles addObject:title];
        NSLog(@"photoTitles : %@", photoTitles);
        NSString *photoURLString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_s.jpg",[photo objectForKey:@"farm"],[photo objectForKey:@"server"],[photo objectForKey:@"id"],[photo objectForKey:@"secret"]];
        [smallImage addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
        NSLog(@"SmallImage : %@",smallImage);
        photoURLString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg",[photo objectForKey:@"farm"],[photo objectForKey:@"server"],[photo objectForKey:@"id"],[photo objectForKey:@"secret"]];
        [largeImageURL addObject:[NSURL URLWithString:photoURLString]];
        NSLog(@"LargeImageURL : %@\n",largeImageURL);
    }
    
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  //  [self performSegueWithIdentifier:@"Cell" sender:self] ;
    ShowFullImage *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showFullImage"];
    destViewController.data = [NSData dataWithContentsOfURL:[largeImageURL objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photoTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [photoTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    //NSData *imageData = [smallImage objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:[smallImage objectAtIndex:indexPath.row]];
    return cell;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"Cell"]) {
//       ShowFullImage *destViewController = segue.destinationViewController;
//        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
//        destViewController.data = [NSData dataWithContentsOfURL:[largeImageURL objectAtIndex:index.row]];
////        NSData *imageData = [NSData dataWithContentsOfURL:[largeImageURL objectAtIndex:indexPath.row]];
////        destViewController.image = [UIImage imageWithData : imageData];
//
//    }
//}

- (IBAction)showButton:(UIButton *)sender {
    [photoTitles removeAllObjects];
    [smallImage removeAllObjects];
    [largeImageURL removeAllObjects];
    [self searchFlickrPhotos:self.searchTextfield.text];
    [self.activityIndicator startAnimating];
    [self.view endEditing:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self searchFlickrPhotos:self.SearchTextfield.text];
    
    photoTitles = [[NSMutableArray alloc]init];
    smallImage = [[NSMutableArray alloc]init];
    largeImageURL = [[NSMutableArray alloc]init];
//    [self.tableView setDelegate:self];
//    [self.tableView setDataSource:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
