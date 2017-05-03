//
//  PDFViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/7/3.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController,ReaderViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        initPDFReadView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func initPDFReadView() {
        
        let phrase = ""
        
        let pdfs = NSBundle.mainBundle().pathsForResourcesOfType("pdf", inDirectory: nil)
        
        let filePath = pdfs.first
        
        let document = ReaderDocument.withDocumentFilePath(filePath, password: phrase)
        
        if (document != nil) {
            let readerViewController = ReaderViewController.init(readerDocument: document)
            readerViewController.delegate = self
            self.navigationController?.pushViewController(readerViewController, animated: true)
        }
        
    }
    
    
    // MARK: - ReaderViewDelegate
    func dismissReaderViewController(viewController: ReaderViewController!) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
