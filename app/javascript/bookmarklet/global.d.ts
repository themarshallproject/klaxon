interface Window {
  __KLAXON_BOOKMARKLET__: boolean | undefined;
}

declare var __KLAXON_HOST__: string;

declare module "*.css" {
  const content: string;
  export default content;
}
