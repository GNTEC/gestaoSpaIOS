//
//  localizacaoViewController.m
//  gestaoSap
//
//  Created by User on 22/01/17.
//  Copyright © 2017 gntec. All rights reserved.
//

#import "localizacaoViewController.h"
#import "VariaveisGlobais.h"
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface localizacaoViewController ()
{
    GMSMapView *mapView_;
    CLGeocoder *_geocoder;
}

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (assign, nonatomic) BOOL updating;
@property (strong, nonatomic) LLARingSpinnerView *spinnerView;

@end

@implementation localizacaoViewController

-(LLARingSpinnerView *)spinnerView {
    if (!_spinnerView) {
        _spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
        _spinnerView.tintColor = [UIColor blackColor];
        // Optionally set the current progress
        _spinnerView.lineWidth = 1.5f;
        _spinnerView.hidesWhenStopped = YES;
    }
    return _spinnerView;
}

-(void)setUpdating:(BOOL)updating {
    _updating = updating;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.updating) {
            [self.spinnerView startAnimating];
        } else {
            [self.spinnerView stopAnimating];
        }
    });
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //spinnerView.backgroundColor = [UIColor grayColor];
    // Add it as a subview
    [self.view addSubview:self.spinnerView];
    
    [self fetchCoordinates];
}

- (void)fetchCoordinates {
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    NSString *address = [VariaveisGlobais shared]._enderecoFilial;
    
    self.updating = YES;
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
    
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            //NSString *x = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                                    longitude:coordinate.longitude
                                                                         zoom:16];
            
            /* Option 3. add a map to a subview already on the XIB */
            GMSMapView *maps = [GMSMapView mapWithFrame:self.UIMapa.bounds camera:camera];
            [self.UIMapa addSubview:maps];
            [self.view sendSubviewToBack:self.UIMapa];
            
            mapView_.settings.compassButton = YES;
            mapView_.myLocationEnabled = YES;
            
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
            marker.title = [VariaveisGlobais shared]._nomeFilial;
            marker.snippet = [VariaveisGlobais shared]._enderecoFilial;
            marker.map = maps;
            self.updating = NO;

        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
