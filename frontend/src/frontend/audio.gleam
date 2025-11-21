pub type Audio

@external(javascript, "./audio_ffi.js", "audio_new")
pub fn new(src: String) -> Audio

@external(javascript, "./audio_ffi.js", "audio_play")
pub fn play(audio: Audio) -> Audio

@external(javascript, "./audio_ffi.js", "audio_pause")
pub fn pause(audio: Audio) -> Audio

@external(javascript, "./audio_ffi.js", "audio_duration")
pub fn duration(audio: Audio) -> Int

@external(javascript, "./audio_ffi.js", "audio_playtime")
pub fn playtime(audio: Audio) -> Int
