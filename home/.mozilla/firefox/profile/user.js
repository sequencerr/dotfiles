user_pref('accessibility.typeaheadfind.enablesound', false);
user_pref('extensions.screenshots.disabled', true);
user_pref('ui.key.menuAccessKeyFocuses', false);
user_pref('browser.quitShortcut.disabled', true);
user_pref('devtools.selfxss.count', 6); // https://www.reddit.com/r/firefox/comments/jbvog6/comment/g8zftf9
user_pref('extensions.formautofill.creditCards.enabled', false);
user_pref('browser.aboutConfig.showWarning', false);
user_pref('signon.rememberSignons', false);
user_pref('extensions.pocket.enabled', false);
user_pref('browser.sessionstore.resume_from_crash', true);
user_pref('ui.context_menus.after_mouseup', true);
user_pref('browser.startup.page', 3); // https://github.com/mozilla/gecko-dev/blob/91112db840238a7dfc15361f4762ba8bf4560806/browser/components/preferences/main.js#L242
user_pref('identity.fxaccounts.enabled', false);

user_pref('dom.webnotifications.enabled', false);
user_pref('dom.webnotifications.enabled', false);
user_pref('dom.webnotifications.serviceworker.enabled', false);
user_pref('dom.pushconnection.enabled', false);
user_pref('dom.push.enabled', false);
user_pref('services.sync.prefs.sync.dom.webnotifications.enabled', true);
user_pref('services.sync.prefs.sync.dom.webnotifications.serviceworker.enabled', true);
user_pref('services.sync.prefs.sync.dom.pushconnection.enabled', true);
user_pref('services.sync.prefs.sync.dom.push.enabled', true);
user_pref(
	'general.useragent.override',
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0'
);
