import { useHighlight } from "./useHighlight";

interface AppProps {
  onDismiss: () => void;
  host: string;
}

export function App({ onDismiss, host }: AppProps) {
  const { selector, locked, unlock, stepUp, canStepUp, rect } = useHighlight();

  function watchThis() {
    const url = new URL("/watching/pages/new", host);
    url.searchParams.set("url", location.href);
    url.searchParams.set("css_selector", selector.value ?? "");
    window.open(url.toString(), "_blank");
  }

  return (
    <>
      {rect.value && (
        <div
          class="highlight-overlay"
          style={{
            top: rect.value.top + "px",
            left: rect.value.left + "px",
            width: rect.value.width + "px",
            height: rect.value.height + "px",
          }}
        />
      )}
      <div class="panel">
        <div class="panel-header">
          <span class="panel-title">Klaxon</span>
          <button class="btn-close" onClick={onDismiss} aria-label="Close">×</button>
        </div>
        <div class="selector-display">
          {selector.value ? (
            <code class="selector-text">{selector}</code>
          ) : (
            <span class="selector-placeholder">Hover over an element to select it</span>
          )}
        </div>
        {locked.value && (
          <div class="btn-row">
            <button class="btn-primary" onClick={watchThis}>Watch this</button>
            {canStepUp.value && (
              <button class="btn-action" onClick={stepUp}>Step up</button>
            )}
            <button class="btn-action" onClick={unlock}>Clear selection</button>
          </div>
        )}
      </div>
    </>
  );
}
