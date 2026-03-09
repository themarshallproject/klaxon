interface Window {
  __KLAXON_BOOKMARKLET__: boolean | undefined;
}

declare module "*.css" {
  const content: string;
  export default content;
}
