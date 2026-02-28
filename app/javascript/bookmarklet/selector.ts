/** Returns true if the selector matches exactly one element in the document. */
function isUnique(selector: string): boolean {
  return document.querySelectorAll(selector).length === 1;
}

/**
 * Escapes a string for use as a quoted attribute value in a CSS selector.
 * CSS.escape is designed for identifiers; for attribute values in quotes we
 * only need to escape backslashes and double-quotes.
 */
function escapeAttrValue(value: string): string {
  return value.replace(/\\/g, "\\\\").replace(/"/g, '\\"');
}

const SAFE_CLASS_REGEX = /^[a-z0-9_-]+$/i;

/**
 * Returns the element's class names that are safe to use directly in a CSS
 * selector — i.e. contain only letters, digits, hyphens, and underscores.
 */
function getValidClasses(el: Element): string[] {
  return Array.from(el.classList).filter((c) => SAFE_CLASS_REGEX.test(c));
}

/**
 * Returns a CSS selector for the given ID. Uses the `#id` shorthand when
 * the ID needs no escaping, and falls back to `[id="..."]` because we
 * cannot count on the tool using this to be escape string friendly.
 */
function makeIdSelector(id: string): string {
  if (CSS.escape(id) === id) {
    return `#${id}`;
  }

  return `[id="${escapeAttrValue(id)}"]`;
}

function matchesTarget(match: Element | null, el: Element): boolean {
  return (
    match === el ||
    (match?.contains(el) && match.children.length === 1) ||
    false
  );
}

/**
 * Tries to find a short, attribute-based selector that uniquely identifies
 * `el` without walking the DOM tree. Checks (in order):
 * 1. unique ID
 * 2. data-* + role/aria-label/name attributes
 * 3. tag alone
 * 4. tag + single class
 * 5. single class alone
 */
function trySimpleSelectors(el: Element): string | null {
  // Unique ID
  if (el.id) {
    const idSelector = makeIdSelector(el.id);

    if (isUnique(idSelector)) {
      return idSelector;
    }
  }

  // data-* and named attributes
  const attrs: [string, string][] = [];

  for (const attr of Array.from(el.attributes)) {
    if (attr.name.startsWith("data-")) attrs.push([attr.name, attr.value]);
  }

  for (const name of ["role", "aria-label", "name"]) {
    const val = el.getAttribute(name);
    if (val) attrs.push([name, val]);
  }

  for (const [name, val] of attrs) {
    const candidate = `[${name}="${escapeAttrValue(val)}"]`;
    if (isUnique(candidate)) return candidate;
  }

  const tag = el.tagName.toLowerCase();

  // Tag-only selector
  if (isUnique(tag)) {
    return tag;
  }

  const validClasses = getValidClasses(el);

  // Tag + single class
  for (const cls of validClasses) {
    const candidate = `${tag}.${CSS.escape(cls)}`;

    if (isUnique(candidate)) {
      return candidate;
    }
  }

  // Single class alone
  for (const cls of validClasses) {
    const candidate = `.${CSS.escape(cls)}`;

    if (isUnique(candidate)) {
      return candidate;
    }
  }

  return null;
}

function* classCombos(classes: string[]): Generator<string[]> {
  for (const c of classes) yield [c];
  for (let i = 0; i < classes.length; i++)
    for (let j = i + 1; j < classes.length; j++) yield [classes[i], classes[j]];
  if (classes.length > 2) yield classes;
}

/**
 * Builds the selector segment for a single element, using the minimal class
 * combination needed for uniqueness.
 */
function buildSegment(current: Element, validClasses: string[]): string {
  const tag = current.tagName.toLowerCase();

  for (const combo of classCombos(validClasses)) {
    const classStr = combo.map((c) => "." + CSS.escape(c)).join("");
    if (isUnique(tag + classStr)) {
      return tag + classStr;
    }
  }

  const allClasses = validClasses.map((c) => "." + CSS.escape(c)).join("");
  return tag + allClasses;
}

/**
 * Generates the shortest, most stable CSS selector that uniquely identifies
 * `el` in the current document.
 */
export function cssSelector(el: Element): string {
  // If we're at <body>, no need to go further
  if (el === document.body) {
    return "body";
  }

  // See if we're lucky and can get a unique selector without walking the DOM
  const simple = trySimpleSelectors(el);

  if (simple !== null) {
    return simple;
  }

  const segments: string[] = [];
  let current: Element | null = el;

  // Big loop of death
  while (current && current !== document.body) {
    // Anchor to nearest unique-ID ancestor (skipping itself)
    if (current !== el && current.id) {
      const idSelector = makeIdSelector(current.id);

      if (isUnique(idSelector)) {
        segments.unshift(idSelector);
        break;
      }
    }

    const tag = current.tagName.toLowerCase();
    const validClasses = getValidClasses(current);
    const allClasses = validClasses.map((c) => "." + CSS.escape(c)).join("");

    let segment = buildSegment(current, validClasses);

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
        segment = tag + allClasses + `:nth-of-type(${nth})`;
      }
    }

    segments.unshift(segment);
    current = current.parentElement;

    // Exit if we have a unique selector
    if (isUnique(segments.join(" > "))) {
      break;
    }
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

  let best = segments;

  for (let i = 0; i < best.length; i++) {
    if (best.length <= 1) break;

    const candidate = [...best.slice(0, i), ...best.slice(i + 1)];
    const css = candidate.join(" > ");

    if (!isUnique(css)) continue;

    const match = document.querySelector(css);

    if (matchesTarget(match, el)) {
      best = candidate;
      i--; // retry same index since array shifted
    }
  }

  // Pass 2: Try relaxing child combinators (>) to descendant combinators ( )
  return relaxCombinators(best, el);
}

/**
 * Tries replacing each ` > ` (child combinator) with a space (descendant
 * combinator) if it still uniquely identifies the target element.
 */
function relaxCombinators(segments: string[], el: Element): string {
  const joiners = segments.slice(1).map(() => " > ");

  for (let i = 0; i < joiners.length; i++) {
    if (joiners[i] === " > ") {
      joiners[i] = " ";
      const css = segments.reduce(
        (acc, seg, idx) => acc + joiners[idx - 1] + seg,
      );
      const match = document.querySelector(css);

      if (!isUnique(css) || !matchesTarget(match, el)) {
        joiners[i] = " > ";
      }
    }
  }

  return segments.reduce((acc, seg, i) => acc + joiners[i - 1] + seg);
}
