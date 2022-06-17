# @summary Groups management
#
class profile::groups (
  Hash $groups_hash              = {},
  Hash $available_groups_hash    = {},
  Array $available_groups_to_add = [],
) {

  $added_groups = $available_groups_hash.filter |$groupname, $key| {
    $groupname in $available_groups_to_add
  }
  $all_groups = $added_groups + $groups_hash
  if $all_groups != {} {
    $all_groups.each |$g,$rv| {
      group { $g:
        ensure     => $rv['ensure'],
        allowdupe  => $rv['allowdupe'],
        forcelocal => $rv['forcelocal'],
        gid        => $rv['gid'],
        members    => $rv['members'],
        system     => $rv['system'],
      }
    }
  }
}
