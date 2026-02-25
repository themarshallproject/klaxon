import { useHighlight } from "./useHighlight";

interface AppProps {
  onDismiss: () => void;
}

export function App({ onDismiss }: AppProps) {
  const { selector, locked, unlock, rect } = useHighlight();

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
          <button class="btn-clear" onClick={unlock}>Clear selection</button>
        )}
      </div>
    </>
  );
}
