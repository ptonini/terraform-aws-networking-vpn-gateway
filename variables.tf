variable "name" {}

variable "vpc_id" {}

variable "connections" {
  type = map(object({
    cloudwatch_retention_days            = optional(number, 3)
    cloudwatch_log_format                = optional(string, "json")
    gateway_ip_address                   = string
    type                                 = optional(string, "ipsec.1")
    bgp_asn                              = optional(number, 65000)
    static_routes                        = optional(set(string), [])
    static_routes_only                   = optional(bool, true)
    tunnel1_preshared_key                = optional(string)
    tunnel1_startup_action               = optional(string)
    tunnel1_ike_versions                 = optional(set(string))
    tunnel1_dpd_timeout_action           = optional(string)
    tunnel1_phase1_dh_group_numbers      = optional(set(number))
    tunnel1_phase1_encryption_algorithms = optional(set(string))
    tunnel1_phase1_integrity_algorithms  = optional(set(string))
    tunnel1_phase1_lifetime_seconds      = optional(number)
    tunnel1_phase2_dh_group_numbers      = optional(set(number))
    tunnel1_phase2_encryption_algorithms = optional(set(string))
    tunnel1_phase2_integrity_algorithms  = optional(set(string))
    tunnel1_phase2_lifetime_seconds      = optional(number)
    tunnel2_preshared_key                = optional(string)
    tunnel2_startup_action               = optional(string)
    tunnel2_ike_versions                 = optional(set(string))
    tunnel2_dpd_timeout_action           = optional(string)
    tunnel2_phase1_dh_group_numbers      = optional(set(number))
    tunnel2_phase1_encryption_algorithms = optional(set(string))
    tunnel2_phase1_integrity_algorithms  = optional(set(string))
    tunnel2_phase1_lifetime_seconds      = optional(number)
    tunnel2_phase2_dh_group_numbers      = optional(set(number))
    tunnel2_phase2_encryption_algorithms = optional(set(string))
    tunnel2_phase2_integrity_algorithms  = optional(set(string))
    tunnel2_phase2_lifetime_seconds      = optional(number)
  }))
  default = {}
}