output "disk" {
  description = "The name disk being created"
  value       = try(google_compute_disk.disk.0, null)
}