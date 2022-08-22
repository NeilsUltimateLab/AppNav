# AppNav
Custom Container Controller with navigation bar, trying to Mimic UINavigationController.


https://user-images.githubusercontent.com/23612211/185956662-91d928d3-635f-491c-9d4e-b7e1e1479651.mp4

## Key-classes
- NavAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning
  - This provides animation for push and pop of view-controllers. (with help of `NavTransitionContext`)
- NavTransitionContext: NSObject, UIViewControllerContextTransitioning
  - This provides a context for push and pop transitioning. 
- NavViewController: UIViewController
  - This is the custom container view controller which holds a container view to manange the view controller after push-pop transition. 
  - Also contains a UINavigationBar for displaying the visible child view controller's navigation items (left and right bar button items with title in center).
