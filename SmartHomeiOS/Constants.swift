/*
* Copyright 2010-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

import Foundation
import AWSCore

//WARNING: To run this sample correctly, you must set the following constants.
let S3BucketName: String = "smarthomesolutionsbucket" // Update this to your bucket name
let S3DownloadKeyName: String = "test-image.png"
let S3UploadKeyName: String = "image.jpeg";
//var Counter = 100;
var E_Count = 0;
let addr = "130.65.154.118"
let port = 9876;

var Counter = 100;
let defaults = UserDefaults.standard //returns shared defaults object.
