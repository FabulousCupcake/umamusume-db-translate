// Put SQL and Database as global variable
let SQL;
let db;

// fetchTranslationJSON returns json containing translation data
// append timestamp to get fresh copy since github pages caching is aggressive
const fetchTranslationJSON = async () => {
  const timestamp = new Date().getTime();
  const body = await fetch(`data.json?${timestamp}`);
  return await body.json();
}

// actuallyInitSqlJs loads wasm files and initializes sql.js
const actuallyInitSqlJs = async () => {
  SQL = await initSqlJs({
    locateFile: file => `${window.sql_wasm_path}/${file}`,
  });
};

// savedb exports the db as a downloadable file to the user
const savedb = db => {
  const downloadURL = (data, fileName) => {
    const a = document.createElement('a')
    a.href = data
    a.download = fileName
    document.body.appendChild(a)
    a.style.display = 'none'
    a.click()
    a.remove()
  }
  const downloadBlob = (data, fileName, mimeType) => {
    const blob = new Blob([data], {
      type: mimeType
    })
    const url = window.URL.createObjectURL(blob)
    downloadURL(url, fileName)
    setTimeout(() => window.URL.revokeObjectURL(url), 1000)
  }

  const data = db.export();
  downloadBlob(data, "master.mdb", "application/x-sqlite3");
};

// process translates the loaded db and exports it
const process = async (db) => {
  const findAndReplaceStatement = db.prepare("UPDATE `text_data` SET `text`=:replace WHERE `text`=:search");
  const data = await fetchTranslationJSON();

  // Search and replace for every item in data.json
  for (const jpText in data) {
    const enText = data[jpText];
    if (!enText) continue; // Skip if enText is empty

    console.log(`Replacing ${jpText} with ${enText}!`);
    findAndReplaceStatement.run({
      ":search":  jpText,
      ":replace": enText,
    });
  }

  // Serve back to user
  savedb(db);
};

// listenFileChange loads picked file as sqlite database
// and fires process() with the loaded db
const listenFileChange = () => {
  const dbFileEl = document.getElementById("dbfile");
  dbFileEl.addEventListener("change", async (e) => {
    const file = dbFileEl.files[0];
    const reader = new FileReader();

    reader.addEventListener("load", () => {
      let uints = new Uint8Array(reader.result);
      db = new SQL.Database(uints);
      process(db);
    });
    reader.readAsArrayBuffer(file);
  });

}

// We need an async main because javascript
const main = async () => {
  await actuallyInitSqlJs();
  listenFileChange();
}

main();
