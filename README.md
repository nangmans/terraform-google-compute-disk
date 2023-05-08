# terraform-google-compute-disk

이 모듈은 [terraform-google-module-template](https://stash.wemakeprice.com/users/lswoo/repos/terraoform-google-module-template/browse)에 의해서 생성되었습니다. 

The resources that this module will create are:

- Create a Disk with the provided name
- Create a Snapshot Schedule with the provided name


## Usage

Disk & Snapshot Schedule 모듈의 기본적인 사용법은 다음과 같습니다 :) 

상세 내용에 대해서는 exmaples/simple_example_$NUMBER Directory를 참고 해주시면 좋을것 같습니다. 

모든 Designated Directory의 Main.tf 파일은 terraform.tfvars 기준으로 생성되었습니다. 

terraform.tfvars 및 Description을 참고해주신 뒤, 추가 질의하실 부분이 있으시면 언제든 질문 부탁드립니다.(WMP_Cloud DevOps팀)

```hcl
module "compute_disk" {
  source = "../.."

  ### General ###
  project_id  = var.project_id # Disk를 생성할 Project ID
  name        = var.name # Disk Name
  description = var.description # Disk에 대한 설명
  labels      = var.labels # Disk Label

  ### Location ###
  create_regional_disk = var.create_regional_disk # Regional Disk 생성 관련 True/False
  region               = var.region # Disk가 생성될 Region
  zone                 = var.zone # Disk가 생성될 Zone

  ### Source ### 
  disk_source = var.disk_source # Disk Source에 대한 SelfLink 값 및 Source Type 선언("SNAPSHOT","IMAGE",null=blank Disk)
  source_image_encryption_key    = var.source_image_encryption_key # Source Image에서  Encryption Key를 사용중인 경우 기입 필요
  source_snapshot_encryption_key = var.source_snapshot_encryption_key # 

  ### Disk Setting ### 
  type             = var.type # Disk Type 지정 # "pd-standard", "pd-ssd", "pd-extreme","pd-balanced"
  size             = var.size # Disk Size(Number), 30 
  provisioned_iops = var.provisioned_iops # pd-extereme이 아닌 경우, null

  ### Snapshot Enable/Disable ###
  enable_snapshot = var.enable_snapshot # Snapshot 사용 유/무 관련 variable
  ### Snapshot Schedule ### 
  snapshot_name        = var.snapshot_name # Snapshot Name 
  snapshot_description = var.snapshot_description # 해당 Snapshot에 대한 설명
  snapshot_labels      = var.snapshot_labels # Snapshot Labels
  schedule             = var.schedule # Snapshot Schedule Daily,Hourly,Weekly 
  retention_policy     = var.retention_policy # Snapshot Schedule 보존 정책
  snapshot_properties  = var.snapshot_properties # Snapshot Schedule 정책 속성(Location, chain_name,guest_flush)

  ### Encryption ### 
  disk_encryption_key = var.disk_encryption_key # Disk의 CMEK kms or raw_key)
}
```

모듈 사용의 예시는 [examples](./examples/) 디렉토리에 있습니다.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_regional\_disk | Regional Disk로 생성 유/무 판단 | `bool` | `false` | no |
| description | 해당 Disk에 대한 설명 | `any` | n/a | yes |
| disk\_encryption\_key | kms_key_self_link와 disk_encryption_key_raw 중 하나만 가능 | <pre>object({<br>    # raw_key                 = optional(string)<br>    # sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME"<br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| disk\_source | Source Type과 Source를 지정하는 변수 | <pre>object({<br>    source_type = string # ex) "IMAGE", "SNAPSHOT", "null"(blank-disk)<br>    source      = optional(string) # ex) "IMAGE의 예시 projects/IMAGE_FAMILY/global/images/IMAGE_NAME"<br>  })</pre> | <pre>{<br>  "source_type": ""<br>}</pre> | no |
| enable\_snapshot | Snapshot 사용 여부 | `bool` | `false` | no |
| labels | Disk Labeling  | `map(string)` | `{}` | no |
| name | Disk 생성시 사용할 이름 | `string` | n/a | yes |
| project\_id | Disk를 생성할 GCP Project ID | `any` | n/a | yes |
| provisioned\_iops | Exterme Disk 사용시만 사용 가능한 옵션, Iops 지정 가능 | `number` | n/a | yes |
| region | Disk가 생성될 리전 | `string` | `"asia-northeast3"` | no |
| replica\_zones | Regional Disk 사용시 Replica Zone 기입(필수) | `string` | n/a | yes |
| retention\_policy | Snapshot 보존 정책 | <pre>object({<br>    max_retention_days    = number # ex) 14 <br>    on_source_disk_delete = optional(string) # ex) "KEEP_AUTO_SNAPSHOTS","APPLY_RETENTION_POLICY"<br>  })</pre> | <pre>{<br>  "max_retention_days": null<br>}</pre> | no |
| schedule | Snapshot 정책 스케줄, UTC 기준(주의) | <pre>object({<br>    hourly_schedule = optional(object({<br>      hours_in_cycle = number # ex) 1<br>      start_time     = string # ex) "17:00" <br>    }))<br>    daily_schedule = optional(object({<br>      days_in_cycle = number # ex) 1~24<br>      start_time    = string # ex) "12:00"<br>    }))<br>    weekly_schedule = optional(list(object({<br>      day_of_weeks = object({<br>        day        = string # ex) "MONDAY"<br>        start_time = string # ex) "19:00"<br>      })<br>      }))<br>    )<br>  })</pre> | `{}` | no |
| size | Disk Size | `number` | n/a | yes |
| snapshot\_description | Snapshot에 대한 설명 | `string` | n/a | yes |
| snapshot\_labels | Snapshot Labels | `map(string)` | `{}` | no |
| snapshot\_name | Snapshot 이름 | `string` | n/a | yes |
| snapshot\_properties | Snapshot Schedule 보존 정책 | <pre>object({<br>    storage_locations = optional(list(string)) # ex) ["asia-northeast3"]<br>    guest_flush       = optional(bool) <br>    chain_name        = optional(string)<br>  })</pre> | `{}` | no |
| source\_image\_encryption\_key | Source Image에서 설정된 Encryption Key에 대한 옵션 | <pre>object({<br>    raw_key                 = optional(string)<br>    sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME" <br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| source\_snapshot\_encryption\_key | Source Snapshot에서 설정된 Encryption Key에 대한 옵션 | <pre>object({<br>    raw_key                 = optional(string)<br>    sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME"<br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| type | Disk Type 설정 | `string` | `"pd-balanced"` | no |
| zone | Disk Zone 설정 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| disk | 생성된 Disk의 정보 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

이 모듈을 사용하기 위해 필요한 사항을 표기합니다.

### Software

아래 dependencies들이 필요합니다:

- [Terraform][terraform] v1.3.5
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v4.46.0

### Service Account

이 모듈의 리소스를 배포하기 위해서는 아래 역할이 필요합니다:

- Compute Storage Admin: `roles/compute.storageAdmin`
- Service Account Creator & Deleter  : `roles/iam.serviceAccountCreator, roles/iam.serviceAccountDeleter`

[Project Factory module][project-factory-module] 과
[IAM module][iam-module]로 필요한 역할이 부여된 서비스 어카운트를 배포할 수 있습니다.

### APIs

이 모듈의 리소스가 배포되는 프로젝트는 아래 API가 활성화되어야 합니다:

- Google Cloud Compute Engine API: `compute.googleapis.com`


[Project Factory module][project-factory-module]을 이용해 필요한 API를 활성화할 수 있습니다.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Contributing

- 이 모듈에 기여하기를 원한다면 [contribution guidelines](./CONTRIBUTING.md)를 참고 바랍니다.

## Changelog

- [CHANGELOG.md](./CHANGELOG.md)

## TO DO

- [ ] Main Docs 작성 후 FeedBack 후 수정
- [ ] Output 추가
