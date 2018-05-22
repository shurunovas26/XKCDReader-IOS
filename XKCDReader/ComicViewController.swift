import UIKit

class ComicViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var altTextView: UITextView!
    
    public var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadComic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func loadComic() {
        
        self.title = comic!.title
        altTextView.text = comic!.alt
        imageView = UIImageView()
        
        imageView.af_setImage(withURL: URL(string: comic!.image)!)
        
        let newSizeImage = imageView.image?.scaled(to: scrollView.frame.size)
        imageView.image = newSizeImage
        imageView.frame.size = imageView.image!.size
        scrollView.addSubview(imageView)
        scrollView.layer.borderWidth = 1
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.center.x = self.view.center.x
        altTextView.center.x = self.view.center.x
        
    }
    
}

extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFit) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
