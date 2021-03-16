[![Github Pages](https://github.com/FabulousCupcake/umamusume-db-translate/actions/workflows/master.yml/badge.svg)](https://github.com/FabulousCupcake/umamusume-db-translate/actions/workflows/master.yml)

This project aims to create a tool in form of a static webpage to translate the game [Uma Musume Pretty Derby][1] by patching `master.mdb` file, which is easily swappable in Windows / DMM distribution of the game.

To do this, it uses [`sql.js`][2] to manipulate `master.mdb` directly in the browser.

## Usage
The tool can be accessed at https://fabulouscupcake.github.io/umamusume-db-translate/.

## Contributing
Please open a pull-request with the changes!

The translation data sources can be found in csv format in [`src/data/`][3] directory.  
All csv files in it will be merged into a single json file and used to do simple search-and-replace over the `text_data` table in `master.mdb`.

## Development
To generate the final static page, simply run `make`. Note that you need `jq` to be installed.

For local development/testing, simply run a webserver serving the `public` directory output with e.g. [`serve`][4]

```sh
$ make
==> Cleaning project…
==> Converting csv files into a single json…
==> Building static page…
==> Done!

$ npx serve public
┌───────────────────────────────────────────────────┐
│                                                   │
│   Serving!                                        │
│                                                   │
│   - Local:            http://localhost:5000       │
│   - On Your Network:  http://192.168.1.1:5000     │
│                                                   │
│   Copied local address to clipboard!              │
│                                                   │
└───────────────────────────────────────────────────┘

```

[1]: https://umamusume.jp
[2]: https://github.com/sql-js/sql.js
[3]: https://github.com/FabulousCupcake/umamusume-db-translate/tree/master/src/data
[4]: https://www.npmjs.com/package/serve
