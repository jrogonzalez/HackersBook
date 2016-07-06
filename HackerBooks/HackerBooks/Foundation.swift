import Foundation


extension NSBundle{
    
    func URLForResource(name: String?) -> NSURL?{
        
        let components = name?.componentsSeparatedByString(".")
        let fileTitle = components?.first
        let fileExtension = components?.last
        
        return URLForResource(fileTitle, withExtension: fileExtension)
        
    }
}
