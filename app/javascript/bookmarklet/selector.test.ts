import { describe, it, expect, afterEach } from "vitest";
import { cssSelector } from "./selector";

function setBody(html: string) {
  document.body.innerHTML = html;
}

describe("cssSelector", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("returns #id for an element with a unique id", () => {
    setBody('<div id="unique">hello</div>');
    const el = document.getElementById("unique")!;
    expect(cssSelector(el)).toBe("#unique");
  });
});
