export function audio_new(src) {
    return new Audio(src);
}

export function audio_play(audio) {
    audio.play();
    return audio;
}

export function audio_pause(audio) {
    audio.pause();
    return audio;
}

export function audio_playtime(audio) {
    return Math.floor(audio.currentTime);
}

export function audio_duration(audio) {
    return Math.floor(audio.duration);
}
