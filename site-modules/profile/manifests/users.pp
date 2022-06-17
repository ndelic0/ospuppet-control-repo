# @summary Users management
#
class profile::users (
  Optional[String[1]] $root_pw  = undef,
  Hash $root_params             = {},
  Hash $users_hash              = {},
  Hash $available_users_hash    = {},
  Array $available_users_to_add = [],
) {
  # manage groups
  contain profile::groups

  if $root_pw or $root_params != {}  {
    user { 'root':
      password => $root_pw,
      *        => $root_params,
    }
  }

  $added_users = $available_users_hash.filter | $username , $key | {
    $username in $available_users_to_add
  }
  $all_users = $added_users + $users_hash
  if $all_users != {} {
    $all_users.each |$u,$rv| {
      # Find home
      if $rv['home'] {
        $home_real = $rv['home']
      } elsif $u == 'root' {
        $home_real = '/root'
      } else {
        $home_real = "/home/${u}"
      }

      accounts::user { $u:
        ensure                   => pick_default($rv['ensure'],'present'),
        allowdupe                => pick_default($rv['allowdupe'],true),
        comment                  => pick_default($rv['comment'], $u),
        create_group             => pick_default($rv['create_group'],false),
        gid                      => $rv['gid'],
        groups                   => $rv['groups'],
        home                     => $home_real,
        ignore_password_if_empty => true,
        managehome               => true,
        home_mode                => '0700',
        password                 => pick_default($rv['password'],''),
        shell                    => pick_default($rv['shell'],'/sbin/nologin'),
        uid                      => $rv['uid'],
        sshkeys                  => $rv['sshkeys'],
        *                        => pick_default($rv['extra_params'],{}),
      }

    }
  }
}
