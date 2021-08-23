// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import CoreData

extension URLPreviewCacheData {
    convenience init(context: NSManagedObjectContext, preview: URLPreviewViewData, creationDate: Date) {
        self.init(context: context)
        update(from: preview, on: creationDate)
    }
    
    func update(from preview: URLPreviewViewData, on date: Date) {
        url = preview.url
        siteName = preview.siteName
        title = preview.title
        text = preview.text
        image = preview.image
        
        creationDate = date
    }
    
    func preview() -> URLPreviewViewData? {
        guard let url = url else { return nil }
        
        let viewData = URLPreviewViewData(url: url, siteName: siteName, title: title, text: text)
        viewData.image = image as? UIImage
        
        return viewData
    }
}
