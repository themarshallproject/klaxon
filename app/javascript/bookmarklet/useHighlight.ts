import { useEffect } from "preact/hooks";
import { useSignal, Signal } from "@preact/signals";
import { cssSelector } from "./selector";

const EXCLUDED_IDS = ["__klaxon_host__"] as const;

function isBookmarkletElement(el: Element): boolean {
  return EXCLUDED_IDS.some((id) => el.id === id || !!el.closest("#" + id));
}

export interface OverlayRect {
  top: number;
  left: number;
  width: number;
  height: number;
}

export function useHighlight(): {
  selector: Signal<string>;
  locked: Signal<boolean>;
  unlock: () => void;
  stepUp: () => void;
  canStepUp: Signal<boolean>;
  rect: Signal<OverlayRect | null>;
} {
  const selector = useSignal("");
  const locked = useSignal(false);
  const rect = useSignal<OverlayRect | null>(null);
  const currentElement = useSignal<Element | null>(null);
  const canStepUp = useSignal(false);

  useEffect(() => {
    function setRect(el: Element) {
      const r = el.getBoundingClientRect();
      rect.value = {
        top: r.top + window.scrollY,
        left: r.left + window.scrollX,
        width: r.width,
        height: r.height,
      };
    }

    let rafPending = false;
    function onMouseMove(e: MouseEvent) {
      if (locked.value || rafPending) return;
      rafPending = true;
      requestAnimationFrame(() => {
        rafPending = false;
        if (locked.value) return;
        if (!(e.target instanceof Element)) return;
        const target = e.target;
        if (isBookmarkletElement(target)) {
          rect.value = null;
          return;
        }
        selector.value = cssSelector(target);
        currentElement.value = target;
        setRect(target);
      });
    }

    function onClick(e: MouseEvent) {
      if (locked.value) return;
      if (!(e.target instanceof Element)) return;
      const target = e.target;
      if (isBookmarkletElement(target)) return;
      e.preventDefault();
      e.stopImmediatePropagation();
      selector.value = cssSelector(target);
      currentElement.value = target;
      canStepUp.value = target.parentElement != null;
      setRect(target);
      locked.value = true;
    }

    function onMouseOut(e: MouseEvent) {
      if (locked.value) return;
      if (!e.relatedTarget) {
        rect.value = null;
        selector.value = "";
      }
    }

    document.addEventListener("mousemove", onMouseMove, true);
    document.addEventListener("click", onClick, true);
    document.addEventListener("mouseout", onMouseOut, true);

    return () => {
      document.removeEventListener("mousemove", onMouseMove, true);
      document.removeEventListener("click", onClick, true);
      document.removeEventListener("mouseout", onMouseOut, true);
    };
  }, []);

  function unlock() {
    locked.value = false;
    selector.value = "";
    rect.value = null;
    currentElement.value = null;
    canStepUp.value = false;
  }

  function stepUp() {
    const el = currentElement.value;
    if (!el?.parentElement) return;
    const parent = el.parentElement;
    currentElement.value = parent;
    selector.value = cssSelector(parent);
    canStepUp.value = parent.parentElement != null;
    const r = parent.getBoundingClientRect();
    rect.value = {
      top: r.top + window.scrollY,
      left: r.left + window.scrollX,
      width: r.width,
      height: r.height,
    };
  }

  return { selector, locked, unlock, stepUp, canStepUp, rect };
}
