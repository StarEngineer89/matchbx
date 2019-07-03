/*global jQuery, enquire, document, window, browser, whatInput, history */
jQuery(function () {
	"use strict";
	var
		$ = jQuery.noConflict(),
		html_tag = $(document.documentElement),
		body_tag = $(document.getElementsByTagName('body')),

		nav_id = $(document.getElementById('nav')),
		up_id = $(document.getElementById('up')),
		skip_id = $(document.getElementById('skip')),
		top_id = $(document.getElementById('top')),

		a_tag_anchor = $(document.getElementsByTagName('a')).filter('[href^="#"]:not([data-popup], [href="#nav"], [href="#mobile"], [href="#"])'),
		a_tag_external = $(document.querySelectorAll('a[rel*="external"]')),
		form_children = $(document.querySelectorAll('form > *')),

		list_popup = $(document.getElementsByClassName('list-popup')),
		module_popup = $(document.getElementsByClassName('module-popup')),
		Default = {
			async: {
				links: function () {
					if (a_tag_external.length) {
						a_tag_external.on('click', function (e) {
							e.preventDefault();
							window.open($(this).attr('href'));
						}).attr('rel', 'external noopener');
					}
					if (skip_id.length) {
						skip_id.find('a').attr('aria-hidden', true).on('focus', function () {
							$(this).attr('aria-hidden', false);
						}).on('blur', function () {
							$(this).attr('aria-hidden', true);
						});
					}
				},
				forms: function () {
					if (form_children.length) {
						form_children.each(function (k, v) {
							$(v).css('z-index', (form_children.length - k));
						});
					}
				},
				mobile: function () {
					if (browser.mobile) {
						html_tag.addClass('mobile');
					} else {
						if (a_tag_anchor.length) {
							a_tag_anchor.on('click', function (e) {
								html_tag.add(body_tag).animate({
									'scrollTop': $($(this).attr('href')).offset().top
								}, 500);
								if (whatInput.ask() === 'mouse') {
									e.preventDefault();
								}
							});
						}
					}
				},
				nav: function () {
					top_id.append('<a href="#mobile" class="menu" role="button" aria-controls="mobile" aria-expanded="false" data-target="#mobile"></a>').after('<nav id="mobile" aria-expanded="false" focusable="false" aria-hidden="true"></nav><a href="#mobile" id="shadow" role="button" tabindex="-1">Close</a>');
					var mobile_id = $(document.getElementById('mobile')),
						shadow_id = $(document.getElementById('shadow'));
					up_id.children().clone().appendTo(mobile_id);
					mobile_id.find('a').attr('tabindex', -1).removeAttr('accesskey');
					top_id.children('.menu').add('a[href="#mobile"]').add(shadow_id).attr('href', '#mobile').on('click', function () {
						if (html_tag.is('.menu-active')) {
							html_tag.removeClass('menu-active');
							mobile_id.attr({
								'aria-hidden': true,
								'focusable': false
							}).find('a').attr('tabindex', -1);
							top_id.children('.menu').attr('aria-expanded', false);
							shadow_id.attr('tabindex', -1);
							history.replaceState(null, null, ' ');
							return false;
						} else {
							html_tag.addClass('menu-active');
							mobile_id.attr({
								'aria-hidden': false,
								'focusable': true
							}).find('a').removeAttr('tabindex');
							top_id.children('.menu').attr('aria-expanded', true);
							shadow_id.removeAttr('tabindex');
							document.location.hash = $(this).attr('href').split('#')[1];
						}
						up_id.find('li.toggle').removeClass('toggle');
					});
					mobile_id.each(function () {
						$(this).find('li > ul').parent().addClass('sub').each(function () {
							$(this).children('a:first').after('<a class="toggle" tabindex="-1" href="' + $(this).children('a:first').attr('href') + '">Toggle ' + $(this).children('a:first').text() + '</a>');
						}).children('a.toggle').on('click', function () {
							if ($(this).parent().is('.toggle')) {
								$(this).attr('aria-expanded', false).parent().removeClass('toggle').children('ul').attr({
									'aria-hidden': true,
									'focusable': false
								});
							} else {
								$(this).attr('aria-expanded', true).parent().addClass('toggle').children('ul').attr({
									'aria-hidden': false,
									'focusable': true
								});
							}
							return false;
						});
					});
					if (nav_id.length) {
						html_tag.addClass('has-nav');
					}
				},
				responsive: function () {
					var desktop_hide = $(document.getElementsByClassName('desktop-hide')),
						desktop_only = $(document.getElementsByClassName('desktop-only')),
						tablet_hide = $(document.getElementsByClassName('tablet-hide')),
						tablet_only = $(document.getElementsByClassName('tablet-only')),
						mobile_hide = $(document.getElementsByClassName('mobile-hide')),
						mobile_only = $(document.getElementsByClassName('mobile-only'));

					enquire.register('screen and (min-width: 1001px)', function () {
						if (desktop_only.length || tablet_hide.length || mobile_hide.length) {
							desktop_only.add(tablet_hide).add(mobile_hide).ariaRemove();
						}
						if (desktop_hide.length || tablet_only.length || mobile_only.length) {
							desktop_hide.add(tablet_only).add(mobile_only).ariaAdd();
						}
					}).register('screen and (min-width: 761px) and (max-width: 1000px)', function () {
						if (desktop_hide.length || tablet_only.length || mobile_hide.length) {
							desktop_hide.add(tablet_only).add(mobile_hide).ariaRemove();
						}
						if (desktop_only.length || tablet_hide.length || mobile_only.length) {
							desktop_only.add(tablet_hide).add(mobile_only).ariaAdd();
						}
					}).register('screen and (max-width: 760px)', function () {
						if (desktop_hide.length || tablet_hide.length || mobile_only.length) {
							desktop_hide.add(tablet_hide).add(mobile_only).ariaRemove();
						}
						if (desktop_only.length || tablet_only.length || mobile_hide.length) {
							desktop_only.add(tablet_only).add(mobile_hide).ariaAdd();
						}
						if (skip_id.length) {
							skip_id.find('a[href="#nav"], a[href="#mobile"]').attr('href', '#mobile');
						}
					}).register('screen and (min-width: 761px)', function () {
						if (skip_id.length) {
							skip_id.find('a[href="#nav"], a[href="#mobile"]').attr('href', '#nav');
						}
					});
				},
				miscellaneous: function () {
					if (list_popup.length) {
						list_popup.find('li').append('<a class="close" href="./">Close</a>').children('a.close').on('click', function () {
							$(this).closest('li').addClass('remove');
							if (!$(this).closest('.module-popup').find('.list-popup li:not(.remove)').length) {
								$(this).closest('.module-popup').removeClass('toggle');
							}
							$(this).closest('.list-popup').find('li.remove').remove();
							return false;
						});
					}
					if (module_popup.length) {
						module_popup.find('.link-icon a').on('click', function () {
							$(this).closest('.module-popup').toggleClass('toggle');
							return false;
						});
					}
					if ($(window).scrollTop() <= 0) {
						html_tag.removeClass('not-top');
					} else {
						html_tag.addClass('not-top');
					}
					$(window).on('scroll touchmove', function () {
						if ($(window).scrollTop() <= 0) {
							html_tag.removeClass('not-top');
						} else {
							html_tag.addClass('not-top');
						}
					});
				}
			}

		};

	Default.async.links();
	Default.async.forms();
	Default.async.miscellaneous();
	Default.async.nav();
	Default.async.responsive();
});

/*!*/
