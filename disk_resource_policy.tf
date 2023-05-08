resource "google_compute_resource_policy" "policy" {
  count       = var.enable_snapshot ? 1 : 0
  project     = var.project_id
  region      = var.region
  name        = "snapshot-${var.project_id}-${var.snapshot_name}"
  description = var.snapshot_description

  snapshot_schedule_policy {
    schedule {
      #Daily, Hourly의 경우 값을 GCP 상에도 하나만 넣을수있어서 Tuple 형태로 코드 작성
      dynamic "hourly_schedule" {
        for_each = var.schedule.hourly_schedule != null ? [""] : []
        content {
          hours_in_cycle = var.schedule.hourly_schedule.hours_in_cycle
          start_time     = var.schedule.hourly_schedule.start_time
        }
      }
      dynamic "daily_schedule" {
        for_each = var.schedule.daily_schedule != null ? [""] : []
        content {
          days_in_cycle = var.schedule.daily_schedule.days_in_cycle
          start_time    = var.schedule.daily_schedule.start_time
        }
      }
      # 값을 여러개 변환해서 넣기 위해, List 형태로 코드 작성
      # day_of_weeks List형으로 변환(필요)
      dynamic "weekly_schedule" {
        for_each =  var.schedule.weekly_schedule != null ? [var.schedule.weekly_schedule] : [] 
        content {
          dynamic "day_of_weeks" {
            for_each = weekly_schedule.value
            content {
              day = day_of_weeks.value.day_of_weeks.day
              start_time = day_of_weeks.value.day_of_weeks.start_time
            }
          }
        }
      }
    }
    retention_policy {
      max_retention_days    = var.retention_policy.max_retention_days
      on_source_disk_delete = var.retention_policy.on_source_disk_delete
    }
    snapshot_properties {
      labels            = var.snapshot_labels
      storage_locations = var.snapshot_properties.storage_locations
      guest_flush       = var.snapshot_properties.guest_flush
      chain_name        = var.snapshot_properties.chain_name
    }
  }
}