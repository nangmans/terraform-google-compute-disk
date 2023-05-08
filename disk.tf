resource "google_compute_disk" "disk" {

  #############
  ## General ##
  #############

  count       = var.create_regional_disk.replica_zones != null ? 0 : 1
  project     = var.project_id
  name        = "disk-${var.project_id}-${var.name}"
  description = var.description
  labels      = var.labels

  ##############
  ## Location ##
  ##############

  # region = var.region
  zone = var.zone

  ############
  ## Source ##
  ############

  image    = var.disk_source.source_type == "IMAGE" ? var.disk_source.source : null
  snapshot = var.disk_source.source_type == "SNAPSHOT" ? var.disk_source.source : null
  dynamic "source_image_encryption_key" {
    for_each = var.source_image_encryption_key != null ? [""] : []
    content {
      raw_key                 = var.source_image_encryption_key.raw_key
      sha256                  = var.source_image_encryption_key.sha256
      kms_key_self_link       = var.source_image_encryption_key.kms_key_self_link
      kms_key_service_account = var.source_image_encryption_key.kms_key_service_account
    }
  }
  dynamic "source_snapshot_encryption_key" {
    for_each = var.source_snapshot_encryption_key != null ? [""] : []
    content {
      raw_key                 = var.source_snapshot_encryption_key.raw_key
      sha256                  = var.source_snapshot_encryption_key.sha256
      kms_key_self_link       = var.source_snapshot_encryption_key.kms_key_self_link
      kms_key_service_account = var.source_snapshot_encryption_key.kms_key_service_account
    }
  }

  ##################
  ## Disk setting ##
  ##################

  type             = var.type
  size             = var.size
  provisioned_iops = var.type == "pd-extreme" ? var.provisioned_iops : null


  ################
  ## Encryption ##
  ################

  dynamic "disk_encryption_key" {
    for_each = var.disk_encryption_key != null ? [""] : []
    content {
      raw_key                 = var.disk_encryption_key.raw_key
      sha256                  = var.disk_encryption_key.sha256
      kms_key_self_link       = var.disk_encryption_key.kms_key_self_link
      kms_key_service_account = var.disk_encryption_key.kms_key_service_account
    }

  }
}

##############################################################################################################################################

resource "google_compute_region_disk" "disk" {

  #############
  ## General ##
  #############

  count       = var.create_regional_disk.replica_zones != null ? 1 : 0
  project     = var.project_id
  name        = "disk-${var.project_id}-${var.name}"
  description = var.description
  labels      = var.labels

  ##############
  ## Location ##
  ##############

  region        = var.region
  replica_zones = [var.zone, var.create_regional_disk.replica_zones]

  ############
  ## Source ##
  ############
  ### Zonal Disk 생성시에는 전체 주석하여 사용
  # image    = var.disk_source.source_type == "IMAGE" ? var.disk_source.source : null 
  # source_image_encryption_key {
  # raw_key                 = var.source_image_encryption_key.raw_key
  # sha256                  = var.source_image_encryption_key.sha256
  # kms_key_self_link       = var.source_image_encryption_key.kms_key_self_link
  # kms_key_service_account = var.source_image_encryption_key.kms_key_service_account
  # }
  # Currently image source is not supported at regional disk 

  snapshot = var.disk_source.source_type == "SNAPSHOT" ? var.disk_source.source : null
  #kms_key 사용시 source_snapshot_encryption key는 주석으로 유지
  dynamic "source_snapshot_encryption_key" {
    for_each = var.source_snapshot_encryption_key != null ? [""] : []
    content {
      raw_key                 = var.source_snapshot_encryption_key.raw_key
      sha256                  = var.source_snapshot_encryption_key.sha256
      #kms_key_name            = var.source_snapshot_encryption_key.kms_key_self_link #Beta Property 
    }
  }

  ##################
  ## Disk setting ##
  ##################

  type = var.type
  size = var.size


  ################
  ## Encryption ##
  ################

  dynamic "disk_encryption_key" {
    for_each = var.disk_encryption_key != null ? [""] : []
    content {
      raw_key      = var.disk_encryption_key.raw_key
      sha256       = var.disk_encryption_key.sha256
      kms_key_name = var.disk_encryption_key.kms_key_self_link
    }
  }
}








