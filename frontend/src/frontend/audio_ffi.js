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
