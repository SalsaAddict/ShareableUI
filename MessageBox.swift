import UIKit

class MessageBox: NSObject {
    
    private var m_popup: UIAlertController?
    private var m_autoDismissSecs: UInt64?
    private var m_closure: ((String) -> ())?
    private var m_closed: Bool = true
    
    init(title: String, message: String,
        hasOkButton: Bool = true, okButtonText: String = "Ok", // Ok button options
        hasCancelButton: Bool = false, cancelButtonText: String = "Cancel", // Cancel button options
        autoDismissSecs: UInt64 = 0) // Number of seconds until the alert is automatically dismissed
    {
        super.init()
        m_popup = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        if (hasOkButton) {
            m_popup!.addAction(UIAlertAction(title: okButtonText, style: UIAlertActionStyle.Default, handler: { (action) in self.doClosure(action!.title) }))
        }
        if (hasCancelButton) {
            m_popup!.addAction(UIAlertAction(title: cancelButtonText, style: UIAlertActionStyle.Cancel, handler: { (action) in self.doClosure(action!.title) }))
        }
        m_autoDismissSecs = autoDismissSecs
    }
    
    private func doClosure(result: String) {
        if m_closure != nil {
            if let callback = m_closure! as ((String) -> ())! {
                m_closure!(result)
            }
        }
        self.m_closed = true
    }
    
    func show(parentViewController: UIViewController, closure: ((String) -> ())? = nil) {
        parentViewController.presentViewController(m_popup!, animated: true, completion: nil)
        if closure != nil { if let callback = closure! as ((String) -> ())! { m_closure = callback } }
        if (m_autoDismissSecs > 0) {
            let t: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(m_autoDismissSecs! * NSEC_PER_SEC))
            dispatch_after(t, dispatch_get_main_queue(), { if !self.m_closed { self.close("") } })
        }
        self.m_closed = false
    }
    
    func close(result: String) {
        if (m_popup!.isViewLoaded()) { m_popup!.dismissViewControllerAnimated(true,  nil) }
        self.doClosure(result)
    }
    
}