interface AppProps {
  shadow: ShadowRoot;
}

export function App({ shadow }: AppProps) {
  function dismiss() {
    const host = shadow.host as HTMLElement;
    host.parentNode?.removeChild(host);
    window.__KLAXON_BOOKMARKLET__ = false;
  }

  return (
    <div class="panel">
      <p>Klaxon Bookmarklet</p>
      <button onClick={dismiss}>Close</button>
    </div>
  );
}
