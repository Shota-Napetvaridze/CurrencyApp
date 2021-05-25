//
//  XmlParserManager.swift
//  CurrencyApp
//
//  Created by MacBook Pro on 25.05.21.
//

import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var currencies = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var fdescription = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        currencies = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allCurrencies() -> NSMutableArray {
        return currencies
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            fdescription = NSMutableString()
            fdescription = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if (elementName as NSString).isEqual(to: "item") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            currencies.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            ftitle.append(string)
        }  else if element.isEqual(to: "description") {
            fdescription.append(string)
        }
    }
}
