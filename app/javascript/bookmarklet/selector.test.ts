import { describe, it, expect, afterEach, vi } from "vitest";
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

  it("prefers id over data attribute", () => {
    setBody('<div id="myid" data-role="hero">hi</div>');
    const el = document.getElementById("myid")!;
    expect(cssSelector(el)).toBe("#myid");
  });

  it("returns a data attribute selector when unique", () => {
    setBody('<div><span data-role="hero">hi</span><span>bye</span></div>');
    const el = document.querySelector('[data-role="hero"]')!;
    expect(cssSelector(el)).toBe('[data-role="hero"]');
  });

  it("builds a structural selector when no shortcut is available", () => {
    setBody("<div><section><p>target</p></section></div>");
    const el = document.querySelector("p")!;
    const result = cssSelector(el);
    expect(document.querySelectorAll(result).length).toBe(1);
    expect(document.querySelector(result)).toBe(el);
  });

  it("uses nth-of-type to disambiguate same-tag siblings", () => {
    setBody("<ul><li>a</li><li>b</li><li>c</li></ul>");
    const second = document.querySelectorAll("li")[1];
    const result = cssSelector(second);
    expect(result).toBe("li:nth-of-type(2)");
    expect(document.querySelectorAll(result).length).toBe(1);
    expect(document.querySelector(result)).toBe(second);
  });

  it("includes classes in the selector", () => {
    setBody('<div><span class="foo">a</span><span class="bar">b</span></div>');
    const el = document.querySelector(".bar")!;
    const result = cssSelector(el);
    expect(result).toBe("span.bar");
    expect(document.querySelector(result)).toBe(el);
  });

  it("handles deeply nested elements", () => {
    setBody(`
      <main>
        <div class="hi"><div><div><div><span>deep</span></div></div></div><span></span></div>
      </main>
    `);
    const el = document.querySelector("span")!;
    const result = cssSelector(el);
    expect(result).toBe("div > div > span");
    expect(document.querySelectorAll(result).length).toBe(1);
    expect(document.querySelector(result)).toBe(el);
  });

  it("returns cached result on repeat calls for the same element", () => {
    setBody('<div id="cached">hello</div>');
    const el = document.getElementById("cached")!;
    const first = cssSelector(el);
    // Spy after first call; second call must not touch the DOM
    const spy = vi.spyOn(document, "querySelectorAll");
    const second = cssSelector(el);
    expect(first).toBe(second);
    expect(spy).not.toHaveBeenCalled();
    spy.mockRestore();
  });

  it("optimizes away redundant segments", () => {
    setBody(
      '<div id="outer"><section><article><p>target</p><p>other</p></article></section></div>',
    );
    const el = document.querySelector("#outer p")!;
    const result = cssSelector(el);
    expect(result).toBe("p:nth-of-type(1)");
    // The optimizer should produce something shorter than the full path
    expect(result.split(" > ").length).toBeLessThan(4);
    expect(document.querySelectorAll(result).length).toBe(1);
  });

  it("handles ids starting with a digit via CSS.escape", () => {
    setBody('<div id="3abc">hello</div><div>other</div>');
    const el = document.getElementById("3abc")!;
    const result = cssSelector(el);
    expect(result).not.toBe("#3abc");
    expect(result).toBe("#\\33 abc");
    expect(document.querySelectorAll(result).length).toBe(1);
  });

  it("falls through when id is not unique", () => {
    setBody('<div id="dup"></div><div id="dup" data-testid="second"></div>');
    const el = document.querySelectorAll('[id="dup"]')[1] as Element;
    const result = cssSelector(el);
    // Should not return #dup since it's not unique
    expect(result).not.toBe("#dup");
    expect(result).toBe('[data-testid="second"]');
    // But it should still uniquely select the element
    expect(document.querySelectorAll(result).length).toBe(1);
    expect(document.querySelector(result)).toBe(el);
  });
});
