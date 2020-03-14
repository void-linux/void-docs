# Steam

**Steam** is a digital distribution service that is well known among the gaming
community. Getting it to work on a 32-bit Linux machine is fairly
straightforward, but on 64bit machines additional work and maintenance is
required.

## Installation

You can install **Steam** in one of two ways. You can either install it via a
`flakpak` or you can install it using `xbps` Note, `musl` users currently must
use the `flatpak` method. See
[Flathub](https://flathub.org/apps/details/com.valvesoftware.Steam) for this
way. To install **Steam** using the package manager, you will need to enable the
non-free repository if you have not yet.

```
# xbps-install -Sy void-repo-nonfree
```

Next, install the `steam` package from the non-free repo. If you are running the
`i686` distribution this should be enough to get it running.

### Additional steps on x86_64 machines

For **x86_64** users some additional `32bit` packages must be installed that are
provided by the *multilib* repository. First, enable the repository if you have
not yet done so.

```
# xbps-install -Sy void-repo-multilib
```

And for the closed source multilib graphic drivers.

```
xbps-install -Sy void-repo-multilib-nonfree
```

Next, install the common packages:

```
# xbps-install -S libpulseaudio-32bit libtxc_dxtn-32bit fontconfig-32bit libavcodec-32bit libavformat-32bit libavresample-32bit libavutil-32bit
```

For users of **Intel GPUs**, install these packages too:

```
# xbps-install -S libGL-32bit mesa-intel-dri-32bit
```

For users of the **open source AMD Radeon GPU** drivers, install these:

```
# xbps-install -S libGL-32bit mesa-ati-dri-32bit
```

For users of the **open source NVIDIA GPU drivers (Nouveau)**, install these
packages:

```
# xbps-install -S libGL-32bit mesa-nouveau-dri-32bit
```

For users of the **propriety NVIDIA drivers**, install thse packages:

```
# xbps-install -S nvidia-libs-32bit
```

For the **340.xx** legacy drivers, install:

```
# xbps-install -S nvidia340-libs-32bit
```

For the **304.xx** legacy drivers, install:

```
# xbps-install -S nvidia304-libs-32bit
```

Certain games (like FEZ), require that mono be installed:

```
# xbps-install -S mono
```

## Troubleshooting

### Libstdc++ Library error and Steam runtime issues

The Steam Ubuntu bootstrap tarball might use an incompatible libstdc++ library.
To fix this, run:

```
$ LIBGL_DEBUG=verbose steam
```

to see if that's the case, and then try to remove the supplied `libstdc++` from
`~/.local/share/steam`. Note that this is a temporary solution, as this file
will be restored every time the Steam client is updated. For a more reliable
solution, you can try overriding problematic libraries with `LD_PRELOAD`:

```
$ LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1' steam
```

For convenience, you can put this in a script or an alias.

### Games running slowly or not at all, issues with network streaming

Verify that your user belongs to the **video** group using the `groups` command.

### Steam does not start or segfaults

Try enabling and starting the `dbus` service.

### Audio not working

First, try installing **pulseaudio** and **alsa-plugins-pulseaudio**. If you do
not have audio in the videos which play within the Steam client, it is possible
that the ALSA libs packaged with Steam are not working.

If launching Steam from a terminal and attempting to play a video within the
Steam client results in an error similar to **"ALSA lib
pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave"**, there is a
workaround which involves renaming or deleting some Steam runtime folders and
library files. The bugs have already been reported
[here](https://github.com/ValveSoftware/steam-for-linux/issues/3376) and
[here](https://github.com/ValveSoftware/steam-for-linux/issues/3504).

The solution is to rename or delete the `alsa-lib` folder and the
`libasound.so.*` files. They can be found in
`~/.steam/steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/`.

### Game specific

#### BattleBlock Theater

If the game will not launch, you have to install the the following dependencies:

```
# xbps-install -Sy SDL2 libopenal
```

In you are using a **x86_64** system you have to install the 32-bit versions
too:

```
# xbps-install -Sy SDL2-32bit libopenal-32bit
```

You can debug the game running it with **sh**. Find the starter here:

```
~/.local/share/Steam/steamapps/common/BattleBlock\ Theater/BattleBlockTheater.sh
```

If you get an error that looks like the following:

```
DEBUG: Steam checks done
DEBUG: Built  Dec 17 2014  17:44:59
DEBUG: InitGame started
BattleBlockTheater: /media/BGBS/BBT_Linux/Core/MemorySystem.cpp:161: void* MemoryBlock::Alloc(unsigned int): Assertion `(!"Got request for zero bytes!")' failed.
Aborted
```

the recommended way to fix this is to apply the patch posted [on the Steam
forums](https://steamcommunity.com/app/238460/discussions/1/451848855012217196/?ctp=3).
Create a file named `patch.sh` on
`~/.local/share/Steam/steamapps/common/BattleBlock\ Theater/`, with this
content:

```
#!/usr/bin/env bash

FILE=BattleBlockTheater
MD5_PRE=436e91811d8a38de1918991969347b3d
MD5_POST=71eb6519233b21d85c858b39f2b4871f
OFFSET=0x24f2b9
PAYLOAD='\x90\x90'

function getMD5()
{
  echo $(md5sum "${1}" | cut -d ' ' -f 1)
}

if [[ ${MD5_PRE} != $(getMD5 ${FILE}) ]]
  then
    echo Input has wrong checksum. Already patched?
    exit 11
fi

echo -ne ${PAYLOAD} | dd if=/dev/stdin of="${FILE}" bs=1 conv=notrunc seek=$((${OFFSET})) status=none

if [[ $? != 0 ]]
  then
    echo Patching binary failed.
    exit 77
fi

if [[ ${MD5_POST} != $(getMD5 ${FILE}) ]]
  then
    echo Output has wrong checksum. Expect trouble!
    exit 22
fi

echo Yay... everything went well.
```

Turn it into an executable and patch the game:

```
$ chmod a+x patch.sh
$ ./patch.sh
```

Set Launch Options on Properties: `MALLOC_CHECK_=0 %command%`. Everything should
work fine now.

#### Dota 2

If you have troubles running Dota from Steam due to host libraries used try
with:

```
$ STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0 steam
```
