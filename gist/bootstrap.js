// bootstrap.js

require("@babel/polyfill");
const polyfills = require("./polyfills.js");
const gtm = require("./gtm.js");
const componentLoader = require("./componentLoader.js");
const renderElmApp = require("./renderElmApp.js");

componentLoader()

polyfills()
  .then(() => {
    return modernizer()
      .then(() => {
        return renderElmApp("Main", flags)
          .then(app => flags.tracking ? gtm() : r)
        })
      .catch(renderElmApp("Outdated", {}))
  })
  .catch(() => alert("Someting went wrong, sorry"))



// polyfills.js

Promise.all([
  loadScript(supportsCustomElements, "path/to/polyfill/custom-event.js"),
])

function supportCustomElements() {}
