* [x] README
* [-] Types for everything
* [-] Docs for everything
* [-] Clean up opts
  * types
  * meaning
  * config validation
* [-] Clean up commands
  * root command and subcommands instead of multiple commands
* [-] Fix the way the buffer gets opened to something more elegant
* [-] autocmd if no buffers are open - open cheatsheet as a sort of dashboard
* [-] autocmd to rerender on size change
* [-] Doc for plugin
* [-] Proper error reporting
* [-] Logging
* [-] Tests
* [-] Simplify code by using my nvim-core-utils
* [-] Typed state under vim.g instead of a simple table ?
* [-] Better fallback group name
* Rename/move
  * [x] draw to render under ui dir
  * [x] all rendering related files to move under ui dir
* Features
  * [-] (opts) Help line/Legend 
     * the flag icon to <leader> etc.
     * quit key
  * [-] (opts) Show <Plug> keys (is it worth while?)
  * [-] Proper quit key binding 
     * [x] on buf leave
     * [-] on ESC
     * [-] on q
     * [-] additional/override for opts
  * Keymapping
    * [-] (opts) Grouping by prefix (currently called spec)
    * [-] (opts) Manually added mappings (for cases like ad-hoc bindings on buf etc. - whichkey and nvim-cmp case)
  * [-] Expose behavior as keybindings using <Plug>
    * Show/Hide
