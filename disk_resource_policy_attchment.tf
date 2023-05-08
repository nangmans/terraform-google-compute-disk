resource "google_compute_disk_resource_policy_attachment" "attachment" {
  count   = var.enable_snapshot && !var.create_regional_disk.enable ? 1 : 0
  name    = google_compute_resource_policy.policy.0.name
  disk    = google_compute_disk.disk.0.name
  project = var.project_id
  zone    = var.zone
}

resource "google_compute_region_disk_resource_policy_attachment" "attachment" {
  count   = var.enable_snapshot && var.create_regional_disk.enable ? 1 : 0
  name    = google_compute_resource_policy.policy.0.name
  disk    = google_compute_region_disk.disk.0.name
  project = var.project_id
  region  = var.region
}