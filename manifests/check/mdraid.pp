class nagios::check::mdraid (
  $ensure                   = undef,
  $args                     = '',
  $check_title              = $::nagios::client::host_name,
  $servicegroups            = undef,
  $check_period             = $::nagios::client::service_check_period,
  $contact_groups           = $::nagios::client::service_contact_groups,
  $first_notification_delay = $::nagios::client::first_notification_delay,
  $max_check_attempts       = $::nagios::client::service_max_check_attempts,
  $notification_period      = $::nagios::client::service_notification_period,
  $use                      = $::nagios::client::service_use,
) {

  # Service specific script, taken from:
  file { "${nagios::client::plugin_dir}/check_mdraid":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/plugins/check_mdraid"),
  }

  nagios::client::nrpe_file { 'check_mdraid':
    ensure => $ensure,
    args   => $args,
  }

  nagios::service { "check_mdraid_${check_title}":
    ensure                   => $ensure,
    check_command            => 'check_nrpe_mdraid',
    service_description      => 'mdraid',
    servicegroups            => $servicegroups,
    check_period             => $check_period,
    contact_groups           => $contact_groups,
    first_notification_delay => $first_notification_delay,
    notification_period      => $notification_period,
    max_check_attempts       => $max_check_attempts,
    use                      => $use,
  }
}
