## Disk Module v0.0.1###
########################
## Disk Setting ########
########################

type             = "pd-ssd" # pd-standard, pd-ssd, pd-extreme, pd-balanced
size             = 20
provisioned_iops = null # pd-extereme이 아닌 경우, null

#############
## General ##
#############
project_id  = "gyeongsik-dev"
name        = "blank-disk-001"
description = "blankdisk"
labels = {
  "env"     = "dev",
  "module"  = "wt-api",
  "service" = "chatservice"
}

################
### Location ### 
################
zone                 = "asia-northeast3-c"
region               = "asia-northeast3"
create_regional_disk = {
  enable = false
  replica_zones =  null 
}

##############
### Source ###
##############

disk_source = {
  source      = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20221206"
  source_type = "IMAGE"
}

# source_snapshot_encryption_key = {
#   kms_key_self_link       = "projects/gyeongsik-dev/locations/global/keyRings/gcp-kms-disk-key/cryptoKeys/gyeongsik-key-1"
#   kms_key_service_account = "gyeongsik-tf-svc@gyeongsik-dev.iam.gserviceaccount.com"
#   #   raw_key = "value"
#   #   sha256 = "value"
# }
# source_image_encryption_key = {
#   kms_key_self_link       = "projects/gyeongsik-dev/locations/global/keyRings/gcp-kms-disk-key/cryptoKeys/gyeongsik-key-1"
#   kms_key_service_account = "gyeongsik-tf-svc@gyeongsik-dev.iam.gserviceaccount.com"
#   #   raw_key = "value"
#   #   sha256 = "value"
# }

#######################
## Snapshot Scheudle ##
#######################
enable_snapshot      = true # snapshot을 enable할 수 있는 variable을 추가해 snapshot을 켜고 끌 수 있게끔 했습니다.
snapshot_name        = "dev-schedule-1"
snapshot_description = "dev-schedule-1"
snapshot_labels = {
  "env"     = "dev",
  "module"  = "wt-api",
  "service" = "chatservice"
}
schedule = {
  #   daily_schedule = {
  #     days_in_cycle = null # number 
  #     start_time = null # "value"
  #   }
  #   hourly_schedule = {
  #     hours_in_cycle =null # number 
  #     start_time = null # "value"
  #   }
  weekly_schedule = [
    {
    day_of_weeks = {
      day        = "MONDAY"
      start_time = "17:00"
    }
  },{
    day_of_weeks = {
      day        = "TUESDAY"
      start_time = "18:00"
    }
  }
  
  ]
}
retention_policy = {
  max_retention_days    = 14
  on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
}
snapshot_properties = {
  chain_name        = "snapshot-chain-dev"
  guest_flush       = true
  storage_locations = ["asia-northeast3"]
}

################
## Encryption ##
################

# disk_encryption_key = {
#   kms_key_self_link       = "projects/gyeongsik-dev/locations/global/keyRings/gcp-kms-disk-key/cryptoKeys/gyeongsik-key-1"
#   kms_key_service_account = "gyeongsik-tf-svc@gyeongsik-dev.iam.gserviceaccount.com"
#   #   raw_key = "value"
#   #   sha256 = "value"
# }