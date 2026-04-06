/* app.js - Tau Prolog session management and query runner for Time Machine web app */

(function () {
  'use strict';

  var session = null;
  var outputEl, statusEl;

  // ── Helpers ────────────────────────────────────────────────────────────────

  function appendOutput(text, cls) {
    var line = document.createElement('div');
    if (cls) line.className = cls;
    line.textContent = text;
    outputEl.appendChild(line);
    outputEl.scrollTop = outputEl.scrollHeight;
  }

  function setStatus(text, cls) {
    statusEl.textContent = text;
    statusEl.className = 'status ' + (cls || '');
  }

  // Fetch a URL and return the response text (Promise).
  function fetchText(url) {
    return fetch(url).then(function (r) {
      if (!r.ok) throw new Error('HTTP ' + r.status + ': ' + url);
      return r.text();
    });
  }

  // Wrap session.consult (callback API) in a Promise.
  function consultSource(src, label) {
    return new Promise(function (resolve, reject) {
      session.consult(src, {
        success: function () { resolve(label); },
        error: function (err) { reject(new Error('consult ' + label + ': ' + err)); }
      });
    });
  }

  // Wrap session.query in a Promise.
  function prologQuery(goal) {
    return new Promise(function (resolve, reject) {
      session.query(goal, {
        success: function () { resolve(); },
        error: function (err) { reject(new Error('query: ' + err)); }
      });
    });
  }

  // Collect answers until false/fail/limit, return array of formatted strings.
  function collectAnswers(limit) {
    limit = limit || 100;
    var answers = [];
    return new Promise(function (resolve) {
      function next() {
        if (answers.length >= limit) { resolve(answers); return; }
        session.answer({
          success: function (ans) {
            var str = pl.format_answer(ans);
            answers.push(str);
            next();
          },
          error: function (err) {
            answers.push('ERROR: ' + err);
            resolve(answers);
          },
          fail: function () { resolve(answers); },
          limit: function () {
            answers.push('(inference limit reached)');
            resolve(answers);
          }
        });
      }
      next();
    });
  }

  // ── Initialisation ─────────────────────────────────────────────────────────

  async function init() {
    setStatus('Initialising Tau Prolog…', 'loading');
    appendOutput('Loading Tau Prolog engine…');

    try {
      // Tau Prolog must already be present via the <script> tag in index.html.
      if (typeof pl === 'undefined') {
        throw new Error('Tau Prolog (pl) is not defined. Check the CDN script tag.');
      }

      session = pl.create(200000);

      appendOutput('Fetching big_medit2-web.pl…');
      var src1 = await fetchText('prolog/big_medit2-web.pl');
      await consultSource(src1, 'big_medit2-web.pl');
      appendOutput('✓ big_medit2-web.pl loaded');

      setStatus('Ready — enter a query below and press Run', 'ready');
      appendOutput('Prolog sources loaded. Try: run.');
      document.getElementById('runBtn').disabled = false;
      document.getElementById('queryInput').disabled = false;
    } catch (e) {
      setStatus('Load error: ' + e.message, 'error');
      appendOutput('ERROR: ' + e.message, 'error');
    }
  }

  // ── Query runner ───────────────────────────────────────────────────────────

  async function runQuery() {
    var raw = document.getElementById('queryInput').value.trim();
    if (!raw) return;

    // Ensure goal ends with a period.
    var goal = raw.endsWith('.') ? raw : raw + '.';

    appendOutput('?- ' + goal, 'query');
    setStatus('Running…', 'loading');

    try {
      await prologQuery(goal);
      var answers = await collectAnswers(200);

      if (answers.length === 0) {
        appendOutput('false.', 'fail');
      } else {
        answers.forEach(function (ans) {
          appendOutput(ans, 'answer');
        });
      }
      setStatus('Done', 'ready');
    } catch (e) {
      appendOutput('ERROR: ' + e.message, 'error');
      setStatus('Error', 'error');
    }
  }

  // ── Entry point ────────────────────────────────────────────────────────────

  window.addEventListener('DOMContentLoaded', function () {
    outputEl = document.getElementById('output');
    statusEl = document.getElementById('status');

    document.getElementById('runBtn').addEventListener('click', runQuery);
    document.getElementById('clearBtn').addEventListener('click', function () {
      outputEl.innerHTML = '';
    });

    // Allow pressing Enter (without Shift) in the query textarea to run.
    document.getElementById('queryInput').addEventListener('keydown', function (e) {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        runQuery();
      }
    });

    // Quick-action buttons.
    document.querySelectorAll('[data-query]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        document.getElementById('queryInput').value = btn.dataset.query;
        runQuery();
      });
    });

    init();
  });
}());
