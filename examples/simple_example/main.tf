/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "compute_disk" {
  source = "../.."

  ### General ###
  project_id  = var.project_id
  name        = var.name
  description = var.description
  labels      = var.labels

  ### Location ###
  create_regional_disk = var.create_regional_disk
  region               = var.region
  zone                 = var.zone
  

  ### Source ### 
  disk_source                    = var.disk_source
  source_image_encryption_key    = var.source_image_encryption_key
  source_snapshot_encryption_key = var.source_snapshot_encryption_key

  ### Disk Setting ### 
  type             = var.type
  size             = var.size
  provisioned_iops = var.provisioned_iops

  ### Snapshot Enable/Disable ###
  enable_snapshot = var.enable_snapshot
  ### Snapshot Schedule ### 
  snapshot_name        = var.snapshot_name
  snapshot_description = var.snapshot_description
  snapshot_labels      = var.snapshot_labels
  schedule             = var.schedule
  retention_policy     = var.retention_policy
  snapshot_properties  = var.snapshot_properties

  ### Encryption ### 
  disk_encryption_key = var.disk_encryption_key
}
