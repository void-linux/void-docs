# Base System Requirements

Void can be installed on very minimalist hardware, though we recommend the
following minimums for most installations:

| Architecture | CPU              | RAM  | Storage |
|--------------|------------------|------|---------|
| x86_64-glibc | EM64T            | 96MB | 700MB   |
| x86_64-musl  | EM64T            | 96MB | 600MB   |
| i686-glibc   | Pentium 4 (SSE2) | 96MB | 700MB   |

> Note: Flavor installations require more resources. How much more depends on
> the flavor.

Void is not available for i386, i486, or i586 architectures.

It is highly recommended to have a network connection available during install
to download updates, but this is not required. ISO images contain installation
data on-disc and can be installed without network connectivity.
