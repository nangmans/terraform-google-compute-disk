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


#############
## General ##
#############

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "name" {
  description = "The name disk being created"
  type        = string
}

variable "description" {
  description = "A brief description of this resource"
}

variable "labels" {
  description = "The label to attach to the disk"
  type        = map(string)
  default     = {}
}

##############
## Location ##
##############

variable "create_regional_disk" {
  description = "The zones where the disk should be replicated to"
  type = object({
    enable        = bool
    replica_zones = string
  })
  default = null

  validation {
    condition = (var.create_regional_disk.enable ? 1 : 0) + (var.create_regional_disk.replica_zones != null ? 0 : 1) == 1
    error_message = "Only if regional disk is enabled, replica zone can be specified"
  }
}

variable "region" {
  description = "The name of the disk to create"
  type        = string
  default     = "asia-northeast3"
}

variable "zone" {
  description = "The name of the disk to create zone"
  type        = string
}


############
## Source ##
############

variable "disk_source" {
  description = "You can specify the source type and source."
  type = object({
    source_type = string # IMAGE, SNAPSHOT, null
    source      = optional(string)
  })
  default = {
    source_type = ""
  }
}

variable "source_image_encryption_key" {
  description = "This is the part where you set the Encryption Key of the source image type."
  type = object({
    raw_key                 = optional(string)
    sha256                  = optional(string)
    kms_key_self_link       = optional(string)
    kms_key_service_account = optional(string)
  })
  default = null
}

variable "source_snapshot_encryption_key" {
  description = "This is the part where you set the Encryption Key of the source snapshot type."
  type = object({
    raw_key                 = optional(string)
    sha256                  = optional(string)
    kms_key_self_link       = optional(string)
    kms_key_service_account = optional(string)
  })
  default = null
}

##################
## Disk setting ##
##################

variable "type" {
  description = "URL of the disk type resource describing which disk type to use to create the disk" # pd-balanced , pd-standard , pd-ssd , pd-extreme
  type        = string
  default     = "pd-balanced"
}

variable "size" {
  description = "disk size settings"
  type        = number
}

variable "provisioned_iops" {
  description = "Provisioning disk iops"
  type        = number
}

#######################
## Snapshot schedule ##
#######################
variable "enable_snapshot" {
  description = "Option to use Snapshot or not"
  type        = bool
  default     = false
}
variable "snapshot_name" {
  description = "Snapshot name"
  type        = string
}

variable "snapshot_description" {
  description = "The description of Snapshot"
  type        = string
}

variable "snapshot_labels" {
  description = "Snapshot labeling settings"
  type        = map(string)
  default     = {}
}


variable "schedule" {
  description = "The scheduled to be used by the snapshot policy"
  type = object({
    hourly_schedule = optional(object({
      hours_in_cycle = number
      start_time     = string
    }))
    daily_schedule = optional(object({
      days_in_cycle = number
      start_time    = string
    }))
    weekly_schedule = optional(list(object({
      day_of_weeks = object({
        day        = string
        start_time = string
      })
      }))
    )
  })
  default = {}
}

variable "retention_policy" {
  description = "The retention policy to be applied to the schedule policy."
  type = object({
    max_retention_days    = number
    on_source_disk_delete = optional(string) # KEEP_AUTO_SNAPSHOTS , APPLY_RETENTION_POLICY
  })
  default = {
    max_retention_days = null
  }
}

variable "snapshot_properties" {
  description = "The properties of the schedule policy."
  type = object({
    storage_locations = optional(list(string))
    guest_flush       = optional(bool)
    chain_name        = optional(string)
  })
  default = {}
}

################
## Encryption ##
################

variable "disk_encryption_key" {
  description = "Only one of kms_key_self_link and disk_encryption_key_raw may be set."
  type = object({
    raw_key                 = optional(string)
    sha256                  = optional(string)
    kms_key_self_link       = optional(string)
    kms_key_service_account = optional(string)
  })
  default = null
}

