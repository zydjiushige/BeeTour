//
//  paymentVC.m
//  BeeTour
//
//  Created by 雍丹 赵 on 16/3/31.
//  Copyright © 2016年 雍丹 赵. All rights reserved.
//

#import "paymentVC.h"
#import <PayPalMobile.h>
@interface paymentVC ()<PayPalPaymentDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLable;
@property (weak, nonatomic) IBOutlet UIButton *creditCardButton;
@property (weak, nonatomic) IBOutlet UIButton *payPalButton;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;
@property (weak, nonatomic) IBOutlet UIButton *aliButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation paymentVC
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = NO;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -------creditCardPay
- (IBAction)creditCardPayAction:(id)sender {
    
    [_creditCardButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
     [_appleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
     [_aliButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
     [_payPalButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
     [_weChatButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];

    
}
#pragma mark -------payPalPay
- (IBAction)payPalPayAction:(id)sender {
    [_creditCardButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_appleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_aliButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_payPalButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
    [_weChatButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    
    // invoiceNumber 发票数量
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:@"0.1"];
    payment.currencyCode = @"USD"; // 货币单位
    payment.shortDescription = @"Awesome saws"; // 商品描述
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;  // 销售意图?
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    payment.shippingAddress.city = @"china"; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.  检查是否可加工的付款
    if (!payment.processable) {
        /*
        If, for example, the amount was negative or the shortDescription was empty, then
            this payment would not be processable. You would want to handle that here.
         如果,例如,数量是负数或shortDescription是空的,然后/ /这个付款不会处理的。你会想在这里处理
         */
    
    
    
    }
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
    
}
#pragma mark -------applePayPay
- (IBAction)applePayAction:(id)sender {
    [_creditCardButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_appleButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
    [_aliButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_payPalButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_weChatButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
}
#pragma mark -------aliPayPay
- (IBAction)aliPayAction:(id)sender {
    [_creditCardButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_appleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_aliButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
    [_payPalButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_weChatButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
}
#pragma mark -------weChatPay
- (IBAction)weChatPayAction:(id)sender {
    [_creditCardButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_appleButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_aliButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_payPalButton setImage:[UIImage imageNamed:@"confirm_check"] forState:UIControlStateNormal];
    [_weChatButton setImage:[UIImage imageNamed:@"confirm_check_pre"] forState:UIControlStateNormal];
}
#pragma mark -------Pay
- (IBAction)payAction:(id)sender {
}

#pragma mark --------- paypalDelegate
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NJLog(@"交易完-----%@",confirmation);
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
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
