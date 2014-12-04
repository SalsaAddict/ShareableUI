import UIKit

class ProgressBox: NSObject {
    
    private var m_percentage: Bool?
    private var m_popup: UIAlertController?
    private var m_progressView: UIProgressView?
    private var m_spinner: UIActivityIndicatorView?
    
    init(title: String, percentage: Bool) {
        super.init()
        self.m_popup = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.m_percentage = percentage
        if percentage {
            self.m_progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        }
        else {
            self.m_spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
    }
    
    func show(parentViewController: UIViewController, onCancel: (() -> ())? = nil) {
        if onCancel != nil {
            m_popup!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in onCancel!() }))
        }
        parentViewController.presentViewController(m_popup!, animated: true, completion: {
            if self.m_percentage! {
                self.m_progressView!.frame = CGRect(x: 10, y: 65, width: self.m_popup!.view.frame.width - 20, height: 10)
                self.progress = 0
                self.m_popup!.view.addSubview(self.m_progressView!)
            }
            else {
                self.m_spinner!.hidesWhenStopped = false
                self.m_spinner!.frame = CGRect(x: 10, y: 70, width: self.m_popup!.view.frame.width - 20, height: 20)
                self.progress = "Please wait..."
                self.m_popup!.view.addSubview(self.m_spinner!)
                self.m_spinner!.startAnimating()
            }
        })
    }

    var progress: AnyObject? {
        didSet {
            if self.m_percentage! {
                var n = Float(progress as NSNumber)
                if n < 0 { n = 0 } else if n > 1 { n = n / 100 }
                if n > 1 { n = 1 }
                self.m_popup!.message = UInt(n * 100).description + "%"
                self.m_progressView!.setProgress(n, animated: true)
            }
            else {
                self.m_popup!.message = String(progress as NSString) + "\n\n"
            }
        }
    }
    
    func close() {
        if (m_popup!.isViewLoaded()) {
            m_popup!.dismissViewControllerAnimated(true,  nil)
        }
    }
    
}
