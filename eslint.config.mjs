import antfu from '@antfu/eslint-config'

export default antfu({
  // Enable YAML support
  yaml: true,
  // Disable other language support we don't need
  typescript: false,
  vue: false,
  react: false,
  svelte: false,
  astro: false,
  toml: false,
  // Enable stylistic formatting
  stylistic: {
    indent: 2,
    quotes: 'single',
    semi: false,
  },
  // Files to ignore
  ignores: [
    '**/node_modules/**',
    '**/.git/**',
    // Upstream config templates contain unrendered %PLACEHOLDERS%.
    'apps/anytype/official/docker-generateconfig/etc/**',
  ],
  // Lint readme files
  markdown: true,
})
