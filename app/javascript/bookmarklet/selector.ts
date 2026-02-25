function isUnique(selector: string): boolean {
  return document.querySelectorAll(selector).length === 1;
}

export function cssSelector(el: Element): string {
  // If the element has a unique ID, use it
  if (el.id) {
    const idSelector = "#" + CSS.escape(el.id);
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
  while (current && current !== document.body && segments.length < 6) {
    const tag = current.tagName.toLowerCase();
    const classes = Array.from(current.classList)
      .filter((c) => /^[a-z_-][a-z0-9_-]*$/i.test(c))
      .map((c) => "." + CSS.escape(c))
      .join("");

    let segment = tag + classes;

    // Check if this segment is unique enough so far
    const testSelector = [segment, ...segments].join(" > ");
    if (isUnique(testSelector)) {
      segments.unshift(segment);
      break;
    }

    // If classes don't disambiguate, add nth-child
    if (current.parentElement) {
      const siblings = Array.from(current.parentElement.children).filter(
        (s) => s.tagName === current!.tagName,
      );
      if (siblings.length > 1) {
        const nth = siblings.indexOf(current as HTMLElement) + 1;
        segment = tag + `:nth-of-type(${nth})`;
      }
    }

    segments.unshift(segment);
    current = current.parentElement;

    // Exit if we have a unique selector
    const candidate = segments.join(" > ");
    if (isUnique(candidate)) {
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
  return result;
}
