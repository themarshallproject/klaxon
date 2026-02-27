const selectorCache = new WeakMap<Element, string>();

function isUnique(selector: string): boolean {
  return document.querySelectorAll(selector).length === 1;
}

export function cssSelector(el: Element): string {
  const cached = selectorCache.get(el);
  if (cached) return cached;

  const result = buildSelector(el);
  selectorCache.set(el, result);
  return result;
}

function buildSelector(el: Element): string {
  if (el === document.body) {
    return "body";
  }

  // If the element has a unique ID, use it
  if (el.id) {
    const idSelector = `#${CSS.escape(el.id)}`;
    // Technically IDs should be unique... but just in case
    if (isUnique(idSelector)) {
      return idSelector;
    }
  }

  // Prefer data-* attributes over structural selectors, more likely to be stable
  for (const attr of Array.from(el.attributes)) {
    if (attr.name.startsWith("data-")) {
      const candidate = `[${attr.name}="${CSS.escape(attr.value)}"]`;
      if (isUnique(candidate)) {
        return candidate;
      }
    }
  }

  const segments: string[] = [];
  let current: Element | null = el;

  // Big loop of death
  while (current && current !== document.body) {
    const tag = current.tagName.toLowerCase();
    const classes = Array.from(current.classList)
      .filter((c) => /^[a-z_-][a-z0-9_-]*$/i.test(c))
      .map((c) => "." + CSS.escape(c))
      .join("");

    let segment = tag + classes;
    let segmentModified = false;

    // Check if this segment is unique enough so far
    const testSelector = [segment, ...segments].join(" > ");
    if (isUnique(testSelector)) {
      segments.unshift(segment);
      break;
    }

    // If classes don't disambiguate, add nth-of-type (preserving classes)
    if (current.parentElement) {
      const siblings = Array.from(current.parentElement.children).filter(
        (s) => s.tagName === current!.tagName,
      );
      if (siblings.length > 1) {
        const nth = siblings.indexOf(current) + 1;
        segment = tag + classes + `:nth-of-type(${nth})`;
        segmentModified = true;
      }
    }

    segments.unshift(segment);
    current = current.parentElement;

    // Exit if we have a unique selector (skip if segment unchanged — already checked above)
    if (segmentModified && isUnique(segments.join(" > "))) {
      break;
    }
  }

  const result = segments.join(" > ");
  if (!isUnique(result)) {
    console.warn(
      "Klaxon bookmarklet could not generate a unique selector; using best-effort:",
      result,
    );
  }
  return optimize(segments, el);
}

function optimize(segments: string[], el: Element): string {
  if (segments.length === 0) {
    return "";
  }

  if (segments.length === 1) {
    return segments[0];
  }

  // Try removing segments to shorten the selector
  let best = segments;
  for (let i = 0; i < best.length; i++) {
    if (best.length <= 1) break;
    const candidate = [...best.slice(0, i), ...best.slice(i + 1)];
    const css = candidate.join(" > ");
    if (!isUnique(css)) continue;
    const match = document.querySelector(css);
    if (match === el || (match?.contains(el) && match.children.length === 1)) {
      best = candidate;
      i--; // retry same index since array shifted
    }
  }

  return best.join(" > ");
}
