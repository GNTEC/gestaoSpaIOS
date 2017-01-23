//
//  localizacaoViewController.m
//  gestaoSap
//
//  Created by User on 22/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "localizacaoViewController.h"
@import GoogleMaps;

@interface localizacaoViewController ()
{
    GMSMapView *mapView_;
    
    
}
@end

@implementation localizacaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:10];
    
    //mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    GMSMapView *map2 = [GMSMapView mapWithFrame:CGRectMake(0, 80, 500, 500) camera:camera];
//    [self.view addSubview:map2];
    
    /* Option 3. add a map to a subview already on the XIB */
    GMSMapView *map3 = [GMSMapView mapWithFrame:self.UIMapa.bounds camera:camera];
    [self.UIMapa addSubview:map3];
    
    mapView_.settings.compassButton = YES;
    mapView_.myLocationEnabled = YES;

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = map3;
    
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
