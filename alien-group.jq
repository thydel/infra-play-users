.
  | (.nodes | keys[]) as $node
  | (.users | keys[]) as $set
  | (.users[$set] | keys[]) as $group
  | .users[$set][$group][] as $user
  | .nodes[$node][$group] as $etc
  | { $node, $group, $user, done: ($user | IN($etc[])) }
