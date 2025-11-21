import lustre/attribute as attr
import lustre/element
import lustre/element/svg

pub fn music_note(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "m9 9 10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-.99-3.467l2.31-.66a2.25 2.25 0 0 0 1.632-2.163Zm0 0V2.25L9 5.25v10.303m0 0v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 0 1-.99-3.467l2.31-.66A2.25 2.25 0 0 0 9 15.553Z",
        ),
      ]),
    ],
  )
}

pub fn tag(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z",
        ),
      ]),
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute("d", "M6 6h.008v.008H6V6Z"),
      ]),
    ],
  )
}

pub fn folder(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M2.25 12.75V12A2.25 2.25 0 0 1 4.5 9.75h15A2.25 2.25 0 0 1 21.75 12v.75m-8.69-6.44-2.12-2.12a1.5 1.5 0 0 0-1.061-.44H4.5A2.25 2.25 0 0 0 2.25 6v12a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18V9a2.25 2.25 0 0 0-2.25-2.25h-5.379a1.5 1.5 0 0 1-1.06-.44Z",
        ),
      ]),
    ],
  )
}

pub fn user(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z",
        ),
      ]),
    ],
  )
}

pub fn x_mark(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute("d", "M6 18 18 6M6 6l12 12"),
      ]),
    ],
  )
}

pub fn play(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.347a1.125 1.125 0 0 1 0 1.972l-11.54 6.347a1.125 1.125 0 0 1-1.667-.986V5.653Z",
        ),
      ]),
    ],
  )
}

pub fn pause(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute("d", "M15.75 5.25v13.5m-7.5-13.5v13.5"),
      ]),
    ],
  )
}

pub fn ellipsis(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M6.75 12a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM12.75 12a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0ZM18.75 12a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z",
        ),
      ]),
    ],
  )
}

pub fn plus(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute("d", "M12 4.5v15m7.5-7.5h-15"),
      ]),
    ],
  )
}

pub fn bars(attrs: List(attr.Attribute(a))) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "2"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute("d", "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"),
      ]),
    ],
  )
}

pub fn forward(attrs: List(attr.Attribute(a))) -> element.Element(a) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "1.5"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M3 8.689c0-.864.933-1.406 1.683-.977l7.108 4.061a1.125 1.125 0 0 1 0 1.954l-7.108 4.061A1.125 1.125 0 0 1 3 16.811V8.69ZM12.75 8.689c0-.864.933-1.406 1.683-.977l7.108 4.061a1.125 1.125 0 0 1 0 1.954l-7.108 4.061a1.125 1.125 0 0 1-1.683-.977V8.69Z",
        ),
      ]),
    ],
  )
}

pub fn backward(attrs: List(attr.Attribute(a))) -> element.Element(a) {
  svg.svg(
    [
      attr.attribute("xmlns", "http://www.w3.org/2000/svg"),
      attr.attribute("fill", "none"),
      attr.attribute("viewBox", "0 0 24 24"),
      attr.attribute("stroke-width", "1.5"),
      attr.attribute("stroke", "currentColor"),
      ..attrs
    ],
    [
      svg.path([
        attr.attribute("stroke-linecap", "round"),
        attr.attribute("stroke-linejoin", "round"),
        attr.attribute(
          "d",
          "M21 16.811c0 .864-.933 1.406-1.683.977l-7.108-4.061a1.125 1.125 0 0 1 0-1.954l7.108-4.061A1.125 1.125 0 0 1 21 8.689v8.122ZM11.25 16.811c0 .864-.933 1.406-1.683.977l-7.108-4.061a1.125 1.125 0 0 1 0-1.954l7.108-4.061a1.125 1.125 0 0 1 1.683.977v8.122Z",
        ),
      ]),
    ],
  )
}
