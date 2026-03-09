import { render } from "preact";
import { App } from "./app";
import styles from "./styles.css";

export function init(host: string) {
  // Prevent double injection
  if (window.__KLAXON_BOOKMARKLET__) {
    console.warn("Klaxon bookmarklet already active");
    return;
  }
  window.__KLAXON_BOOKMARKLET__ = true;

  // Host and Shadow DOM
  const hostEl = document.createElement("div");
  hostEl.id = "__klaxon_host__";
  hostEl.style.all = "initial"; // Reset all styles to prevent interference
  document.body.appendChild(hostEl);

  const shadow = hostEl.attachShadow({ mode: "open" });

  // Inject CSS
  const styleTag = document.createElement("style");
  styleTag.textContent = styles;
  shadow.appendChild(styleTag);

  // Mount Preact
  const root = document.createElement("div");
  shadow.appendChild(root);

  function destroy() {
    render(null, root);
    hostEl.remove();
    window.__KLAXON_BOOKMARKLET__ = false;
  }

  render(<App onDismiss={destroy} host={host} />, root);
}
