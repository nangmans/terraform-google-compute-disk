# Simple Example

Compute Disk Module을 사용하는 예시를 보여줍니다. 


## Usage

- simple_example Designated Directory에는 아래 작업이 구현되어 있음
  - <span style="color:red"><b>Regional Disk의 경우, Boot Disk로 생성 불가능</b></span>
  - <span style="color:red"><b>Regional Disk의 경우, Extereme Disk 생성 불가능</b></span>
  - <span style="color:red"><b>Regional Standard Disk의 경우, 200GB 이하로 사용할 수 없음</b></span>
  - Disk와 Snapshot Label의 경우, 혼선이 없도록 환경,서비스,모듈등을 맞추는것을 권장
- Region Disk 1EA 및 Snapshot Scehdule 생성
  - Disk 옵션
    - Regional Disk
    - Source Type(IMAGE)
    - Key Management Service 설정 확인
    - Labels 설정
  - Snapshot Schedule 옵션
    - hourly Schedule
      - 17 hours Period 
      - start_time 17:00 PM(UTC)
    - Snapshot을 사용하는 Disk 삭제시 스냅샷을 유지하는 정책으로 생성
    - Labels 설정
    - Snapshot properties 설정


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_regional\_disk | Regional Disk로 생성 유/무 판단 | `bool` | `false` | no |
| description | 해당 Disk에 대한 설명 | `any` | n/a | yes |
| disk\_encryption\_key | kms_key_self_link와 disk_encryption_key_raw 중 하나만 가능 | <pre>object({<br>    # raw_key                 = optional(string)<br>    # sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME"<br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| disk\_source | Source Type과 Source를 지정하는 변수 | <pre>object({<br>    source_type = string # ex) "IMAGE", "SNAPSHOT", "null"(blank-disk)<br>    source      = optional(string)# ex) "IMAGE의 예시 projects/IMAGE_FAMILY/global/images/IMAGE_NAME"<br>  })</pre> | <pre>{<br>  "source_type": ""<br>}</pre> | no |
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
| snapshot\_properties | Snapshot Scheudle 보존 정책 | <pre>object({<br>    storage_locations = optional(list(string)) # ex) ["asia-northeast3"]<br>    guest_flush       = optional(bool) <br>    chain_name        = optional(string)<br>  })</pre> | `{}` | no |
| source\_image\_encryption\_key | Source Image에서 설정된 Encryption Key에 대한 옵션 | <pre>object({<br>    raw_key                 = optional(string)<br>    sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME" <br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| source\_snapshot\_encryption\_key | Source Snapshot에서 설정된 Encryption Key에 대한 옵션 | <pre>object({<br>    raw_key                 = optional(string)<br>    sha256                  = optional(string)<br>    kms_key_self_link       = optional(string) # ex) "projects/PROJECT_ID/locations/global/keyRings/KEYRINGS_NAME/cryptoKeys/KEY_NAME"<br>    kms_key_service_account = optional(string) # ex) "KMS 권한이 있는 Service Account"<br>  })</pre> | `{}` | no |
| type | Disk Type 설정 | `string` | `"pd-balanced"`<br>`"pd-ssd"`<br>`"pd-standard"`<br>`"pd-extreme"` | no |
| zone | Disk Zone 설정 | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| disk | 생성된 Disk의 정보 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
