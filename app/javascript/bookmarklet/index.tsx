import { render } from "preact";
import { App } from "./app";
import styles from "./styles.css";

// Prevent double injection
if (window.__KLAXON_BOOKMARKLET__) {
  console.warn("Klaxon bookmarklet already active");
} else {
  window.__KLAXON_BOOKMARKLET__ = true;

  // Host and Shadow DOM
  const host = document.createElement("div");
  host.id = "__klaxon_host__";
  host.style.all = "initial"; // Reset all styles to prevent interference
  document.body.appendChild(host);

  const shadow = host.attachShadow({ mode: "open" });

  // Inject CSS
  const styleTag = document.createElement("style");
  styleTag.textContent = styles;
  shadow.appendChild(styleTag);

  // Mount Preact
  const root = document.createElement("div");
  shadow.appendChild(root);

  function destroy() {
    render(null, root);
    host.remove();
    window.__KLAXON_BOOKMARKLET__ = false;
  }

  render(<App onDismiss={destroy} host={__KLAXON_HOST__} />, root);
}
