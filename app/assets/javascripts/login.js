/**
 * This code is run to update the bookmarklet about logged-in status.
 * The iframe listens to localStorage events and refreshes if a change
 * is detected.
 */

function hasStorage(type) {
  try {
    var storage = window[type],
      x = '__storage_test__';
    storage.setItem(x, x);
    storage.removeItem(x);
    return true;
  }
  catch(e) {
    return false;
  }
}

// http://stackoverflow.com/questions/326069/how-to-identify-if-a-webpage-is-being-loaded-inside-an-iframe-or-directly-into-t
function inIframe() {
  try {
    return window.self !== window.top;
  } catch (e) {
    return true;
  }
}

var KLAXON_LOGIN_KEY = 'klaxon-login';

if (hasStorage('localStorage')) {

  if (window.klaxonUser) {
    window.localStorage.setItem(KLAXON_LOGIN_KEY, true);
  }

  if (inIframe()) {
    window.addEventListener('storage', function(event) {
      console.log(event)
      if (event.key !== KLAXON_LOGIN_KEY) {
        return;
      }

      if (window.localStorage.getItem(KLAXON_LOGIN_KEY) === 'true'
        && window.location.pathname !== '/embed/iframe') {
        console.log('hit it here')
        document.location.href = window.klaxonReturnUrl;
        //window.location.reload();
      }
    });
  }
}
