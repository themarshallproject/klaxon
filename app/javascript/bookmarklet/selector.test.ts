import { describe, it, expect, afterEach } from "vitest";
import { cssSelector } from "./selector";

function setBody(html: string) {
  document.body.innerHTML = html;
}

describe("cssSelector", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  describe("ID selectors", () => {
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

    it("uses [id=] attribute selector for ids that would need CSS escaping", () => {
      setBody('<div id="3abc">hello</div><div>other</div>');
      const el = document.getElementById("3abc")!;
      const result = cssSelector(el);
      expect(result).toBe('[id="3abc"]');
    });

    it("falls through when id is not unique", () => {
      setBody('<div id="dup"></div><div id="dup" data-testid="second"></div>');
      const el = document.querySelectorAll('[id="dup"]')[1] as Element;
      const result = cssSelector(el);
      // Should not return #dup since it's not unique
      expect(result).not.toBe("#dup");
      expect(result).toBe('[data-testid="second"]');
    });
  });

  describe("attribute selectors", () => {
    it("returns a data attribute selector when unique", () => {
      setBody('<div><span data-role="hero">hi</span><span>bye</span></div>');
      const el = document.querySelector('[data-role="hero"]')!;
      expect(cssSelector(el)).toBe('[data-role="hero"]');
    });

    it("uses role attribute as a unique selector", () => {
      setBody('<div><nav role="navigation">menu</nav><div>other</div></div>');
      const el = document.querySelector("[role]")!;
      const result = cssSelector(el);
      expect(result).toBe('[role="navigation"]');
    });

    it("uses aria-label attribute as a unique selector", () => {
      setBody(
        '<div><button aria-label="Close dialog">X</button><button>OK</button></div>',
      );
      const el = document.querySelector("[aria-label]")!;
      const result = cssSelector(el);
      expect(result).toBe('[aria-label="Close dialog"]');
    });
  });

  describe("tag and class selectors", () => {
    it("uses tag-only selector when element is unique by tag", () => {
      setBody("<div><main><p>content</p></main></div>");
      const el = document.querySelector("main")!;
      const result = cssSelector(el);
      expect(result).toBe("main");
    });

    it("includes classes in the selector", () => {
      setBody('<div><span class="foo">a</span><span class="bar">b</span></div>');
      const el = document.querySelector(".bar")!;
      const result = cssSelector(el);
      expect(result).toBe("span.bar");
    });

    it("includes classes starting with a digit in selectors", () => {
      setBody(
        '<div><span class="123-unique">a</span><span class="other">b</span></div>',
      );
      const el = document.querySelector('[class="123-unique"]') as Element;
      const result = cssSelector(el);
      expect(result).toContain("\\31 23-unique");
    });

    it("prefers single class over all classes", () => {
      setBody(
        '<div><span class="foo bar baz unique-class">a</span><span class="foo bar baz other">b</span></div>',
      );
      const el = document.querySelector(".unique-class")!;
      const result = cssSelector(el);
      // Should use single unique class rather than all four
      expect(result).toBe("span.unique-class");
    });
  });

  describe("structural path", () => {
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
    });

    it("handles deeply nested elements", () => {
      setBody(`
        <main>
          <div class="hi"><div><div><div><span>deep</span></div></div></div><span></span></div>
        </main>
      `);
      const el = document.querySelector("span")!;
      const result = cssSelector(el);
      expect(document.querySelectorAll(result).length).toBe(1);
      expect(document.querySelector(result)).toBe(el);
    });

    it("anchors to nearest unique-ID ancestor", () => {
      setBody(
        '<div><aside id="sidebar"><ul><li>a</li><li>b</li></ul></aside><div><ul><li>c</li><li>d</li></ul></div></div>',
      );
      const el = document.querySelectorAll("li")[1];
      const result = cssSelector(el);
      // Should anchor at #sidebar rather than walking up to body
      expect(result).toContain("#sidebar");
      expect(document.querySelectorAll(result).length).toBe(1);
      expect(document.querySelector(result)).toBe(el);
    });
  });

  describe("optimizer", () => {
    it("optimizes away redundant segments", () => {
      setBody(
        '<div id="outer"><section><article><p>target</p><p>other</p></article></section></div>',
      );
      const el = document.querySelector("#outer p")!;
      const result = cssSelector(el);
      expect(result).toBe("p:nth-of-type(1)");
    });

    it("uses descendant combinator when child combinator is unnecessary", () => {
      setBody(`
        <div>
          <section><p>first</p><p>second</p></section>
          <p>third</p>
        </div>
      `);
      const el = document.querySelector("p")!;
      const result = cssSelector(el);
      expect(result).toBe("section p:nth-of-type(1)");
      expect(document.querySelectorAll(result).length).toBe(1);
      expect(document.querySelector(result)).toBe(el);
    });
  });
});
