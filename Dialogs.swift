import UIKit
/*
func showPopup(sender: UIButton)
{
    MessageBox(title: "Test", message: "This is a test").show(self)
    
}

func showPopup00(sender: UIButton)
{
    let m = MessageBox(title: "Test", message: "This is a test!", hasCancelButton: true)// , autoDismissSecs: 5)
    m.show(self, { (result) in if result == "OK" { self.doOK() } else { self.doCancel() } } )
}
*/
class MessageBox: NSObject {
    
    private var m_popup: UIAlertController?
    private var m_autoDismissSecs: UInt64?
    private var m_closure: ((String) -> ())?
    private var m_closed: Bool = true
    
    init(title: String, message: String,
        hasOkButton: Bool = true, okButtonText: String = "OK", // Ok button options
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

/*
LoginBox().show(self, {
    (cancel, username, password) in
    if cancel {
        println("Login cancelled")
    }
    else {
        println("Login Username = \(username!) Password = \(password!)")
    }
})
*/
class LoginBox: NSObject {
    
    private var m_popup: UIAlertController?
    private var m_closure: ((Bool,String?,String?) -> ())?

    init(title: String? = "Login", message: String? = "Please enter your login details") {
        super.init()
        m_popup = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        m_popup?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Username"
        })
        m_popup?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        m_popup?.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {(action) in self.doClosure(false)} ))
        m_popup?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: {(action) in self.doClosure(true)} ))
    }
    
    func show(parentViewController: UIViewController, closure: ((Bool,String?,String?) -> ())) {
        parentViewController.presentViewController(m_popup!, animated: true, completion: nil)
        m_closure = closure
    }
    
    private func doClosure(cancel: Bool) {
        if cancel {
            m_closure!(true, nil, nil)
        }
        else {
            var username: UITextField = m_popup?.textFields![0] as UITextField
            var password: UITextField = m_popup?.textFields![1] as UITextField
            m_closure!(false, username.text, password.text)
        }
    }
    
}

