import path from "path";
import { fileURLToPath } from "url";
import { readFile } from "fs/promises";

import * as esbuild from "esbuild";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");

const minifyCssPlugin = {
  name: "minify-css-to-text",
  setup(build) {
    build.onLoad({ filter: /\.css$/ }, async (args) => {
      const source = await readFile(args.path, "utf8");

      // Transform the raw CSS into minified CSS
      const { code } = await esbuild.transform(source, {
        loader: "css",
        minify: true,
      });

      return {
        contents: code,
        loader: "text", // Now it's a minified string
      };
    });
  },
};

// 1. Define your shared configuration
const config = {
  entryPoints: [path.join(root, "app/javascript/bookmarklet/index.tsx")],
  bundle: true,
  format: "iife",
  globalName: "Klaxon",
  platform: "browser",
  minify: true,
  outfile: path.join(root, "public/bookmarklet.js"),
  absWorkingDir: root,
  jsx: "automatic",
  jsxImportSource: "preact",
  plugins: [minifyCssPlugin],
};

// 2. Check for the --watch flag
const isWatch = process.argv.includes("--watch");

if (isWatch) {
  // Create a context for the watcher
  let ctx = await esbuild.context(config);

  await ctx.watch();
  console.log("👀 esbuild is watching for changes in app/javascript...");
} else {
  // Standard one-time build
  await esbuild.build(config);
  console.log("🚀 Build complete!");
}
