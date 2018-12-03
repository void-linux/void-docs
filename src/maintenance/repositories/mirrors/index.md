# Mirrors

Void Linux maintains mirrors in several geographic regions for you to use. In
normal use your traffic will be routed to the nearest mirror to you based on
your IP Address. If you would like to directly use a particular mirror you can
set this manually. This can also be handy if you are on a different continent
than the primary mirror, or if you are not on the same continent as any
officially managed mirrors.

## Tier 1 mirrors

Tier 1 mirrors sync directly from the build-master and will always have the
latest packages available. These repositories are maintained by the Void Linux
Infrastructure Team. In rare occasions we may permit a mirror that we don’t
manage to sync directly from our primary servers if there are extenuating
circumstances.

## Tier 2 mirrors

Tier 2 mirrors sync from a nearby tier 1 mirror when possible, but there is no
guarantee of a mirror being nearby. These mirrors are not managed by Void nor do
they have any specific guarantees for staleness or completeness of packages.
Tier 2 mirrors are free to sync only specific architectures and exclude
sub-repositories (nonfree/multilib).
