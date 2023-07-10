# Multimedia

## Audio setup

To setup audio on your Void Linux system you have to decide if you want to use
[PulseAudio](./pulseaudio.md), [PipeWire](./pipewire.md) or just
[ALSA](./alsa.md). Sndio is also available, but is neither supported nor
recommended.

Some applications require PulseAudio, especially closed source programs, but
[PipeWire](./pipewire.md) provides a drop-in replacement for PulseAudio.

If [elogind](../session-management.md) is not enabled, it is necessary to be in
the `audio` group in order to have access to audio devices.
