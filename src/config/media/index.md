# Multimedia

## Audio setup

To setup audio on your Void Linux system you have to decide if you want to use
[PulseAudio](./pulseaudio.md), [PipeWire](./pipewire.md) or just
[ALSA](./alsa.md).

Some applications require PulseAudio, especially closed source programs, but
[PipeWire](./pipewire.md) provides a drop-in replacement for PulseAudio.

If no [seat manager](../session-management.md) is enabled, it is necessary to be in
the `audio` group in order to have access to audio devices.
