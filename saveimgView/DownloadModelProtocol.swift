//
//  DownloadModelProtocol.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/16/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
protocol DownloadModelProtocol{
    func getStringURL()->String
    func downloadImg(completionHandler:@escaping (Data?)->Void)
}
